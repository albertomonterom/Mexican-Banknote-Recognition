import 'package:flutter/material.dart';
import 'package:mexican_banknote_recognition/constants/app_colors.dart';
import 'package:mexican_banknote_recognition/constants/app_strings.dart';
import 'package:mexican_banknote_recognition/utils/app_routes.dart';
import 'package:mexican_banknote_recognition/widgets/accessible_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.onBackground,
        title: const Text(AppStrings.homeTitle),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const SizedBox(height: 12),
              const Text(
                AppStrings.appName,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.onBackground,
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                AppStrings.homeDescription,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.subtle,
                  fontSize: 18,
                ),
              ),
              const Spacer(),
              AccessibleButton(
                label: AppStrings.scanButton,
                icon: Icons.camera_alt,
                semanticLabel: 'Escanear billete mexicano',
                onPressed: () => Navigator.of(context).pushNamed(AppRoutes.camera),
              ),
              const SizedBox(height: 16),
              AccessibleButton(
                label: AppStrings.helpButton,
                icon: Icons.help_outline,
                backgroundColor: AppColors.surface,
                foregroundColor: AppColors.onSurface,
                semanticLabel: 'Abrir ayuda de la aplicación',
                onPressed: () => Navigator.of(context).pushNamed(AppRoutes.help),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}