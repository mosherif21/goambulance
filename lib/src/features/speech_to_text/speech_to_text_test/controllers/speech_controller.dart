import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SpeechController extends GetxController {
  static SpeechController get instance => Get.find();
  late final SpeechToText _speechToText;
  RxString spokenText = 'Press to start speaking'.obs;
  RxBool isListening = false.obs;
  @override
  void onInit() {
    _speechToText = SpeechToText();
    super.onInit();
  }

  void onListen() async {
    if (!isListening.value) {
      bool available = await _speechToText.initialize(onStatus: (status) {
        if (kDebugMode) print('onStatus$status');
      }, onError: (error) {
        if (kDebugMode) print('onStatus$error');
      });
      if (available) {
        isListening.value = true;
        _speechToText.listen(
          listenMode: ListenMode.dictation,
          localeId: Get.locale?.languageCode,
          listenFor: const Duration(seconds: 5),
          onResult: (listenedText) {
            spokenText.value = listenedText.recognizedWords;
            isListening.value = false;
            _speechToText.stop();
          },
        );
      }
    } else {
      isListening.value = false;
      _speechToText.stop();
    }
  }
}
