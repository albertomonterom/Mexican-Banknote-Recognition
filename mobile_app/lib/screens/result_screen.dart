import 'package:flutter/material.dart';
import 'package:mexican_banknote_recognition/constants/app_colors.dart';
import 'package:mexican_banknote_recognition/constants/app_strings.dart';
import 'package:mexican_banknote_recognition/models/banknote_prediction.dart';
import 'package:mexican_banknote_recognition/utils/app_routes.dart';
import 'package:mexican_banknote_recognition/widgets/accessible_button.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key, required this.prediction});

  final BanknotePrediction prediction;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.onBackground,
        title: const Text(AppStrings.resultTitle),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const SizedBox(height: 20),
              const Text(
                AppStrings.resultHint,
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.subtle, fontSize: 18),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppColors.primaryDark, width: 2),
                ),
                child: Column(
                  children: <Widget>[
                    const Icon(Icons.record_voice_over, color: AppColors.primary, size: 72),
                    const SizedBox(height: 16),
                    Text(
                      prediction.spokenLabel,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: AppColors.onSurface,
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '${AppStrings.fakeConfidence}: ${prediction.confidenceAsPercent}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: AppColors.subtle, fontSize: 18),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              AccessibleButton(
                label: AppStrings.speakingButton,
                icon: Icons.volume_up,
                semanticLabel: 'Reproducir el resultado por voz',
                onPressed: () {},
              ),
              const SizedBox(height: 16),
              AccessibleButton(
                label: AppStrings.scanButton,
                icon: Icons.camera_alt,
                backgroundColor: AppColors.surface,
                foregroundColor: AppColors.onSurface,
                semanticLabel: 'Escanear otro billete',
                onPressed: () => Navigator.of(context).pushReplacementNamed(AppRoutes.camera),
              ),
              const SizedBox(height: 16),
              AccessibleButton(
                label: AppStrings.backButton,
                icon: Icons.home,
                backgroundColor: AppColors.background,
                foregroundColor: AppColors.onBackground,
                semanticLabel: 'Volver al inicio',
                onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil(
                  AppRoutes.home,
                  (Route<dynamic> route) => false,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}