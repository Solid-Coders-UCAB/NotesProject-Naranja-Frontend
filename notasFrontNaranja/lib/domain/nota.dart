class nota {
  String? _titulo;
  String? _body;

  nota._nota(String t,String b){ _body = b;  _titulo = t ;}

  static create(String t,String b){ nota._nota(t, b); }
  
}

