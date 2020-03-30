import 'package:anotacoessqliteflutterapp/model/anotacao.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

//útil quando há uma única instância, no caso nosso banco, pode ser a mesma instância
class AnotacaoHelper{

  static final String nomeTabela = "anotacao";
  static final AnotacaoHelper _anotacaoHelper = AnotacaoHelper._internal();

  Database _db;

  factory AnotacaoHelper(){
    return _anotacaoHelper;
  }

  AnotacaoHelper._internal(){

  }

  get db async{
    if (_db != null) {
      return _db;
    }else _db = await inicializarDB();
    return _db;
  }


  _onCreate(Database db, int v) async{
    String sql = "CREATE TABLE anotacao (id INTEGER PRIMARY KEY AUTOINCREMENT, titulo VARCHAR, descricao TEXT, data DATETIME)";
    await db.execute(sql);
  }

  inicializarDB() async {
    final caminhoBanco = await getDatabasesPath();
    final localBanco = join(caminhoBanco, "minhas_anot.db");

    var db = await openDatabase(
      localBanco,
      version: 1,
      onCreate: _onCreate
    );
    return db;
  }

  Future<int> atualizarAnotacao(Anotacao anotacao) async{
    var bd = await db;
    return await bd.update(
      nomeTabela,
      anotacao.toMap(),
      where : "id = ?",
      whereArgs : [anotacao.id]
    );
  }

  recuperarAnotacoes() async{
    var bd = await db;
    String sql = "SELECT * FROM $nomeTabela ORDER BY data DESC";
    List anotacoes = await bd.rawQuery(sql);
    return anotacoes;
  }

  Future<int> salvar(Anotacao a) async{
    var bd = await db;

    int resultado = await bd.insert(
        nomeTabela,
        a.toMap(),
      );
    return resultado;
  }

}
