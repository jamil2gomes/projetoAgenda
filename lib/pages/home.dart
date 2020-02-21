import 'dart:io';
import 'package:agenda_app/helper/ContatoHelper.dart';
import 'package:agenda_app/pages/contato_page.dart';
import 'package:flutter/material.dart';
import 'package:agenda_app/model/Contato.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  ContatoHelper contatoHelper = ContatoHelper();
  List<Contato> contatos = List();

  @override
  void initState() {
    super.initState();
    _getAllContatos();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agenda de Contatos'),
        backgroundColor: Colors.redAccent,
        centerTitle: true,
        actions: <Widget>[],
      ),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.redAccent,
        onPressed: () {
          _showContatoPage();
        },
      ),
      body: ListView.builder(
          padding: EdgeInsets.all(10.0),
          itemCount: contatos.length,
          itemBuilder: (context, index) {
            return _contatoCard(context, index);
          }),
    );
  }

  Widget _contatoCard(BuildContext context, int index) {
    return GestureDetector(
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Row(
            children: <Widget>[
              Container(
                width: 80.0,
                height: 80.0,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                    image:contatos[index].imagem != null
                        ? FileImage(File(contatos[index].imagem))
                        : AssetImage('imagem/icons8-nome-64.png') ,
                        fit: BoxFit.cover
                    )),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(contatos[index].nome ?? '',
                        style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold)),
                    Text(contatos[index].email ?? '',
                        style: TextStyle(fontSize: 18.0)),
                    Text(contatos[index].telefone ?? '',
                        style: TextStyle(fontSize: 18.0)),
                  ],
                ),
              )
            ],
          ),
        ),

      ),
      onTap: (){
        _showContatoPage(c: contatos[index]);
      },
    );
  }

  void _getAllContatos(){
    contatoHelper.getContatos().then((list) {
      setState(() {
        contatos = list;
      });
    });
  }


  void _showContatoPage({Contato c}) async {
    final contatoRecebido = await Navigator.push(context, MaterialPageRoute(builder: (context) => ContatoPage(contato: c,)));

    if (contatoRecebido != null) {
      if (c != null){
        await contatoHelper.updateContato(contatoRecebido);
      }
      else{
        await contatoHelper.insert(contatoRecebido);
      }

      _getAllContatos();
    }
  }
}
