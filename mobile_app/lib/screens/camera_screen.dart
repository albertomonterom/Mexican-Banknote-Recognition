import 'dart:math' as math;
import 'package:camera/camera.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((_) => _initialize());
  }

  Future<void> _initialize() async {
    await context.read<BanknoteProvider>().initializeCamera();
    if (!mounted) return;
    context.read<BanknoteProvider>().announce('Escaneando billete.');
    _startScan();
  }

  Future<void> _startScan() async {
    final BanknotePrediction prediction =
        await context.read<BanknoteProvider>().simulateRecognition();
    if (!mounted) return;
    Navigator.of(context)
        .pushReplacementNamed(AppRoutes.result, arguments: prediction);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: <Widget>[
          // Full-screen camera preview
          Positioned.fill(
            child: Consumer<BanknoteProvider>(
              builder: (_, BanknoteProvider provider, __) {
                final CameraController? ctrl = provider.cameraController;
                if (ctrl != null && ctrl.value.isInitialized) {
                  return CameraPreview(ctrl);
                }
                return const ColoredBox(color: Colors.black);
              },
            ),
          ),
          // Purple sonar rings centred on screen — VoiceOver live region
          Center(
            child: Semantics(
              liveRegion: true,
              label: AppStrings.scanningInstruction,
              child: const ExcludeSemantics(
                child: SizedBox(
                  width: 240,
                  height: 240,
                  child: _SonarRings(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Sonar rings ───────────────────────────────────────────────────────────────

class _SonarRings extends StatefulWidget {
  const _SonarRings();

  @override
  State<_SonarRings> createState() => _SonarRingsState();
}

class _SonarRingsState extends State<_SonarRings>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, __) => CustomPaint(
        painter: _SonarPainter(_ctrl.value),
      ),
    );
  }
}

class _SonarPainter extends CustomPainter {
  const _SonarPainter(this.progress);
  final double progress;

  static const int _count = 3;

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = size.center(Offset.zero);
    final double maxR = math.min(size.width, size.height) / 2;

    // Small solid dot at center
    canvas.drawCircle(
      center,
      6,
      Paint()..color = AppColors.primary,
    );

    for (int i = 0; i < _count; i++) {
      final double phase = (progress + i / _count) % 1.0;
      final double eased = 1 - math.pow(1 - phase, 2).toDouble();
      final double opacity = (1 - phase) * 0.70;

      canvas.drawCircle(
        center,
        maxR * eased,
        Paint()
          ..color = AppColors.primary.withAlpha((opacity * 255).round())
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.0,
      );
    }
  }

  @override
  bool shouldRepaint(_SonarPainter old) => old.progress != progress;
}
