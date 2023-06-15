// ignore_for_file: must_be_immutable

import 'dart:io';
import 'dart:typed_data';
import 'package:firstapp/infrastructure/theme/app_color.dart';
import 'package:firstapp/infrastructure/views/nota_nueva.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firstapp/infrastructure/implementations/drawingRoomImp/drawing_point.dart';
import 'package:flutter/services.dart';
import 'package:screenshot/screenshot.dart';
//import 'dart:ui' as ui;

class DrawingRoomScreen extends StatefulWidget {
  const DrawingRoomScreen({super.key});

  @override
  State<DrawingRoomScreen> createState() => _DrawingRoomScreenState();
}

class _DrawingRoomScreenState extends State<DrawingRoomScreen> {
  var avaiableColor = [
    Colors.black,
    Colors.red,
    Colors.amber,
    Colors.blue,
    Colors.green,
    Colors.white,
  ];

  final GlobalKey genKey = GlobalKey();
  Uint8List? bytes;

  var historyDrawingPoints = <DrawingPoint>[];
  var drawingPoints = <DrawingPoint>[];

  var selectedColor = Colors.black;
  var selectedWidth = 2.0;

  DrawingPoint? currentDrawingPoint;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        
        children: [

          /// Canvas (Lienzo)
          GestureDetector(
            onPanStart: (details) {
              setState(() {
                currentDrawingPoint = DrawingPoint(
                  id: DateTime.now().microsecondsSinceEpoch,
                  offsets: [
                    details.localPosition,
                  ],
                  color: selectedColor,
                  width: selectedWidth,
                );

                if (currentDrawingPoint == null) return;
                drawingPoints.add(currentDrawingPoint!);
                historyDrawingPoints = List.of(drawingPoints);
              });
            },
            onPanUpdate: (details) {
              setState(() {
                if (currentDrawingPoint == null) return;

                currentDrawingPoint = currentDrawingPoint?.copyWith(
                  offsets: currentDrawingPoint!.offsets
                    ..add(details.localPosition),
                );
                drawingPoints.last = currentDrawingPoint!;
                historyDrawingPoints = List.of(drawingPoints);
              });
            },
            onPanEnd: (_) {
              currentDrawingPoint = null;
            },
            child: pizarra(context, drawingPoints) //Widget CustomPaint
          ),

          /// Paleta de colores
          Positioned(
            top: MediaQuery.of(context).padding.top,
            left: 16,
            right: 16,
            child: SizedBox(
              height: 80,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: avaiableColor.length,
                separatorBuilder: (_, __) {
                  return const SizedBox(width: 8);
                },
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedColor = avaiableColor[index];
                      });
                    },
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: avaiableColor[index],
                        shape: BoxShape.circle,
                      ),
                      foregroundDecoration: BoxDecoration(
                        border: selectedColor == avaiableColor[index]
                            ? Border.all(color: AppColor.primaryColor, width: 4)
                            : null,
                        shape: BoxShape.circle,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          /// Grosor del lapiz para esbozar
          Positioned(
            top: MediaQuery.of(context).padding.top + 80,
            right: 0,
            bottom: 150,
            child: RotatedBox(
              quarterTurns: 3, // 270 degree
              child: Slider(
                value: selectedWidth,
                min: 1,
                max: 20,
                onChanged: (value) {
                  setState(() {
                    selectedWidth = value;
                  });
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [

          FloatingActionButton(
            heroTag: "Undo",
            onPressed: () {
              if (drawingPoints.isNotEmpty && historyDrawingPoints.isNotEmpty) {
                setState(() {
                  drawingPoints.removeLast();
                });
              }
            },
            child: const Icon(Icons.undo),
          ),
          const SizedBox(width: 16),
          FloatingActionButton(
            heroTag: "Redo",
            onPressed: () {
              setState(() {
                if (drawingPoints.length < historyDrawingPoints.length) {
                  // 6 length 7
                  final index = drawingPoints.length;
                  drawingPoints.add(historyDrawingPoints[index]);
                }
              });
            },
            child: const Icon(Icons.redo),
          ),

        // En este boton se guarda la nota esbozada
          FloatingActionButton(
            heroTag: "Save",
            
            onPressed: () async{
              final controller = ScreenshotController();
              final bytes = await controller.captureFromWidget(
                Material(child: pizarra(context, drawingPoints))
              );

              setState(() => this.bytes = bytes);
              _saveEsbozar(bytes);

              _loadEsbozar();

              
            },
            child: const Icon(Icons.camera_alt),
          ),
          
        ],
      ),
    );
  }

// Funcion para guardar la imagen en el almacenamiento del telefono
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
  
    return directory.path;
  }

  // Funcion para guardar la imagen del esbozado en el almacenamiento del telefono
  Future<void> _saveEsbozar(Uint8List bytes) async{
    try {
      final appStorage = await _localPath;
      final file = File('$appStorage/image.png');
      file.writeAsBytes(bytes); 
    } catch (e) {
      print("error guardando imagen ${e}");
    }
  }

  // Funcion para cargar la imagen en la aplicacion 
  Future<void> _loadEsbozar() async{
    try {
      final appStorage = await _localPath;
      final file = File('$appStorage/image.png');

      if (file.existsSync()) {
        final bytes = await file.readAsBytes();
   
        // ignore: use_build_ntext_synchronously, use_build_context_synchronously
        Navigator.push(context,
                              MaterialPageRoute(
                              builder: (context) => const NotaNueva()));
      }

    } catch (e) {
      print("error guardando imagen ${e}");
    }
  }

  
}

