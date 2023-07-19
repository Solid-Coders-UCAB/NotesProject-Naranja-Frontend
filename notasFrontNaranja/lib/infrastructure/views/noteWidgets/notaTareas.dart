// Vista para la lista de tareas
import 'package:flutter/material.dart';
import '../../../domain/tarea.dart';
import 'package:firstapp/infrastructure/views/noteWidgets/textEditor.dart';
// ignore: must_be_immutable
class NotaTareas extends StatefulWidget {
  List<tarea> tasks = [];
  HtmlEditorExampleState home;

  NotaTareas({super.key, required this.tasks, required this.home});

  @override
  State<NotaTareas> createState() => NotaTareasState(tasks: tasks, home: home);
}

class NotaTareasState extends State<NotaTareas> {
  List<tarea> tasks = [];
   HtmlEditorExampleState home;
  NotaTareasState({required this.tasks, required this.home});

  var _controller = TextEditingController();
  @override
  void initState() {
    super.initState();
    //showTareas(idCarpeta);
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child:
          Column(
            children: [
              Expanded(
               // height: 200.0,
                child : 
                ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onLongPress:() {
                          showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                const ListTile(
                                  title: Text('Opciones'),
                                ),
                                ListTile(
                                  leading: const Icon(Icons.delete),
                                  title: Text('Eliminar'),
                                  onTap: () {
                                    Navigator.pop(context);
                                    eliminarTareaOnPressed(tasks[index]);
                                  },
                                ),
                                ListTile(
                                  leading: const Icon(Icons.close),
                                  title: Text('Salir'),
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            );
                          });
                        },
                        child: CheckboxListTile(
                        title:  Text(tasks[index].nombreTarea),
                        value: tasks[index].completada,
                        controlAffinity: ListTileControlAffinity.leading,
                        onChanged:(bool? value) { 
                          if (value != null) {
                             setState(() {
                            tasks[index].completada = value;
                          });
                          } 
                        },
                        
                                          ),
                      );   
                    }   
                    ),
              ),
      
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children:  [
                      Expanded(
                        child: TextField(
                          
                          controller: _controller,
                          maxLength: 30,
                          decoration: const InputDecoration(
                            labelText: "Nueva tarea",
                            labelStyle: TextStyle(
                            color: Color.fromARGB(255, 154, 181, 255), 
                          ),
                          ),
                        ),
                      ),
                      ElevatedButton(
                          onPressed: (){
                            if (_controller.text != '') {
                              addTareas(_controller.text);
                              _controller.text = "";
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                    "El nombre de la tarea no debe estar vacía")));
                            }
                          }, 
                        child: Icon(Icons.add)),
                    ],
                  ),
              )
            ],        
          ),
      
    );
  }

  void reset() {
    setState(() {
    //  loading = true;
    });
  }

  void addTareas(String nombreTarea) { 
   final t =  tarea.create(nombreTarea: nombreTarea, completada: false);
   if (t.isLeft){
    showSystemMessage(t.left.message);
   } else{
    tasks.add(t.right);
    reset();
    home.setState(() {
      home.tasks = tasks;
    });
    
   }
  }
  void eliminarTareaOnPressed(tarea task) {
    tasks.remove(task);
    reset();
    home.setState(() {
      home.tasks = tasks;
    });
  }

  void showSystemMessage(String? message){
    setState(() {
   //   loading = false;
    });
     ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message!)));
  }

}





