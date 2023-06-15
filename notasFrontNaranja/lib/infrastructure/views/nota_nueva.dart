
import 'package:firstapp/controllerFactory.dart';
import 'package:flutter/material.dart';


import '../controllers/notaNuevaWidgetController.dart';
import './widgets.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class NotaNueva extends StatelessWidget {

  const NotaNueva({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nueva nota"),
        backgroundColor: const Color.fromARGB(255, 99, 91, 250),
      ),
      body: const Center(
        child: NuevaNota(),
      ),
    );
  }
}

class NuevaNota extends StatefulWidget {
  const 
  NuevaNota({
    super.key,
  });

  @override
  State<NuevaNota> createState() => NuevaNotaState();
}

class NuevaNotaState extends State<NuevaNota> {

 String noteContent = '';
 String noteTitle = '';
 bool loading = false;
 notaNuevaWidgetController controller = controllerFactory.notaNuevaWidController();
//
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;

  final TextEditingController _tituloC = TextEditingController(text: "");
  final TextEditingController _contenidoC = TextEditingController(text: "");


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
      //height: 500.0,
      color: Colors.white,
          child: loading == true ? const Center(child: SizedBox(
          width: 30,
          height: 30,
          child: CircularProgressIndicator()
        ))         
       :
          SingleChildScrollView(
          // Se agrega esta linea para que se pueda ver todo el texto que se escribe en la nota
          child: Form(
              child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          genericTextFormField(_tituloC, "Título de la nota", false, 40),
          maxLinesTextFormField(
              _contenidoC, "Contenido de la nota", false, 2000),
          loading == true ? const Row()
          :    
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            
            children: [
              opcionesNota(this)
            ]),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25)),
                    backgroundColor: const Color.fromARGB(255, 99, 91, 250),
                  ),
                  onPressed: () {
                    if (_tituloC.text != '') {
                      saveNota();


                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Nota agregada")));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text(
                              "El título de la nota no debe estar vacía")));
                    }
                  },
                  child: const Text("Aceptar")),
              const SizedBox(
                width: 15,
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 99, 91, 250),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25)),
                  ),
                  onPressed: () {
                 
                  },
                  child: const Text("Cancelar")),              
            ],
          ),
        ],
      ))),
    );
  }

Future saveNota() async {
    setState(() {
      loading = true;
    });
    var response = await controller.saveNota(titulo: _tituloC.text,contenido: _contenidoC.text);
    if (response.isLeft){
          setState((){
              loading = false;
          });
          String text ='';
          text = response.left.message!;
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar( SnackBar(content: Text(text)));
      }
     if (response.isRight){ 
        setState(() {
          _contenidoC.text = '';
          _tituloC.text = '';
          loading = false;
        });
      }
  }

  Future getTextFromIa() async {
    setState(() {
      loading = true;
    });
    var response = await controller.showTextFromIA();
    if(response.isLeft){
        setState((){
          loading = false;
        });
          String text ='';
          text = response.left.message!;
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar( SnackBar(content: Text(text)));          
    }
  if (response.isRight){
          setState(() {
          _contenidoC.text = "${_contenidoC.text}\n${response.right}";
          loading = false;
        }); 
    }    
  }

    void listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
       // onStatus: (val) => print('onStatus: $val'),
       // onError: (val) => print('onError: $val'),
      );
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) => setState(() {
            _contenidoC.text = _contenidoC.text + val.recognizedWords;
            if (val.hasConfidenceRating && val.confidence > 0) {
              //_confidence = val.confidence;
            }
          }),
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  
    void showAudioToText({required String contenido,required String titulo}){
      setState(() {
         noteContent = '$contenido ';
         _contenidoC.text = contenido;
         _tituloC.text = titulo;
         loading = false;
      });
    }

    String getTitulo(){
      return _tituloC.text;
    }

    String getContenido(){
      return _contenidoC.text;
    }

}



