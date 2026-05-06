import 'package:mexican_banknote_recognition/models/banknote_prediction.dart';

class MlModelService {
  const MlModelService();

  Future<BanknotePrediction> recognizeBanknote(String frameReference) async {
    await Future<void>.delayed(const Duration(seconds: 1));
    return BanknotePrediction.fakeHundredPesos();
  }
}