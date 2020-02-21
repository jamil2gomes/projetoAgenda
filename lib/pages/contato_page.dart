import 'dart:io';
import 'package:flutter/material.dart';
import 'package:agenda_app/model/Contato.dart';

class ContatoPage extends StatefulWidget {
  final Contato contato;

  ContatoPage({this.contato});

  @override
  _ContatoPageState createState() => _ContatoPageState();
}

class _ContatoPageState extends State<ContatoPage> {

  Contato _contatoEditado;
  bool _textEditado = false;
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _nomeFocus = FocusNode();


  @override
  void initState() {
    super.initState();

    if(widget.contato == null){
      this._contatoEditado = Contato();
    }else{
      this._contatoEditado     = Contato.fromMap(widget.contato.toMap());
      _nomeController.text     = this._contatoEditado.nome;
      _emailController.text    = this._contatoEditado.email;
      _telefoneController.text = this._contatoEditado.telefone;
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_contatoEditado.nome ?? 'Novo Contato'),
        backgroundColor: Colors.redAccent,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            GestureDetector(
              child:    Container(
                width: 140.0,
                height: 140.0,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: _contatoEditado.imagem != null
                        ? FileImage(File( _contatoEditado.imagem))
                        : AssetImage('imagem/icons8-nome-64.png')),
              )),
            ),
            TextField(
              controller: _nomeController,
              focusNode: _nomeFocus,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(labelText: 'Nome'),
              onChanged: (text){
                _textEditado = true;
                setState(() {
                  _contatoEditado.nome = text;
                });
              },
            ),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(labelText: 'Email'),
              onChanged: (text){
                _textEditado = true;
                _contatoEditado.email = text;
              },
            ),
            TextField(
              controller: _telefoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(labelText: 'Telefone'),
              onChanged: (text){
                _textEditado = true;
                _contatoEditado.telefone = text;
              },
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.save),
        backgroundColor: Colors.redAccent,
        onPressed: (){
         if(this._contatoEditado.nome != null && this._contatoEditado.nome.isNotEmpty){
           Navigator.pop(context, this._contatoEditado);
         }
         else{
           _exibeDialog();
           FocusScope.of(context).requestFocus(_nomeFocus);
         }


        },
      ),
    );
  }


  void _exibeDialog(){
    showDialog(context: context,
    builder: (BuildContext context){
      return AlertDialog(
       title: Text('Nome'),
        content: Text('Porfavor, preencha o campo nome'),
        actions: <Widget>[
          FlatButton(
            child: Text('Fechar'),
            onPressed: (){
              Navigator.of(context).pop();
            },
          )
        ],
      );
    });
  }
}
