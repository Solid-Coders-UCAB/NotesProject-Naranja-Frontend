
import 'package:flutter/material.dart';
import './nota_nueva.dart';


// En este código está toda la interfaz de la app de notas
class PaginaPrincipal extends StatelessWidget {
 

  const PaginaPrincipal({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notas',
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {

  Home({super.key});

  @override
  homeState createState() => homeState();
}

class homeState extends State<Home> {

  homeState();

  @override
  Widget build(BuildContext context) {
    // Future<List<Nota>> listOfNotes = notesRequest(id_client);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 99, 91, 250),
        title: const Text("Notas"),
        //barra de busqueda
        // actions: [
        //   IconButton(
        //     onPressed: () {
        //       showSearch(
        //         context: context,
        //         delegate: CustomSearchDelegate(),
        //       );
        //     },
        //     icon: const Icon(Icons.search),
        //     alignment: Alignment.center,
        //   ),
        // ],
      ),
      floatingActionButton: Container(
        alignment: Alignment.bottomCenter,
        child: FloatingActionButton(
          backgroundColor: const Color.fromARGB(255, 99, 91, 250),
          onPressed: () async {
            //Abrir pagina de agregar nota

            String? refresh01 = await Navigator.push(context,
                MaterialPageRoute(builder: (context) => const NotaNueva()));
            if (refresh01 == 'refresh') {
              //refresh(id_client);
            }
          },
          heroTag: 'addButton',
          child: const Icon(Icons.add),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      
    );
  }



 
 

//Barra de busqueda
// class CustomSearchDelegate extends SearchDelegate {
//   List<String> searchTerms = [
//     'Nota 1',
//     'Campo 2',
//     'Nota 3',
//     'Contenido 4',
//     'Nota 5',
//     'Me quiero dormir 6',
//     'Nota 7'
//   ];

//   @override
//   List<Widget> buildActions(BuildContext context) {
//     return [
//       IconButton(
//           //Se limpia el query de la barra de busqueda
//           onPressed: () {
//             query = '';
//           },
//           icon: const Icon(Icons.clear))
//     ];
//   }

//   @override
//   Widget buildLeading(BuildContext context) {
//     return IconButton(
//         onPressed: () {
//           close(context, null);
//         },
//         icon: const Icon(Icons.arrow_back));
//   }

//   @override
//   Widget buildResults(BuildContext context) {
//     List<String> matchQuery = [];
//     for (var nota in searchTerms) {
//       if (nota.toLowerCase().contains(query.toLowerCase())) {
//         matchQuery.add(nota);
//       }
//     }
//     return ListView.builder(
//         itemCount: matchQuery.length,
//         itemBuilder: (context, index) {
//           var result = matchQuery[index];
//           return ListTile(
//             title: Text(result),
//           );
//         });
//   }

//   @override
//   Widget buildSuggestions(BuildContext context) {
//     List<String> matchQuery = [];
//     for (var nota in searchTerms) {
//       if (nota.toLowerCase().contains(query.toLowerCase())) {
//         matchQuery.add(nota);
//       }
//     }
//     return ListView.builder(
//       itemCount: matchQuery.length,
//       itemBuilder: (context, index) {
//         var result = matchQuery[index];
//         return ListTile(
//           title: Text(result),
//         );
//       },
//     );
//   }
//  }
 }