import 'dart:convert';
import 'dart:html' as html;

class WeatherService {
  // 天气 API
  static const String _weatherApiUrl = 'https://uapis.cn/api/v1/misc/weather';
  
  // 默认城市：绥化
  static const String _defaultCity = '绥化';
  
  String _weatherText = '加载中...';
  String _weatherIcon = '☀';
  String _temperature = '';
  
  final List<Function(String, String, String)> _listeners = [];
  
  String get weatherText => _weatherText;
  String get weatherIcon => _weatherIcon;
  String get temperature => _temperature;
  String get fullWeatherText => _temperature.isNotEmpty 
      ? '$_weatherText $_temperature°C' 
      : _weatherText;
  
  void addListener(Function(String, String, String) listener) {
    _listeners.add(listener);
  }
  
  void removeListener(Function(String, String, String) listener) {
    _listeners.remove(listener);
  }
  
  void _notifyListeners() {
    for (final listener in _listeners) {
      listener(_weatherText, _weatherIcon, _temperature);
    }
  }
  
  Future<void> loadWeather() async {
    try {
      // 尝试获取 IP 定位的天气
      final response = await html.HttpRequest.request(
        _weatherApiUrl,
        method: 'GET',
        requestHeaders: {'Accept': 'application/json'},
      );
      
      if (response.status == 200) {
        final data = json.decode(response.responseText ?? '{}');
        if (data != null && data['city'] != null && data['weather'] != null) {
          _weatherText = data['weather'];
          _temperature = data['temp']?.toString() ?? '';
          _weatherIcon = _getWeatherIcon(data['weather'], data['weather_icon']);
          _notifyListeners();
          return;
        }
      }
      
      // 如果 IP 定位失败，尝试获取绥化的天气
      await _loadWeatherByCity(_defaultCity);
    } catch (e) {
      print('获取天气失败：$e');
      // 失败时使用默认城市
      await _loadWeatherByCity(_defaultCity);
    }
  }
  
  Future<void> _loadWeatherByCity(String city) async {
    try {
      final url = '$_weatherApiUrl?city=${Uri.encodeComponent(city)}';
      final response = await html.HttpRequest.request(
        url,
        method: 'GET',
        requestHeaders: {'Accept': 'application/json'},
      );
      
      if (response.status == 200) {
        final data = json.decode(response.responseText ?? '{}');
        if (data != null && data['weather'] != null) {
          _weatherText = data['weather'];
          _temperature = data['temp']?.toString() ?? '';
          _weatherIcon = _getWeatherIcon(data['weather'], data['weather_icon']);
        } else {
          _setDefaultWeather();
        }
      } else {
        _setDefaultWeather();
      }
    } catch (e) {
      print('获取城市天气失败：$e');
      _setDefaultWeather();
    }
    _notifyListeners();
  }
  
  void _setDefaultWeather() {
    _weatherText = '阵雨';
    _temperature = '9';
    _weatherIcon = '🌧';
  }
  
  String _getWeatherIcon(String weather, dynamic weatherCode) {
    if (weather.isEmpty && weatherCode == null) return '☀';
    
    final w = weather.toLowerCase();
    
    // 根据天气描述判断
    if (w.contains('晴')) return '☀';
    if (w.contains('多云')) return '⛅';
    if (w.contains('阴')) return '☁';
    if (w.contains('雨') && w.contains('雷')) return '⛈';
    if (w.contains('雨') && w.contains('小')) return '🌦';
    if (w.contains('雨')) return '🌧';
    if (w.contains('雪')) return '❄';
    if (w.contains('雾') || w.contains('霾')) return '🌫';
    if (w.contains('风')) return '💨';
    
    // 根据天气代码判断
    if (weatherCode != null) {
      final code = weatherCode.toString();
      if (code.startsWith('0')) return '☀';
      if (code.startsWith('1')) return '⛅';
      if (code.startsWith('2')) return '☁';
      if (code.startsWith('3') || code.startsWith('4')) return '🌧';
      if (code.startsWith('5')) return '⛈';
      if (code.startsWith('6')) return '❄';
      if (code.startsWith('7')) return '🌫';
    }
    
    return '☀';
  }
  
  void dispose() {
    _listeners.clear();
  }
}
