import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/date_symbol_data_local.dart';

import 'app.dart';
import 'config/app_config.dart';
import 'controllers/auth_controller.dart';
import 'controllers/tasks_controller.dart';
import 'services/api_client.dart';
import 'services/task_service.dart';
import 'services/token_storage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('pt_BR');
  final api = ApiClient(client: http.Client(), baseUrl: AppConfig.apiBaseUrl);
  final auth = AuthController(api, SecureTokenStorage());
  final tasks = TasksController(auth, TaskService(api));
  runApp(TaskLabApp(auth: auth, tasks: tasks));
}
