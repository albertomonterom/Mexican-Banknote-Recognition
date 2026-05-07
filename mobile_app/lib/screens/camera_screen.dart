import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mexican_banknote_recognition/constants/app_colors.dart';
import 'package:mexican_banknote_recognition/constants/app_strings.dart';
import 'package:mexican_banknote_recognition/models/banknote_prediction.dart';
import 'package:mexican_banknote_recognition/providers/banknote_provider.dart';
import 'package:mexican_banknote_recognition/utils/app_routes.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _startScan());
  }

  Future<void> _startScan() async {
    final BanknotePrediction prediction =
        await context.read<BanknoteProvider>().simulateRecognition();
    if (!mounted) return;
    Navigator.of(context).pushReplacementNamed(AppRoutes.result, arguments: prediction);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SizedBox.expand(
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Positioned(
                top: 24,
                left: 0,
                right: 0,
                child: Text(
                  AppStrings.scanningAreaHint,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppColors.subtle,
                    fontSize: 16,
                  ),
                ),
              ),
              const _ScanningIndicator(),
              const Positioned(
                bottom: 48,
                left: 0,
                right: 0,
                child: _ScanningWaveform(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ScanningIndicator extends StatelessWidget {
  const _ScanningIndicator();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              width: 10,
              height: 10,
              decoration: const BoxDecoration(
                color: AppColors.scanning,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              AppStrings.scanningLabel,
              style: TextStyle(
                color: AppColors.scanning,
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 48),
          child: Text(
            AppStrings.scanningInstruction,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.subtle,
              fontSize: 18,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}

class _ScanningWaveform extends StatefulWidget {
  const _ScanningWaveform();

  @override
  State<_ScanningWaveform> createState() => _ScanningWaveformState();
}

class _ScanningWaveformState extends State<_ScanningWaveform>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (BuildContext context, Widget? _) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: List<Widget>.generate(5, (int i) {
            final double phase = i / 5;
            final double t = (_controller.value + phase) % 1.0;
            final double heightFactor = (math.sin(t * 2 * math.pi) + 1) / 2;
            final double barHeight = 8.0 + heightFactor * 28.0;
            return Container(
              width: 4,
              height: barHeight,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: AppColors.scanning,
                borderRadius: BorderRadius.circular(2),
              ),
            );
          }),
        );
      },
    );
  }
}
