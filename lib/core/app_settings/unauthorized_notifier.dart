import 'dart:async';

class UnauthorizedException implements Exception {}

class UnauthorizedNotifier {
  static final UnauthorizedNotifier _instance = UnauthorizedNotifier._internal();
  factory UnauthorizedNotifier() => _instance;
  UnauthorizedNotifier._internal();

  final _controller = StreamController<void>.broadcast();
  Stream<void> get onUnauthorized => _controller.stream;

  void notifyUnauthorized() {
    _controller.add(null);
  }

  void dispose() {
    _controller.close();
  }
} 