import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class SpeechScreen extends StatefulWidget {

  String text = 'Press the button and start speaking';

  SpeechScreen({super.key,required this.text});

  @override
  // ignore: no_logic_in_create_state
  State<SpeechScreen> createState() => SpeechScreenState(text: text);

  get getText => text; 
}

class SpeechScreenState extends State<SpeechScreen> {
  stt.SpeechToText _speech = stt.SpeechToText();
  bool isListening = false;
  double confidence = 1.0;
  String text;
  
  SpeechScreenState({required this.text});

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Confidence: ${(confidence * 100.0).toStringAsFixed(1)}%'),        
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AvatarGlow(
          animate: isListening,
          glowColor: Theme.of(context).primaryColor,
          endRadius: 75.0,
          duration: const Duration(milliseconds: 2000),
          repeatPauseDuration: const Duration(milliseconds: 100),
          repeat: true,
          child: FloatingActionButton(
              onPressed: _listen,
              child: Icon(isListening ? Icons.mic : Icons.mic_none))),
      body: Row(  
           children: [
      SingleChildScrollView(
        reverse: true,
        child: Container(
          padding: const EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 150.0),
          child: Text(text),         
        ),
      ),FloatingActionButton(
            heroTag: 'Speech to text',
            onPressed: () {
                Navigator.pop(context, text); // datos de vuelta a la primera pantalla},
            },
            child: const Icon(Icons.save))],
    ));
  }

  void _listen() async {
    if (!isListening) {
      bool available = await _speech.initialize(
       // onStatus: (val) => print('onStatus: $val'),
       // onError: (val) => print('onError: $val'),
      );
      if (available) {
        setState(() => isListening = true);
        _speech.listen(
          onResult: (val) => setState(() {
            text = val.recognizedWords;
            if (val.hasConfidenceRating && val.confidence > 0) {
              confidence = val.confidence;
            }
          }),
        );
      }
    } else {
      setState(() => isListening = false);
      _speech.stop();
    }
  }
}
