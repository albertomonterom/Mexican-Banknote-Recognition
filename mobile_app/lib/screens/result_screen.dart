import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mexican_banknote_recognition/constants/app_colors.dart';
import 'package:mexican_banknote_recognition/constants/app_strings.dart';
import 'package:mexican_banknote_recognition/models/banknote_prediction.dart';
import 'package:mexican_banknote_recognition/providers/banknote_provider.dart';
import 'package:mexican_banknote_recognition/utils/app_routes.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({super.key, required this.prediction});

  final BanknotePrediction prediction;

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _contentFade;
  late final Animation<Offset> _contentSlide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    );
    _contentFade = CurvedAnimation(
      parent: _ctrl,
      curve: const Interval(0.35, 0.85, curve: Curves.easeOut),
    );
    _contentSlide = Tween<Offset>(
      begin: const Offset(0, 0.10),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _ctrl,
      curve: const Interval(0.35, 0.85, curve: Curves.easeOut),
    ));
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Semantics(
          label: 'Billete de ${widget.prediction.denomination} pesos. '
              '${AppStrings.resultTapHint}. '
              '${AppStrings.resultDoubleTapHint}.',
          button: true,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () =>
                Navigator.of(context).pushReplacementNamed(AppRoutes.camera),
            onDoubleTap: () =>
                context.read<BanknoteProvider>().repeatAnnouncement(),
            child: ExcludeSemantics(
              child: SizedBox.expand(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      // White result card
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.fromLTRB(36, 40, 36, 40),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(28),
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                              color: AppColors.shadow.withAlpha(20),
                              blurRadius: 40,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            // Apple Pay-style animated badge
                            const _CheckBadge(size: 80),
                            const SizedBox(height: 28),
                            // Denomination slides in after badge animates
                            FadeTransition(
                              opacity: _contentFade,
                              child: SlideTransition(
                                position: _contentSlide,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    FittedBox(
                                      child: Text(
                                        '\$${widget.prediction.denomination}',
                                        style: const TextStyle(
                                          color: AppColors.onSurface,
                                          fontSize: 120,
                                          fontWeight: FontWeight.w800,
                                          letterSpacing: -2,
                                        ),
                                      ),
                                    ),
                                    const Text(
                                      AppStrings.pesos,
                                      style: TextStyle(
                                        color: AppColors.subtle,
                                        fontSize: 36,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 36),
                      // Hint labels below the card
                      FadeTransition(
                        opacity: _contentFade,
                        child: Column(
                          children: <Widget>[
                            _HintRow(label: AppStrings.resultTapHint),
                            const SizedBox(height: 12),
                            _HintRow(label: AppStrings.resultDoubleTapHint),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _HintRow extends StatelessWidget {
  const _HintRow({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      textAlign: TextAlign.center,
      style: const TextStyle(color: AppColors.subtle, fontSize: 22),
    );
  }
}

// ─── Animated checkmark badge ──────────────────────────────────────────────────

class _CheckBadge extends StatefulWidget {
  const _CheckBadge({required this.size});
  final double size;

  @override
  State<_CheckBadge> createState() => _CheckBadgeState();
}

class _CheckBadgeState extends State<_CheckBadge>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _ring;
  late final Animation<double> _fill;
  late final Animation<double> _check;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 850),
    );
    _ring = CurvedAnimation(
      parent: _ctrl,
      curve: const Interval(0.0, 0.55, curve: Curves.easeOut),
    );
    _fill = CurvedAnimation(
      parent: _ctrl,
      curve: const Interval(0.48, 0.65, curve: Curves.easeIn),
    );
    _check = CurvedAnimation(
      parent: _ctrl,
      curve: const Interval(0.55, 1.0, curve: Curves.easeOut),
    );
    _ctrl.forward();
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
        size: Size(widget.size, widget.size),
        painter: _CheckBadgePainter(
          ringProgress: _ring.value,
          fillProgress: _fill.value,
          checkProgress: _check.value,
        ),
      ),
    );
  }
}

class _CheckBadgePainter extends CustomPainter {
  const _CheckBadgePainter({
    required this.ringProgress,
    required this.fillProgress,
    required this.checkProgress,
  });

  final double ringProgress;
  final double fillProgress;
  final double checkProgress;

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = size.center(Offset.zero);
    final double strokeW = size.width * 0.075;
    final double radius = (size.width - strokeW) / 2;

    // 1. Indigo fill fades in as ring completes
    if (fillProgress > 0) {
      canvas.drawCircle(
        center,
        size.width / 2,
        Paint()
          ..color = AppColors.primary.withAlpha((fillProgress * 255).round())
          ..style = PaintingStyle.fill,
      );
    }

    // 2. Ring arc draws clockwise from top
    if (ringProgress > 0) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -math.pi / 2,
        2 * math.pi * ringProgress,
        false,
        Paint()
          ..color = AppColors.primary
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeW
          ..strokeCap = StrokeCap.round,
      );
    }

    // 3. White checkmark traces inside the filled circle
    if (checkProgress > 0) {
      final double w = size.width;
      final Offset p1 = Offset(w * 0.26, w * 0.50);
      final Offset p2 = Offset(w * 0.43, w * 0.66);
      final Offset p3 = Offset(w * 0.74, w * 0.35);

      final double seg1 = (p2 - p1).distance;
      final double seg2 = (p3 - p2).distance;
      final double total = seg1 + seg2;
      final double drawn = total * checkProgress;

      final Path path = Path()..moveTo(p1.dx, p1.dy);
      if (drawn <= seg1) {
        final double t = drawn / seg1;
        path.lineTo(
          p1.dx + (p2.dx - p1.dx) * t,
          p1.dy + (p2.dy - p1.dy) * t,
        );
      } else {
        path.lineTo(p2.dx, p2.dy);
        final double t = (drawn - seg1) / seg2;
        path.lineTo(
          p2.dx + (p3.dx - p2.dx) * t,
          p2.dy + (p3.dy - p2.dy) * t,
        );
      }

      canvas.drawPath(
        path,
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeW
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round,
      );
    }
  }

  @override
  bool shouldRepaint(_CheckBadgePainter old) =>
      old.ringProgress != ringProgress ||
      old.fillProgress != fillProgress ||
      old.checkProgress != checkProgress;
}
