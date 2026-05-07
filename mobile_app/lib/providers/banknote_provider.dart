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
  })  : _cameraService = cameraService ?? const CameraService(),
        _mlModelService = mlModelService ?? const MlModelService(),
        _speechService = speechService ?? SpeechService();

  final CameraService _cameraService;
  final MlModelService _mlModelService;
  final SpeechService _speechService;

  BanknotePrediction? _lastPrediction;
  bool _isProcessing = false;
  String? _statusMessage;

  BanknotePrediction? get lastPrediction => _lastPrediction;
  bool get isProcessing => _isProcessing;
  String? get statusMessage => _statusMessage;

  Future<BanknotePrediction> simulateRecognition() async {
    _isProcessing = true;
    _statusMessage = 'Capturando billete...';
    notifyListeners();

    final String frameReference = await _cameraService.captureFakeFrame();
    final BanknotePrediction prediction = await _mlModelService.recognizeBanknote(frameReference);

    _lastPrediction = prediction;
    _isProcessing = false;
    _statusMessage = prediction.spokenLabel;
    notifyListeners();

    // Speak the denomination followed by the available gestures so the user
    // knows what to do the moment the result screen appears.
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
    _speechService.stop();
    super.dispose();
  }
}