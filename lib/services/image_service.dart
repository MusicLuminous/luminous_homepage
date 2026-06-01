class ImageService {
  String _imageUrl = '';
  final List<Function(String)> _listeners = [];
  bool _isLoading = false;

  String get imageUrl => _imageUrl;
  bool get isLoading => _isLoading;

  void addListener(Function(String) listener) {
    _listeners.add(listener);
  }

  void removeListener(Function(String) listener) {
    _listeners.remove(listener);
  }

  void loadImage() {
    _isLoading = true;
    try {
      _imageUrl = 'https://pivix.mwm.moe/api/v2/img?ts=${DateTime.now().millisecondsSinceEpoch}';
    } catch (e) {
      _imageUrl = '';
    } finally {
      _isLoading = false;
      _notifyListeners();
    }
  }

  void refreshImage() {
    loadImage();
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