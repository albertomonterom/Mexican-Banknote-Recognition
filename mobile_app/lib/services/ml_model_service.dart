import 'dart:io';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:mexican_banknote_recognition/models/banknote_prediction.dart';

class MlModelService {
  MlModelService() {
    _ready = _init();
  }

  static const int _inputSize = 224;
  static const double _confidenceThreshold = 0.90;

  late final Future<void> _ready;
  Interpreter? _interpreter;
  List<String> _classNames = <String>[];

  Future<void> _init() async {
    _interpreter =
        await Interpreter.fromAsset('assets/modelo_billetes_fp32.tflite');

    final String raw =
        await rootBundle.loadString('assets/class_names.txt');
    _classNames = raw
        .trim()
        .split('\n')
        .map((String line) {
          final List<String> parts = line.split('\t');
          return (parts.length > 1 ? parts[1] : parts[0]).trim();
        })
        .toList();
  }

  Future<BanknotePrediction> recognizeBanknote(String imagePath) async {
    try {
      await _ready;
      // Load & resize to 224×224
      final Uint8List bytes = await File(imagePath).readAsBytes();
      final img.Image? decoded = img.decodeImage(bytes);
      if (decoded == null) return BanknotePrediction.noBanknote();

      final img.Image resized = img.copyResize(
        decoded,
        width: _inputSize,
        height: _inputSize,
        interpolation: img.Interpolation.linear,
      );

      // Build input tensor [1, 224, 224, 3] — raw 0–255 float32.
      // MobileNetV3 was exported with include_preprocessing=True so the
      // model handles normalisation internally.
      final List<List<List<List<double>>>> input = <List<List<List<double>>>>[
        List<List<List<double>>>.generate(_inputSize, (int y) {
          return List<List<double>>.generate(_inputSize, (int x) {
            final img.Pixel p = resized.getPixel(x, y);
            return <double>[p.r.toDouble(), p.g.toDouble(), p.b.toDouble()];
          });
        }),
      ];

      // Output tensor [1, numClasses]
      final List<List<double>> output = <List<double>>[
        List<double>.filled(_classNames.length, 0.0),
      ];

      _interpreter!.run(input, output);

      // Find the class with the highest softmax probability
      final List<double> probs = output[0];
      int bestIdx = 0;
      double bestProb = probs[0];
      for (int i = 1; i < probs.length; i++) {
        if (probs[i] > bestProb) {
          bestProb = probs[i];
          bestIdx = i;
        }
      }

      final String className = _classNames[bestIdx];
      if (className == 'no_billete' || bestProb < _confidenceThreshold) {
        return BanknotePrediction.noBanknote();
      }

      return BanknotePrediction.fromClassification(className, bestProb);
    } catch (_) {
      return BanknotePrediction.noBanknote();
    }
  }

  void dispose() => _interpreter?.close();
}
