import 'package:flutter_test/flutter_test.dart';
import 'package:mexican_banknote_recognition/main.dart';

void main() {
  testWidgets('home screen renders app name and tap hint', (WidgetTester tester) async {
    await tester.pumpWidget(const MexicanBanknoteRecognitionApp());
    expect(find.text('Habla Billete'), findsOneWidget);
    expect(find.text('Toque la pantalla para escanear un billete'), findsOneWidget);
  });
}
