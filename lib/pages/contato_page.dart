import 'dart:io';
import 'package:flutter/material.dart';
import 'package:agenda_app/model/Contact.dart';
import 'package:image_picker/image_picker.dart';

class ContatoPage extends StatefulWidget {
  final Contact contact;

  ContatoPage({this.contact});

  @override
  _ContatoPageState createState() => _ContatoPageState();
}

class _ContatoPageState extends State<ContatoPage> {
  Contact _editedContact;
  bool _editedText = false;
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _nomeFocus = FocusNode();

  @override
  void initState() {
    super.initState();

    if (widget.contact == null) {
      this._editedContact = Contact();
    } else {
      this._editedContact = Contact.fromMap(widget.contact.toMap());
      _nameController.text = this._editedContact.name;
      _emailController.text = this._editedContact.email;
      _phoneController.text = this._editedContact.phone;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return _showPopUp(context);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(_editedContact.name ?? 'New Contact'),
          backgroundColor: Colors.redAccent,
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              GestureDetector(
                child: Container(
                    width: 140.0,
                    height: 140.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: _editedContact.image != null //caso o usuario não tenha imagem ele utiliza imagem padrao
                              ? FileImage(File(_editedContact.image))
                              : AssetImage('imagem/user.png'),
                          fit: BoxFit.cover),
                    )),
                onTap: () {
                  ImagePicker.pickImage(source: ImageSource.gallery) //busca imagem na galeria
                      .then((file) {
                    if (file == null)
                      return;
                    else
                      setState(() {
                        _editedContact.image = file.path;
                      });
                  });
                },
              ),
              TextField(
                controller: _nameController,
                focusNode: _nomeFocus,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(labelText: 'Name'),
                onChanged: (text) {
                  _editedText = true;
                  setState(() {
                    _editedContact.name = text;
                  });
                },
              ),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(labelText: 'Email'),
                onChanged: (text) {
                  _editedText = true;
                  _editedContact.email = text;
                },
              ),
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(labelText: 'Phone'),
                onChanged: (text) {
                  _editedText = true;
                  _editedContact.phone = text;
                },
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.save),
          backgroundColor: Colors.redAccent,
          onPressed: () {
            if (this._editedContact.name != null &&
                this._editedContact.name.isNotEmpty) {
              Navigator.pop(context, this._editedContact);
            } else {
              _showDialog(context);
              FocusScope.of(context).requestFocus(_nomeFocus);
            }
          },
        ),
      ),
    );
  }

  Future<bool> _showPopUp(BuildContext context) {
    if (_editedText) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
                title: Text('Dicard Changes?'),
                content: Text('The changes will be discarded'),
                actions: <Widget>[
                  FlatButton(
                    child: Text('Cancel'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  FlatButton(
                      child: Text('Accept'),
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      })
                ]);
          });
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }

  void _showDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Name'),
            content: Text('Fill the name field'),
            actions: <Widget>[
              FlatButton(
                child: Text('Close'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }
}
