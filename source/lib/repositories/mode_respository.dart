class ModeRepository {
  bool _currentMode = false;

  bool get() => _currentMode;

  void toggleMode(){
    _currentMode = !_currentMode;
  }
}