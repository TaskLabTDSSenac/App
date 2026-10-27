import 'package:flutter/foundation.dart';

import '../models/task.dart';
import '../services/task_service.dart';
import 'auth_controller.dart';

class TasksController extends ChangeNotifier {
  final AuthController auth;
  final TaskService service;
  List<Task> tasks = [];
  bool loading = false;
  String? error;
  int _request = 0;
  late int _generation;
  TasksController(this.auth, this.service) {
    _generation = auth.api.generation;
    auth.addListener(_sessionChanged);
  }
  void _sessionChanged() {
    if (_generation != auth.api.generation ||
        auth.phase == AuthPhase.signedOut) {
      _generation = auth.api.generation;
      _request++;
      tasks = [];
      loading = false;
      error = null;
      notifyListeners();
    }
  }

  Future<void> refresh() async {
    final request = ++_request;
    final generation = auth.api.generation;
    loading = true;
    error = null;
    notifyListeners();
    try {
      final result = await service.list();
      if (request == _request && generation == auth.api.generation) {
        tasks = result;
      }
    } catch (failure) {
      if (request == _request && generation == auth.api.generation) {
        error = friendlyError(failure);
      }
    } finally {
      if (request == _request && generation == auth.api.generation) {
        loading = false;
        notifyListeners();
      }
    }
  }

  @override
  void dispose() {
    auth.removeListener(_sessionChanged);
    super.dispose();
  }
}
