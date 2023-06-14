class CreatenoteParams {
  
  int? longitud;
  int? latitud;
  String? titulo;
  String? contenido;
  
  CreatenoteParams({
    this.contenido,
    this.titulo,
    this.longitud,
    this.latitud,
  });


  get getTitulo => titulo;
  get getContenido => contenido;
  get getLongitud => longitud;
  get getLatitud => latitud;
}