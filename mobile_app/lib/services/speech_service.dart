class SpeechService {
  const SpeechService();

  Future<void> speak(String message) async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
  }
}