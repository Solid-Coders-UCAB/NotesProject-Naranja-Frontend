class Nota {
  Nota({
    this.n_edit_date,
    this.n_date,
    this.contenido,
    this.titulo,
    this.id,
  });
  String? titulo;
  String? contenido;
  DateTime? n_date;
  DateTime? n_edit_date;
  int? id;

  get getTitulo => titulo;
  get getContenido => contenido;
  get getDate => n_date;
  get getid => id;
  get getEditDate => n_edit_date;

}
//Acá se tiene un modelo inicial de lo que contiene las notas