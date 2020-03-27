import 'package:anotacoessqliteflutterapp/helper/anotacao_helper.dart';
import 'package:anotacoessqliteflutterapp/model/anotacao.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  var _db = AnotacaoHelper();
  TextEditingController _tituloController = TextEditingController();
  TextEditingController _descricaoController = TextEditingController();
  List<Anotacao> _anotacoes = List<Anotacao>();

  _exibirTelaCadastro(){
    showDialog(
        context: context,
      builder: (context){
          return AlertDialog(
            title: Text("Adicionar anotação"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  controller: _tituloController,
                  autofocus: true,
                  decoration: InputDecoration(
                    labelText: "Título",
                    hintText: "Digíte o Título..."
                  ),
                ),
                TextField(
                  controller: _descricaoController,
                  decoration: InputDecoration(
                      labelText: "Descrição",
                      hintText: "Digíte a Descrição..."
                  ),
                ),
              ],
            ),
            actions: <Widget>[
              FlatButton(
                  onPressed: ()=> Navigator.pop(context),
                  child: Text("Cancelar")
              ),
              FlatButton(
                  onPressed: _salvarAnotacao,
                  child: Text("Salvar")
              ),
            ],
          );
      }
    );
  }

  _recuperarAnotacoes() async{
    _anotacoes.clear();
    List anotacoesRecuperadas = await _db.recuperarAnotacoes();
    List<Anotacao> anotacoesTemp = List<Anotacao>();
    for(var item in anotacoesRecuperadas){
      Anotacao anotacao = Anotacao.fromMap(item);
      anotacoesTemp.add(anotacao);
    }

    setState(() {
      _anotacoes = anotacoesTemp;
    });
    anotacoesTemp = null;

  }

  _salvarAnotacao() async{
    String titulo = _tituloController.text;
    String descricao = _descricaoController.text;
    Anotacao a = Anotacao(titulo, descricao, DateTime.now().toString());
    int resultado = await _db.salvar(a);
    _tituloController.clear();
    _descricaoController.clear();
    print(resultado.toString());

    _recuperarAnotacoes();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _recuperarAnotacoes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Anotações"),
        backgroundColor: Colors.lightGreen,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: _anotacoes.length,
                itemBuilder: (context, index){

                final anotacao = _anotacoes[index];
                  return Card(
                    child: ListTile(
                      title: Text(anotacao.titulo),
                      subtitle: Text("${anotacao.data} - ${anotacao.descricao}"),
                    ),
                  );
                }
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: _exibirTelaCadastro,
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        child: Icon(Icons.add),
      ),
    );
  }
}
