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
    _imageUrl = 'https://loremflickr.com/800/600?random=${DateTime.now().millisecondsSinceEpoch}';
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
