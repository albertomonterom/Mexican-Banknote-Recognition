# Mexican Banknote Recognition

Mexican Banknote Recognition is an accessibility-first Flutter mobile application for offline recognition of Mexican banknotes with voice feedback. The first version focuses on a scalable architecture, a simulated recognition flow, and a UI designed for blind and low-vision users.

This Flutter app lives inside the `mobile_app/` package of the repository monorepo.

## Accessibility Goals

- Very large touch targets
- High-contrast visual design
- Minimal text on each screen
- Clear Spanish labels
- Semantic labels for screen readers
- Optional haptic feedback hooks
- Voice feedback placeholders
- Simple navigation flow
- Low visual clutter

## Planned Tech Stack

- Flutter
- Provider for lightweight state management
- Camera package for live capture
- TensorFlow Lite for on-device inference
- Core ML for iOS optimization
- ONNX Runtime for cross-platform model execution
- Text-to-speech package for spoken feedback
- Haptic feedback from Flutter services

## Future AI Integration

The current app uses a fake prediction flow so the architecture can be validated without a model. The service layer is separated so the recognition pipeline can later swap in a real model implementation using TensorFlow Lite, Core ML, or ONNX Runtime without rewriting the UI.

## Folder Structure

```text
lib/
  accessibility/
  constants/
  models/
  providers/
  screens/
  services/
  utils/
  widgets/
  main.dart
```

## Setup Instructions

1. Install Flutter from the official SDK.
2. Change into the `mobile_app/` directory.
3. Run `flutter pub get` inside `mobile_app/`.
4. Start the app with `flutter run` on a connected device or emulator.
5. Replace the fake ML service with a real inference backend when the model is ready.

## Notes

- The current version does not connect to a real camera or ML model.
- Recognition results are simulated with sample outputs such as `Billete de 100 pesos.`