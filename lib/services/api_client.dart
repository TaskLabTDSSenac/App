import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../exceptions/api_exception.dart';

class ApiClient {
  final http.Client client;
  final String baseUrl;
  final Duration timeout;
  String? _token;
  int generation = 0;
  void Function()? onUnauthorized;
  ApiClient({
    required this.client,
    required this.baseUrl,
    this.timeout = const Duration(seconds: 15),
  });
  String? get token => _token;
  set token(String? value) {
    _token = value;
    generation++;
  }

  Future<dynamic> request(
    String method,
    String path, {
    Map<String, dynamic>? data,
    bool authenticated = true,
  }) async {
    final version = generation;
    final headers = <String, String>{'Accept': 'application/json'};
    if (authenticated) {
      if (_token == null) {
        throw const ApiException('Entre para continuar.', status: 401);
      }
      headers['Authorization'] = 'Bearer $_token';
    }
    if (data != null) {
      headers['Content-Type'] = 'application/json; charset=utf-8';
    }
    final req = http.Request(
      method,
      Uri.parse('${baseUrl.replaceFirst(RegExp(r'/$'), '')}$path'),
    );
    req.headers.addAll(headers);
    if (data != null) req.bodyBytes = utf8.encode(jsonEncode(data));
    http.Response response;
    try {
      response = await (() async => http.Response.fromStream(
        await client.send(req),
      ))().timeout(timeout);
    } on TimeoutException {
      throw ApiException(
        method == 'GET' ? 'A API demorou para responder. Tente novamente.' : 'Não foi possível confirmar o resultado. Consulte os dados antes de repetir a operação.',
      );
    } on http.ClientException {
      throw const ApiException(
        'Não foi possível conectar à API. Confira a conexão, o endereço e o CORS no Web.',
      );
    }
    if (authenticated && generation != version) {
      throw const ApiException(
        'A sessão mudou. Desconsidere esta resposta.',
        status: -1,
      );
    }
    if (response.statusCode == 401 && authenticated) {
      onUnauthorized?.call();
      throw const ApiException(
        'Sua sessão expirou. Entre novamente.',
        status: 401,
      );
    }
    if (response.statusCode == 204) return null;
    dynamic body;
    try {
      body = response.bodyBytes.isEmpty
          ? null
          : jsonDecode(utf8.decode(response.bodyBytes));
    } on FormatException {
      throw ApiException(
        'A API retornou uma resposta inesperada. Tente novamente.',
        status: response.statusCode,
      );
    }
    if (response.statusCode >= 400) {
      throw ApiException(
        _message(body, response.statusCode),
        status: response.statusCode,
      );
    }
    return body;
  }

  String _message(dynamic body, int status) {
    if (status >= 500) return 'O servidor está indisponível. Tente novamente.';
    if (status == 401) return 'E-mail ou senha inválidos.';
    final detail = body is Map ? body['detail'] : null;
    if (detail is String) return detail;
    if (detail is List) {
      const labels = {
        'name': 'Nome',
        'email': 'E-mail',
        'password': 'Senha',
        'title': 'Título',
        'description': 'Descrição',
        'current_password': 'Senha atual',
        'new_password': 'Nova senha',
      };
      return detail
          .map((error) {
            final location = error is Map ? error['loc'] : null;
            final field = location is List && location.isNotEmpty
                ? labels[location.last]
                : null;
            return '${field ?? 'Dados'}: valor inválido ou fora dos limites permitidos.';
          })
          .join('\n');
    }
    return switch (status) {
      404 => 'Registro indisponível.',
      409 => 'Os dados informados já estão em uso.',
      422 => 'Confira os dados informados.',
      _ => 'Não foi possível concluir a operação.',
    };
  }

  void close() => client.close();
}
