import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

//útil quando há uma única instância, no caso nosso banco, pode ser a mesma instância
class AnotacaoHelper{

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
    }else inicializarDB();
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

}
