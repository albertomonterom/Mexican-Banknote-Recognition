import 'dart:io';
import 'package:camera/camera.dart';
import 'package:camera_macos/camera_macos.dart';

class CameraService {
  CameraController? _controller;
  CameraMacOSController? _macOSController;

  CameraController? get controller => _controller;

  void setMacOSController(CameraMacOSController ctrl) {
    _macOSController = ctrl;
  }

  Future<void> initialize() async {
    if (Platform.isMacOS) return;
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
    if (Platform.isMacOS) {
      if (_macOSController == null) throw StateError('macOS camera not ready.');
      final CameraMacOSFile? file = await _macOSController!.takePicture();
      if (file?.bytes == null) throw StateError('Failed to capture image.');
      final String path =
          '${Directory.systemTemp.path}/capture_${DateTime.now().millisecondsSinceEpoch}.jpg';
      await File(path).writeAsBytes(file!.bytes!);
      return path;
    }
    final XFile xfile = await _controller!.takePicture();
    return xfile.path;
  }

  Future<void> dispose() async {
    await _controller?.dispose();
    _controller = null;
    await _macOSController?.destroy();
    _macOSController = null;
  }
}
