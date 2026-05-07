# Mexican Banknote Recognition

Mexican Banknote Recognition is an accessibility-first Flutter mobile application for offline recognition of Mexican banknotes with voice feedback. The first version focuses on a scalable architecture, a simulated recognition flow, and a UI designed for blind and low-vision users.

This Flutter app lives inside the `mobile_app/` package of the repository monorepo.

## Quick Start

```bash
cd /Users/amonterom/Documents/Mexican-Banknote-Recognition/mobile_app
flutter pub get
flutter doctor
flutter devices
```

Then run by explicit target:

```bash
flutter run -d macos
```

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
2. Install Xcode for iOS support.
3. Install Android Studio SDK/tools for Android support.
4. Change into the `mobile_app/` directory.
5. Run `flutter pub get`.
6. Run `flutter doctor` and resolve any issues.

## Run By Platform

### macOS

```bash
flutter run -d macos
```

### iOS (physical device)

1. Open `ios/Runner.xcworkspace` in Xcode.
2. Configure `Runner` target in Signing & Capabilities with your Team.
3. Trust developer certificate on iPhone if prompted.
4. Run:

```bash
flutter devices
flutter run -d <iphone_device_id>
```

### Android

1. Start an emulator in Android Studio or connect an Android phone.
2. Accept licenses if needed:

```bash
flutter doctor --android-licenses
```

3. Run:

```bash
flutter devices
flutter run -d <android_device_id>
```

## Device Selection Rules

- Prefer `flutter run -d <target>` to avoid launching on the wrong device.
- Use `flutter devices` each time to copy the exact device id.
- Common targets:
  - `macos` for desktop
  - iPhone UDID for iOS
  - emulator/device id for Android

## Troubleshooting

- App installs but does not open on iPhone:
  - Trust certificate in iPhone Settings > General > VPN & Device Management
- Flutter cannot control Xcode:
  - Enable permission in macOS Settings > Privacy & Security > Automation
- Flutter local network warning:
  - Enable terminal/IDE in macOS Settings > Privacy & Security > Local Network
- Device disconnects during run:
  - Keep iPhone unlocked and connected by cable
- Build works only in Xcode but not CLI:
  - Re-run `flutter doctor` and confirm iOS toolchain is green

## Notes

- The current version does not connect to a real camera or ML model.
- Recognition results are simulated with sample outputs such as `Billete de 100 pesos.`