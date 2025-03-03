import 'package:audioplayers/audioplayers.dart';

class AudioService {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal();

  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isSoundEnabled = true;

  Future<void> playMessageSound() async {
    if (!_isSoundEnabled) return;
    try {
      await _audioPlayer.play(AssetSource('sounds/message.mp3'));
    } catch (e) {
      print('Error playing sound: $e');
    }
  }

  void toggleSound(bool enabled) {
    _isSoundEnabled = enabled;
  }
} 