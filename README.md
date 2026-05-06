# Mexican Banknote Recognition

Monorepo for an offline AI-powered accessibility mobile application focused on Mexican banknote recognition with speech feedback.

## Repository Layout

```text
mexican-banknote-recognition/
├── mobile_app/
├── ai_model/
├── dataset/
├── docs/
├── .gitignore
└── README.md
```

## Packages

- `mobile_app/`: Flutter mobile app for blind and low-vision users
- `ai_model/`: future training, preprocessing, notebooks, and exported models
- `dataset/`: raw, processed, and augmented image assets
- `docs/`: design and implementation notes

## Notes

- The Flutter application now lives in [mobile_app/README.md](mobile_app/README.md).
- The app is structured for future TensorFlow Lite, PyTorch, ONNX Runtime, and Core ML integration.

## Run The App

1. Change into `mobile_app/`.
2. Run `flutter pub get`.
3. Run `flutter run`.