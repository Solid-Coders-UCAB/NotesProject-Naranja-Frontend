
import 'package:firstapp/controllerFactory.dart';
import 'package:flutter/material.dart';

import '../controllers/notaNuevaWidgetController.dart';
import './widgets.dart';

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
          _contenidoC.text = "${_contenidoC.text}${response.right}";
          loading = false;
        }); 
    }    
  }


}



