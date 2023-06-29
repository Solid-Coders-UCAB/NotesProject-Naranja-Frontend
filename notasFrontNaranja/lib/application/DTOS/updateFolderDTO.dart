// ignore: camel_case_types
class updateFolderDTO{

  String nombreCarpeta;
  String idCarpeta;

  updateFolderDTO({
    required this.nombreCarpeta,
    required this.idCarpeta
  });

  String getName() => nombreCarpeta;
  String getId() => idCarpeta;
  
}