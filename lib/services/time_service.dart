import 'dart:async';

class TimeService {
  DateTime _currentTime = DateTime.now();
  Timer? _timer;
  final List<Function(DateTime)> _listeners = [];

  DateTime get currentTime => _currentTime;

  void start() {
    _updateTime();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateTime();
    });
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
  }

  void addListener(Function(DateTime) listener) {
    _listeners.add(listener);
  }

  void removeListener(Function(DateTime) listener) {
    _listeners.remove(listener);
  }

  void _updateTime() {
    _currentTime = DateTime.now();
    for (final listener in _listeners) {
      listener(_currentTime);
    }
  }

  String getGreeting() {
    final hour = _currentTime.hour;
    if (hour >= 6 && hour < 12) return '早上好';
    if (hour >= 12 && hour < 14) return '中午好';
    if (hour >= 14 && hour < 18) return '下午好';
    if (hour >= 18 && hour < 22) return '晚上好';
    if (hour >= 22 || hour < 2) return '夜深了';
    return '晚安';
  }

  String formatTime() {
    return '${_currentTime.hour.toString().padLeft(2, '0')}:${_currentTime.minute.toString().padLeft(2, '0')}';
  }

  String formatDate() {
    const weekdays = ['周一', '周二', '周三', '周四', '周五', '周六', '周日'];
    final weekday = weekdays[(_currentTime.weekday % 7)];
    return '${_currentTime.month}月${_currentTime.day}日 $weekday';
  }

  void dispose() {
    stop();
    _listeners.clear();
  }
}
