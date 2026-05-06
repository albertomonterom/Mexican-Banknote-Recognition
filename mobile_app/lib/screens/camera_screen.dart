import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mexican_banknote_recognition/constants/app_colors.dart';
import 'package:mexican_banknote_recognition/constants/app_strings.dart';
import 'package:mexican_banknote_recognition/models/banknote_prediction.dart';
import 'package:mexican_banknote_recognition/providers/banknote_provider.dart';
import 'package:mexican_banknote_recognition/utils/app_routes.dart';
import 'package:mexican_banknote_recognition/widgets/accessible_button.dart';

class CameraScreen extends StatelessWidget {
  const CameraScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.onBackground,
        title: const Text(AppStrings.cameraTitle),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Consumer<BanknoteProvider>(
            builder: (BuildContext context, BanknoteProvider provider, Widget? child) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  const Text(
                    AppStrings.cameraDescription,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColors.subtle, fontSize: 18),
                  ),
                  const SizedBox(height: 24),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: AppColors.primaryDark, width: 2),
                      ),
                      child: Center(
                        child: provider.isProcessing
                            ? const CircularProgressIndicator(color: AppColors.primary)
                            : const Icon(
                                Icons.document_scanner,
                                size: 100,
                                color: AppColors.primary,
                              ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (provider.statusMessage != null) ...<Widget>[
                    Text(
                      provider.statusMessage!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: AppColors.onBackground, fontSize: 18),
                    ),
                    const SizedBox(height: 16),
                  ],
                  AccessibleButton(
                    label: provider.isProcessing ? AppStrings.loadingMessage : AppStrings.captureButton,
                    icon: Icons.touch_app,
                    semanticLabel: 'Simular captura y reconocimiento del billete',
                    onPressed: provider.isProcessing
                        ? () {}
                        : () async {
                            final BanknotePrediction prediction = await provider.simulateRecognition();
                            if (!context.mounted) {
                              return;
                            }
                            Navigator.of(context).pushReplacementNamed(
                              AppRoutes.result,
                              arguments: prediction,
                            );
                          },
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}