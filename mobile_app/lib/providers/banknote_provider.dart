import 'package:camera/camera.dart';
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
        _mlModelService = mlModelService ?? const MlModelService(),
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

  Future<void> initializeCamera() async {
    _cameraReady = false;
    notifyListeners();
    await _cameraService.initialize();
    _cameraReady = true;
    notifyListeners();
  }

  Future<BanknotePrediction> simulateRecognition() async {
    _isProcessing = true;
    _statusMessage = 'Capturando billete...';
    notifyListeners();

    final String framePath = await _cameraService.captureFrame();
    final BanknotePrediction prediction =
        await _mlModelService.recognizeBanknote(framePath);

    _lastPrediction = prediction;
    _isProcessing = false;
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
