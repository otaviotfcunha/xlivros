class LivrosModel {
  int _id = 0;
  String _nome = "";
  String _autor = "";
  String _data = "";
  String _imagem = "";
  int _lido = 0;

  LivrosModel(
      this._id, this._nome, this._autor, this._data, this._imagem, this._lido);

  int get id => _id;
  set id(int value) {
    _id = value;
  }

  String get nome => _nome;
  set nome(String value) {
    _nome = value;
  }

  String get autor => _autor;
  set autor(String value) {
    _autor = value;
  }

  String get data => _data;
  set data(String value) {
    _data = value;
  }

  String get imagem => _imagem;
  set imagem(String value) {
    _imagem = value;
  }

  int get lido => _lido;
  set lido(int value) {
    _lido = value;
  }
}
