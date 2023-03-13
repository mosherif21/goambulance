import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goambulance/src/features/home_screen/components/speech_to_text_test/controllers/speech_controller.dart';

class SpeechToTextWidget extends StatelessWidget {
  const SpeechToTextWidget({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final speechController = Get.put(SpeechController());
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Speech to Text test',
          style: TextStyle(
              fontSize: 25.0, fontWeight: FontWeight.w800, color: Colors.white),
        ),
        backgroundColor: const Color(0xFF28AADC),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () => speechController.onListen(),
        child: Obx(
          () => Icon(
            speechController.isListening.value ? Icons.close : Icons.mic,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Obx(
            () => Text(
              speechController.spokenText.value,
              style: const TextStyle(
                  fontSize: 25.0,
                  fontWeight: FontWeight.w800,
                  color: Colors.black),
            ),
          ),
        ),
      ),
    );
  }
}
