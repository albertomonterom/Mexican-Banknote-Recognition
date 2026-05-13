import 'package:camera/camera.dart';

class CameraService {
  CameraController? _controller;

  CameraController? get controller => _controller;

  Future<void> initialize() async {
    final List<CameraDescription> cameras = await availableCameras();
    if (cameras.isEmpty) throw StateError('No cameras found on device.');
    _controller = CameraController(
      cameras.first,
      ResolutionPreset.medium,
      enableAudio: false,
    );
    await _controller!.initialize();
  }

  Future<String> captureFrame() async {
    final CameraController ctrl = _controller!;
    final XFile file = await ctrl.takePicture();
    return file.path;
  }

  Future<void> dispose() async {
    await _controller?.dispose();
    _controller = null;
  }
}
