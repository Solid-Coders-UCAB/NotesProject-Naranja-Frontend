
// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';

import "package:flutter_tags_x/flutter_tags_x.dart";

class notaEtiquetas extends StatelessWidget {

  const notaEtiquetas({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Etiquetas"),
        backgroundColor: const Color.fromARGB(255, 99, 91, 250),
        leading: IconButton(
            icon:  const Icon(Icons.transit_enterexit_outlined),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: const etiquetasNota(),
    );
  }
}

class etiquetasNota extends StatefulWidget {

  const etiquetasNota({super.key});

  @override
  State<etiquetasNota> createState() => etiquetasNotaState();
}

class etiquetasNotaState extends State<etiquetasNota> {

 List<String> tagsList = ['apple', 'banana', 'orange', 'kiwi', 'Mondongo'];
  List<String> selectedTags = [];

  @override
  Widget build(BuildContext context) {
    return 
      ListTile(
       title: const Text("etiquetas disponibles"), 
       subtitle: Tags(  
              direction: Axis.horizontal,
              itemCount: tagsList.length, 
              itemBuilder: (int index){ 
              return Tooltip(
                message: tagsList[index],
                child: ItemTags(
                  textActiveColor: Colors.black,
                  color:  Colors.blueGrey,
                  activeColor: Colors.white,
                  title: tagsList[index], index: index,
                  pressEnabled: true,
                  onPressed: (item) {
                    selectedTags.add(item.title!);
                    print(selectedTags.first);
                  },
               )   
             );
            } 
          )
       ) ;
}

}
  



