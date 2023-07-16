// ignore: camel_case_types
class updateEtiquetaDTO{

  String nombreEtiqueta;
  String idEtiqueta;

  updateEtiquetaDTO({
    required this.nombreEtiqueta,
    required this.idEtiqueta
  });

  String getNombre() => nombreEtiqueta;
  String getId() => idEtiqueta;
  
}