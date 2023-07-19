// ignore_for_file: must_be_immutable
import 'dart:io';
import 'package:firstapp/infrastructure/controllers/drawingRoomController.dart';
import 'package:firstapp/infrastructure/theme/app_color.dart';
import 'package:firstapp/infrastructure/views/noteWidgets/nota_nueva.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firstapp/infrastructure/implementations/drawingRoomImp/drawing_point.dart';
import 'package:flutter/services.dart';
import 'package:firstapp/controllerFactory.dart';

// Ventana para esbozar una nota a mano
class DrawingRoomScreen extends StatefulWidget {
  const DrawingRoomScreen({super.key});

  @override
  State<DrawingRoomScreen> createState() => _DrawingRoomScreenState();
}

class _DrawingRoomScreenState extends State<DrawingRoomScreen> {
  // Paleta de colores para dibujar
  var avaiableColor = [
    Colors.black,
    Colors.red,
    Colors.amber,
    Colors.blue,
    Colors.green,
    Colors.white,
  ];

  // Se crea un controlador con la logica de la ventana Drawing Room
  DrawingRoomController Drawingcontroller = controllerFactory.createDrawingRoomController();

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
      appBar: AppBar(
        leading: BackButton(
          onPressed: (){
            Navigator.pop(context, bytes); 
          },
        ),
        title: const Text("Esbozado"),
        backgroundColor: const Color.fromARGB(255, 30, 103, 240),
      ),
      backgroundColor: Colors.white,
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
                            : Border.all(color: Colors.black, width: 2),
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
          const SizedBox(width: 8),
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
          const SizedBox(width: 8),
        // En este boton se guarda la nota esbozada
          FloatingActionButton(
            heroTag: "Save",
            
            onPressed: () async{

              final resultado = await Drawingcontroller.getImageFromWidget(pizarra(context, drawingPoints));
              // ignore: use_build_context_synchronously

              Navigator.pop(context, resultado.right);  
            },
            child: const Icon(Icons.check),
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
      //print("error guardando imagen ${e}");
    }
  }

  // Funcion para cargar la imagen en la aplicacion 
  Future<void> _loadEsbozar() async{
    try {
      final appStorage = await _localPath;
      final file = File('$appStorage/image.png');

      if (file.existsSync()) {
        //final bytes = await file.readAsBytes();
   
        // ignore: use_build_ntext_synchronously, use_build_context_synchronously
        Navigator.push(context,
                              MaterialPageRoute(
                              builder: (context) => NotaNueva(null)));
      }

    } catch (e) {
      //
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

// Lienzo sobre el cual se va a realizar el esbozado
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


