class ImageService {
  String _imageUrl = '';
  final List<Function(String)> _listeners = [];

  String get imageUrl => _imageUrl;

  void addListener(Function(String) listener) {
    _listeners.add(listener);
  }

  void removeListener(Function(String) listener) {
    _listeners.remove(listener);
  }

  void loadImage() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    _imageUrl = 'https://images.weserv.nl/?url=api.yppp.net/api.php%3Ft%3D$timestamp';
    _notifyListeners();
  }

  void _notifyListeners() {
    for (final listener in _listeners) {
      listener(_imageUrl);
    }
  }

  void dispose() {
    _listeners.clear();
  }
}
