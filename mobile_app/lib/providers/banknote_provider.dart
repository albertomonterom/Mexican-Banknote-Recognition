import 'package:camera/camera.dart';
import 'package:camera_macos/camera_macos.dart';
import 'package:flutter/foundation.dart';
import 'package:mexican_banknote_recognition/models/banknote_prediction.dart';
import 'package:mexican_banknote_recognition/services/camera_service.dart';
import 'package:mexican_banknote_recognition/services/ml_model_service.dart';
import 'package:mexican_banknote_recognition/services/speech_service.dart';

class BanknoteProvider extends ChangeNotifier {
  BanknoteProvider({
    CameraService? cameraService,
    MlModelService? mlModelService,
    SpeechService? speechService,
  })  : _cameraService = cameraService ?? CameraService(),
        _mlModelService = mlModelService ?? MlModelService(),
        _speechService = speechService ?? SpeechService();

  final CameraService _cameraService;
  final MlModelService _mlModelService;
  final SpeechService _speechService;

  BanknotePrediction? _lastPrediction;
  bool _isProcessing = false;
  bool _cameraReady = false;
  String? _statusMessage;

  BanknotePrediction? get lastPrediction => _lastPrediction;
  bool get isProcessing => _isProcessing;
  bool get cameraReady => _cameraReady;
  String? get statusMessage => _statusMessage;
  CameraController? get cameraController => _cameraService.controller;

  void setMacOSController(CameraMacOSController ctrl) {
    _cameraService.setMacOSController(ctrl);
  }

  Future<void> initializeCamera() async {
    _cameraReady = false;
    notifyListeners();
    try {
      await _cameraService.initialize();
      _cameraReady = true;
    } catch (_) {
      _cameraReady = false;
    }
    notifyListeners();
  }

  Future<BanknotePrediction> simulateRecognition() async {
    _isProcessing = true;
    _statusMessage = 'Capturando billete...';
    notifyListeners();

    BanknotePrediction prediction;
    try {
      final String framePath = await _cameraService.captureFrame();
      prediction = await _mlModelService.recognizeBanknote(framePath);
    } catch (_) {
      prediction = BanknotePrediction.noBanknote();
    }

    _isProcessing = false;
    notifyListeners();

    if (!prediction.isDetected) {
      await _speechService.speak(prediction.spokenLabel);
      return prediction;
    }

    _lastPrediction = prediction;
    _statusMessage = prediction.spokenLabel;
    notifyListeners();

    await _speechService.speak(
      '${prediction.spokenLabel} '
      'Toque para escanear otro billete. '
      'Doble toque para repetir el resultado.',
    );
    return prediction;
  }

  Future<void> announce(String message) async {
    await _speechService.speak(message);
  }

  Future<void> repeatAnnouncement() async {
    if (_lastPrediction != null) {
      await _speechService.speak(_lastPrediction!.spokenLabel);
    }
  }

  void clearStatus() {
    _statusMessage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _cameraService.dispose();
    _speechService.stop();
    super.dispose();
  }
}
