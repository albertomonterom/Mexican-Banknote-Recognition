import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mexican_banknote_recognition/constants/app_colors.dart';
import 'package:mexican_banknote_recognition/constants/app_strings.dart';
import 'package:mexican_banknote_recognition/providers/banknote_provider.dart';
import 'package:mexican_banknote_recognition/utils/app_routes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BanknoteProvider>().announce(
        '${AppStrings.appName}. ${AppStrings.homeTapHint}.',
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Semantics(
        label: '${AppStrings.appName}. ${AppStrings.homeTapHint}.',
        button: true,
        child: GestureDetector(
          onTap: () => Navigator.of(context).pushNamed(AppRoutes.camera),
          behavior: HitTestBehavior.opaque,
          child: ExcludeSemantics(
            child: SizedBox.expand(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    AppStrings.appName,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.onBackground,
                      fontSize: 38,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 28),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 48),
                    child: Text(
                      AppStrings.homeTapHint,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.subtle,
                        fontSize: 18,
                        height: 1.5,
                      ),
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
