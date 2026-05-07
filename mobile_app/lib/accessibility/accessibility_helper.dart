import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';

class AccessibilityHelper {
  const AccessibilityHelper._();

  static Future<void> announce(String message) async {
    // ignore: deprecated_member_use
    await SemanticsService.announce(message, TextDirection.ltr);
  }

  static Future<void> lightHaptic() async {
    await HapticFeedback.lightImpact();
  }

  static Future<void> mediumHaptic() async {
    await HapticFeedback.mediumImpact();
  }

  static String semanticActionLabel(String label) => 'Acción: $label';
}