import 'dart:convert';
import 'dart:html' as html;

class HitokotoService {
  // 一言 API
  static const String _hitokotoApiUrl = 'https://v1.hitokoto.cn/?encode=text';
  
  String _hitokoto = '但尽人事，莫问前程。';
  
  final List<Function(String)> _listeners = [];
  
  String get hitokoto => _hitokoto;
  
  void addListener(Function(String) listener) {
    _listeners.add(listener);
  }
  
  void removeListener(Function(String) listener) {
    _listeners.remove(listener);
  }
  
  void _notifyListeners() {
    for (final listener in _listeners) {
      listener(_hitokoto);
    }
  }
  
  Future<void> loadHitokoto() async {
    try {
      final response = await html.HttpRequest.request(
        _hitokotoApiUrl,
        method: 'GET',
      );
      
      if (response.status == 200) {
        final text = response.responseText?.trim() ?? '';
        if (text.isNotEmpty) {
          _hitokoto = text;
          _notifyListeners();
        }
      }
    } catch (e) {
      print('获取一言失败：$e');
      // 失败时使用默认一言
      _hitokoto = '但尽人事，莫问前程。';
      _notifyListeners();
    }
  }
  
  void dispose() {
    _listeners.clear();
  }
}
