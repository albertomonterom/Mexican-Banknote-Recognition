class BanknotePrediction {
  const BanknotePrediction({
    required this.label,
    required this.denomination,
    required this.confidence,
    required this.spokenLabel,
    required this.source,
    required this.detectedAt,
  });

  final String label;
  final String denomination;
  final double confidence;
  final String spokenLabel;
  final String source;
  final DateTime detectedAt;

  String get confidenceAsPercent => '${(confidence * 100).toStringAsFixed(0)}%';

  factory BanknotePrediction.fakeHundredPesos() {
    final DateTime now = DateTime.now();
    return BanknotePrediction(
      label: 'Billete de 100 pesos',
      denomination: '100',
      confidence: 0.96,
      spokenLabel: 'Billete de 100 pesos.',
      source: 'simulado',
      detectedAt: now,
    );
  }
}