import 'package:anotacoessqliteflutterapp/helper/anotacao_helper.dart';
import 'package:anotacoessqliteflutterapp/model/anotacao.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var _db = AnotacaoHelper();
  TextEditingController _tituloController = TextEditingController();
  TextEditingController _descricaoController = TextEditingController();
  List<Anotacao> _anotacoes = List<Anotacao>();

  _exibirTelaCadastro({Anotacao a}){
    String textoSalvarAtualizar = "";
    if(a == null){ //salvando
      _tituloController.text = "";
      _descricaoController.text = "";
      textoSalvarAtualizar = "Adicionar";
    }else { //atualizando
      _tituloController.text = a.titulo;
      _descricaoController.text = a.descricao;
      textoSalvarAtualizar = "Atualizar";
    }

    showDialog(
        context: context,
      builder: (context){
          return AlertDialog(
            title: Text(" $textoSalvarAtualizar anotação"),
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
                  onPressed: (){
                    _salvarAtualizarAnotacao(anotacao: a);
                    Navigator.pop(context);
                  } ,
                  child: Text("$textoSalvarAtualizar")
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

  _salvarAtualizarAnotacao( {Anotacao anotacao} ) async{
    String titulo = _tituloController.text;
    String descricao = _descricaoController.text;

    if(anotacao == null){ // salvar
      Anotacao a = Anotacao(titulo, descricao, DateTime.now().toString());
      int resultado = await _db.salvar(a);
    }else{ //atualizando
      anotacao.titulo = titulo;
      anotacao.descricao = descricao;
      anotacao.data = DateTime.now().toString();
      int resultadoAtt = await _db.atualizarAnotacao(anotacao);
    }

    _tituloController.clear();
    _descricaoController.clear();

    _recuperarAnotacoes();
  }

  _formatData(String data){
    initializeDateFormatting('pt_BR');
    var formater = DateFormat("d/M/y H:m");
    return formater.format(DateTime.parse(data));
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
                      subtitle: Text("${_formatData(anotacao.data)} - ${anotacao.descricao}"),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          GestureDetector(
                          onTap: (){
                            _exibirTelaCadastro(a: anotacao);
                          },
                            child: Container (
                              child : Icon(Icons.edit,
                                color: Colors.green,
                              ),
                            )
                          ),
                          GestureDetector(
                            onTap: (){

                            },
                            child: Container(
                              padding: EdgeInsets.only(left: 10),
                              child: Icon(Icons.delete,
                                color: Colors.red,
                              ),
                            )
                          ),
                        ],
                      ),
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
