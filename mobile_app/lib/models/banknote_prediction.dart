class BanknotePrediction {
  const BanknotePrediction({
    required this.denomination,
    required this.confidence,
    required this.spokenLabel,
    required this.isDetected,
  });

  final String denomination;
  final double confidence;
  final String spokenLabel;
  final bool isDetected;

  /// Real prediction from the TFLite model.
  factory BanknotePrediction.fromClassification(
      String className, double confidence) {
    return BanknotePrediction(
      denomination: className,
      confidence: confidence,
      spokenLabel: 'Billete de $className pesos.',
      isDetected: true,
    );
  }

  /// Model returned no_billete class or confidence too low.
  factory BanknotePrediction.noBanknote() {
    return const BanknotePrediction(
      denomination: 'no_billete',
      confidence: 0.0,
      spokenLabel: 'No se detectó ningún billete. Intente nuevamente.',
      isDetected: false,
    );
  }

  /// Kept for tests / previews while the real model is not yet integrated.
  factory BanknotePrediction.fakeHundredPesos() {
    return const BanknotePrediction(
      denomination: '100',
      confidence: 0.96,
      spokenLabel: 'Billete de 100 pesos.',
      isDetected: true,
    );
  }
}
