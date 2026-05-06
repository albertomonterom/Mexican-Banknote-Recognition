class CameraService {
  const CameraService();

  Future<String> captureFakeFrame() async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    return 'fake-camera-frame';
  }
}