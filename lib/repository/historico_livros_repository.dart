import 'package:xlivros/models/livros_model.dart';
import 'package:xlivros/repository/sqflite/sqflite_database.dart';

class HistoricoLivrosRepository {
  Future<List<LivrosModel>> listarDados() async {
    List<LivrosModel> historico = [];
    var db = await SQLiteDataBase().obterDataBase();
    var result = await db.rawQuery('SELECT * FROM livros');
    for (var element in result) {
      historico.add(LivrosModel(
        int.parse(element["id"].toString()),
        element["nome"].toString(),
        element["autor"].toString(),
        element["data"].toString(),
        element["imagem"].toString(),
        int.parse(element["lido"].toString()),
      ));
    }
    return historico;
  }

  Future<void> salvar(LivrosModel historico) async {
    var db = await SQLiteDataBase().obterDataBase();
    await db.rawInsert(
        'INSERT INTO livros (nome, autor, data, lido, imagem) values(?,?,?,?,?)',
        [
          historico.nome,
          historico.autor,
          historico.data,
          historico.lido,
          historico.imagem
        ]);
  }

  Future<void> atualiza(int lido, int id) async {
    var db = await SQLiteDataBase().obterDataBase();
    await db.rawUpdate('UPDATE livros SET lido=? WHERE id=?', [lido, id]);
  }

  Future<void> remover(int id) async {
    var db = await SQLiteDataBase().obterDataBase();
    await db.rawDelete('DELETE FROM livros WHERE id = ?', [id]);
  }
}
