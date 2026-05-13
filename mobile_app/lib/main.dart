import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mexican_banknote_recognition/constants/app_colors.dart';
import 'package:mexican_banknote_recognition/models/banknote_prediction.dart';
import 'package:mexican_banknote_recognition/providers/banknote_provider.dart';
import 'package:mexican_banknote_recognition/screens/camera_screen.dart';
import 'package:mexican_banknote_recognition/screens/help_screen.dart';
import 'package:mexican_banknote_recognition/screens/home_screen.dart';
import 'package:mexican_banknote_recognition/screens/result_screen.dart';
import 'package:mexican_banknote_recognition/utils/app_routes.dart';

void main() {
  runApp(const HablaBilleteApp());
}

class HablaBilleteApp extends StatelessWidget {
  const HablaBilleteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<BanknoteProvider>(
      create: (_) => BanknoteProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Habla Billete',
        theme: ThemeData(
          brightness: Brightness.light,
          scaffoldBackgroundColor: AppColors.background,
          colorScheme: const ColorScheme.light(
            primary: AppColors.primary,
            secondary: AppColors.accent,
            surface: AppColors.surface,
            onPrimary: Colors.white,
            onSurface: AppColors.onSurface,
          ),
          useMaterial3: true,
        ),
        initialRoute: AppRoutes.home,
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case AppRoutes.home:
              return MaterialPageRoute<void>(builder: (_) => const HomeScreen());
            case AppRoutes.camera:
              return MaterialPageRoute<void>(builder: (_) => const CameraScreen());
            case AppRoutes.help:
              return MaterialPageRoute<void>(builder: (_) => const HelpScreen());
            case AppRoutes.result:
              final BanknotePrediction prediction = settings.arguments as BanknotePrediction? ??
                  BanknotePrediction.fakeHundredPesos();
              return MaterialPageRoute<void>(builder: (_) => ResultScreen(prediction: prediction));
            default:
              return MaterialPageRoute<void>(builder: (_) => const HomeScreen());
          }
        },
      ),
    );
  }
}