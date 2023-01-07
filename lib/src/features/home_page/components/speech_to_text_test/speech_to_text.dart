import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goambulance/src/features/home_page/components/speech_to_text_test/controllers/speech_controller.dart';

class SpeechToTextWidget extends StatelessWidget {
  const SpeechToTextWidget({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final speechController = Get.put(SpeechController());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Speech to Text test'),
        backgroundColor: const Color(0xFF28AADC),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () => speechController.onListen(),
        child: Icon(
          speechController.isListening.value ? Icons.close : Icons.mic,
        ),
      ),
      body: SingleChildScrollView(
        reverse: true,
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Text(
            speechController.spokenText.value,
            style: const TextStyle(
                fontSize: 25.0,
                fontWeight: FontWeight.w800,
                color: Colors.black),
          ),
        ),
      ),
    );
  }
}
