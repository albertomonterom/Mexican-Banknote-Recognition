import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mexican_banknote_recognition/constants/app_colors.dart';
import 'package:mexican_banknote_recognition/constants/app_strings.dart';
import 'package:mexican_banknote_recognition/models/banknote_prediction.dart';
import 'package:mexican_banknote_recognition/providers/banknote_provider.dart';
import 'package:mexican_banknote_recognition/utils/app_routes.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key, required this.prediction});

  final BanknotePrediction prediction;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Semantics(
          label: '\$${prediction.denomination} pesos. '
              '${AppStrings.resultTapHint}. '
              '${AppStrings.resultDoubleTapHint}.',
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () =>
                Navigator.of(context).pushReplacementNamed(AppRoutes.camera),
            onDoubleTap: () =>
                context.read<BanknoteProvider>().repeatAnnouncement(),
            child: SizedBox.expand(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(height: 8),
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: AppColors.scanningBg,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.scanning, width: 2),
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                  const SizedBox(height: 28),
                  FittedBox(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Text(
                        '\$${prediction.denomination}',
                        style: const TextStyle(
                          color: AppColors.onBackground,
                          fontSize: 80,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -2,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    AppStrings.pesos,
                    style: TextStyle(
                      color: AppColors.subtle,
                      fontSize: 22,
                    ),
                  ),
                  const SizedBox(height: 56),
                  const Text(
                    AppStrings.resultTapHint,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.subtle,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    AppStrings.resultDoubleTapHint,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.subtle,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
