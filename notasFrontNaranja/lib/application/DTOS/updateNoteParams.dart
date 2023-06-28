import 'dart:typed_data';

class UpdateNoteParams {
  String idNota;
  int? longitud;
  int? latitud;
  String titulo;
  String contenido;
  List<Uint8List>? imagenes;
  DateTime n_date;
  
  UpdateNoteParams({
    required this.idNota,
    required this.contenido,
    required this.titulo,
    this.longitud,
    this.latitud,
    this.imagenes,
    required this.n_date
  });

  get getIdNota => idNota;
  get getTitulo => titulo;
  get getContenido => contenido;
  get getLongitud => longitud;
  get getLatitud => latitud;
  get getDate => n_date;
}