// Clase para dibujar en el lienzo que proporciona el widget CustomPaint
class DrawingPainter extends CustomPainter {
  final List<DrawingPoint> drawingPoints;

  DrawingPainter({required this.drawingPoints});

  @override
  void paint(Canvas canvas, Size size) {
    for (var drawingPoint in drawingPoints) {
      final paint = Paint()
        ..color = drawingPoint.color
        ..isAntiAlias = true
        ..strokeWidth = drawingPoint.width
        ..strokeCap = StrokeCap.round;

      for (var i = 0; i < drawingPoint.offsets.length; i++) {
        var notLastOffset = i != drawingPoint.offsets.length - 1;

        if (notLastOffset) {
          final current = drawingPoint.offsets[i];
          final next = drawingPoint.offsets[i + 1];
          canvas.drawLine(current, next, paint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

Widget pizarra(BuildContext context, List<DrawingPoint> drawingPoints){
 return CustomPaint(
              painter: DrawingPainter(
                drawingPoints: drawingPoints,
              ),
              child: SizedBox(
                
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
              ),
            );
}




class Pagina03 extends StatelessWidget {
  Uint8List? bytes;
  Pagina03(this.bytes);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nueva nota"),
        backgroundColor: Colors.orange,
      ),
      body:  Center(
        child: NuevaNota(bytes),
      ),
    );
  }
}

class Pagina02 extends StatelessWidget {
  Uint8List? bytes;
  Pagina02(this.bytes);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Esbozado"),
        backgroundColor: Colors.orange,
      ),
      body:  Center(
        child: Imagen(bytes),
      ),
    );
  }
}

class NuevaNota extends StatefulWidget {
Uint8List? bytes;
  NuevaNota(this.bytes);

  @override
  State<NuevaNota> createState() => _NuevaNotaState2(bytes);
}

class Imagen extends StatefulWidget {
Uint8List? bytes;
  Imagen(this.bytes);

  @override
  State<Imagen> createState() => _ImagenState(bytes);
}

class _ImagenState extends State<Imagen> {
  Uint8List? bytes;


  _ImagenState(this.bytes);
  


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
      //height: 500.0,
      color: Colors.white,
      child: ListView(children: [if(bytes != null) Image.memory(bytes!), ],)///////aaaaaaaaaaaaaaaaaaaa
    );
  }


}



class _NuevaNotaState2 extends State<NuevaNota> {
  Uint8List? bytes;
  _NuevaNotaState2(this.bytes);
  final TextEditingController _tituloC = TextEditingController(text: "");
  final TextEditingController _contenidoC = TextEditingController(text: "");

  @override
  Widget build(BuildContext context) {
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
          GestureDetector(
            onTap: (){
              Navigator.push(context,
                              MaterialPageRoute(
                              builder: (context) => Pagina02(bytes)));
            },
            child: SizedBox(
              
              width: 400,
              height: 200,
              child: Image.memory(
                            bytes!,
                      ),
            ),
          ),
          genericTextFormField(
              _contenidoC, "Contenido de la nota", false, 2000),
          //     2000, // Aqui se indica el maximo de caracteres que se pueden ingresar a la nota
          // TextFormField(
          // controller: _contenidoC,
          // decoration: const InputDecoration(labelText: "Contenido"),
          // maxLength:

          /// Para determinar el maximo de lineas que puede tener el campo de texto del cuerpo de la nota
          // maxLines: null,
          //initialValue: "contenido de la nota",  //Aqui se debe cargar el contenido de la nota de la base de datos
          // ),
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
                      
                      //Navigator.push(context, MaterialPageRoute(builder: (context) => Home(id_client)));
                      Navigator.pop(context);
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
    _contenidoC.dispose();
    _tituloC.dispose();
    super.dispose();
  }
}



Widget genericTextFormField(TextEditingController controllerData, String text, boolean,int maxLength) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
    child: TextFormField(
      controller: controllerData,
      maxLength: maxLength,
      style: const TextStyle(
      color: Color.fromARGB(255, 154, 181, 255), 
      ),
      obscureText: boolean,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(
            color: Color.fromARGB(255, 154, 181, 255),
            width: 2,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(
            color: Color.fromARGB(255, 154, 181, 255),
            width: 2,
          ),
        ),
        labelText: text,
        labelStyle: const TextStyle(
          color: Color.fromARGB(255, 154, 181, 255), 
        ),
      ),
    ),
  );
}

Widget maxLinesTextFormField(TextEditingController controllerData, String text, boolean,int maxLength) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
    child: TextFormField(
      controller: controllerData,
      maxLength: maxLength,
      maxLines: null,
      style: const TextStyle(
      color: Color.fromARGB(255, 154, 181, 255), 
      ),
      obscureText: boolean,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(
            color: Color.fromARGB(255, 154, 181, 255),
            width: 2,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(
            color: Color.fromARGB(255, 154, 181, 255),
            width: 2,
          ),
        ),
        labelText: text,
        labelStyle: const TextStyle(
          color: Color.fromARGB(255, 154, 181, 255), 
        ),
      ),
    ),
  );
}

////////////////////////////////////
///

