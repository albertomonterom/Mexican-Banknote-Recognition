import 'package:flutter/material.dart';
import 'package:mexican_banknote_recognition/constants/app_colors.dart';
import 'package:mexican_banknote_recognition/constants/app_strings.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.onBackground,
        title: const Text(AppStrings.helpTitle),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: const <Widget>[
              Text(
                AppStrings.helpDescription,
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.onBackground, fontSize: 28, height: 1.4),
              ),
              SizedBox(height: 24),
              _HelpCard(
                title: '1. Abre la cámara',
                description: 'Usa el botón grande para empezar.',
              ),
              SizedBox(height: 16),
              _HelpCard(
                title: '2. Simula la captura',
                description: 'La versión actual devuelve un resultado de ejemplo.',
              ),
              SizedBox(height: 16),
              _HelpCard(
                title: '3. Escucha el resultado',
                description: 'La app está preparada para voz y retroalimentación háptica.',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HelpCard extends StatelessWidget {
  const _HelpCard({required this.title, required this.description});

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: const TextStyle(
              color: AppColors.primary,
              fontSize: 28,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: const TextStyle(
              color: AppColors.onSurface,
              fontSize: 26,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}