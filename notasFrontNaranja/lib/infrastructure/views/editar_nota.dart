
import 'package:flutter/material.dart';

import './widgets.dart';
import 'package:firstapp/domain/nota.dart';

/// Esta ventana se abre al seleccionar una nota para editarla o eliminarla
///
// ignore: must_be_immutable
class EditarNota extends StatelessWidget {
  Nota nota;

  EditarNota(this.nota, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(""),
        backgroundColor: const Color.fromARGB(255, 99, 91, 250),
      ),
      body: Center(
        child: NotaEditar(nota),
      ),
    );
  }
}

// ignore: must_be_immutable
class NotaEditar extends StatefulWidget {
  final Nota _nota;
  const NotaEditar(this._nota, {super.key});

  @override
  // ignore: no_logic_in_create_state
  State<NotaEditar> createState() => _EditarNotaState(_nota);
}

class _EditarNotaState extends State<NotaEditar> {
  Nota _nota;

  _EditarNotaState(this._nota);

  @override
  Widget build(BuildContext context) {
    final TextEditingController _tituloC =
        TextEditingController(text: _nota.titulo);
    final TextEditingController _contenidoC =
        TextEditingController(text: _nota.contenido);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
      //height: 500.0,
      color: Colors.white,
      child: SingleChildScrollView(
          // Se agrega esta linea para que se pueda ver todo el texto que se escribe en la nota
          child: Form(
              child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          genericTextFormField(_tituloC, "Título de la nota", false, 40),
          maxLinesTextFormField(_contenidoC, "Contenido", false, 2000),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                  // Boton para editar la nota
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25)),
                    backgroundColor: const Color.fromARGB(255, 99, 91, 250),
                  ),
                  onPressed: () async {
                    if (_tituloC.text != '') {

                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Nota editada")));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text(
                              "El título de la nota no debe estar vacía")));
                    }
                  },
                  child: const Text("Editar")),
              const SizedBox(
                width: 15,
              ),
              ElevatedButton(
                  // Boton para eliminar la nota
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25)),
                    backgroundColor: const Color.fromARGB(255, 99, 91, 250),
                  ),
                  onPressed: () {
                    showDialog(
                        //Ventana de advertencia para confirmar eliminar la nota
                        //Ventana de dialogo, aparece si el usuario ingresa mal sus datos
                        barrierDismissible: false,
                        context: context,
                        builder: (_) => AlertDialog(
                              title: const Text("Advertencia"),
                              content: const Text(
                                  "Esta seguro de que desea eliminar la nota?"), // Modificar el comentario de advertencia
                              actions: [
                                TextButton(
                                    onPressed: () async {
                                      /// Aqui se debe eliminar en la BD

                                      Navigator.pop(context);
                                      Navigator.of(context, rootNavigator: true)
                                          .pop('dialog');

                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              content: Text("Nota eliminada")));
                                    },
                                    child: Text("Aceptar")),
                                TextButton(
                                    onPressed: () {
                                      Navigator.of(context, rootNavigator: true)
                                          .pop('dialog');
                                      Navigator.pop(context);
                                    },
                                    child: Text("Cancelar")),
                              ],
                            ));

                    ////////   esto es lo que se hace
                  },
                  child: const Text("Eliminar")),
              const SizedBox(
                width: 15,
              ),
              ElevatedButton(
                  // Boton para cancelar
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25)),
                    backgroundColor: const Color.fromARGB(255, 99, 91, 250),
                  ),
                  onPressed: () {
                    Navigator.pop(context, 'refresh');
                  },
                  child: const Text("Cancelar"))
            ],
          ),
        ],
      ))),
    );
  }

  @override
  void dispose() {
    //_contenidoC.dispose();
    //_tituloC.dispose();
    super.dispose();
  }
}



