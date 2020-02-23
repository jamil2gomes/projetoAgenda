import 'dart:io';
import 'package:agenda_app/helper/ContactHelper.dart';
import 'package:agenda_app/pages/contato_page.dart';
import 'package:flutter/material.dart';
import 'package:agenda_app/model/Contact.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  ContactHelper contactHelper = ContactHelper();
  List<Contact> contacts = List();

  @override
  void initState() {
    super.initState();
    _getAllContacts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contacts'),
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
          itemCount: contacts.length,
          itemBuilder: (context, index) {
            return _contactCard(context, index);
          }),
    );
  }

  Widget _contactCard(BuildContext context, int index) {
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
                        image: contacts[index].image != null
                            ? FileImage(File(contacts[index].image))
                            : AssetImage('imagem/icons8-nome-64.png'),
                        fit: BoxFit.cover)),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(contacts[index].name ?? '',
                        style: TextStyle(
                            fontSize: 22.0, fontWeight: FontWeight.bold)),
                    Text(contacts[index].email ?? '',
                        style: TextStyle(fontSize: 18.0)),
                    Text(contacts[index].phone ?? '',
                        style: TextStyle(fontSize: 18.0)),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      onTap: () {
        _showOptions(context, index);
      },
    );
  }

  void _showOptions(BuildContext context, int index) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return BottomSheet(
              onClosing: null,
              builder: (context) {
                return Container(
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child: FlatButton(
                            onPressed: null,
                            child: Text(
                              'Ligar',
                              style: TextStyle(
                                  fontSize: 20.0, color: Colors.redAccent),
                            )),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child: FlatButton(
                            onPressed: () {
                              Navigator.pop(context);
                              _showContatoPage(c: contacts[index]);
                            },
                            child: Text(
                              'Edit',
                              style: TextStyle(
                                  fontSize: 20.0, color: Colors.redAccent),
                            )),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child: FlatButton(
                            onPressed: () {
                              Navigator.pop(context);
                              contactHelper.delete(contacts[index].id);
                              setState(() {
                                contacts.removeAt(index);
                                Navigator.pop(context);
                              });
                            },
                            child: Text(
                              'Delete',
                              style: TextStyle(
                                  fontSize: 20.0, color: Colors.redAccent),
                            )),
                      ),
                    ],
                  ),
                );
              });
        });
  }

  void _getAllContacts() {
    contactHelper.getContacts().then((list) {
      setState(() {
        contacts = list;
      });
    });
  }

  void _showContatoPage({Contact c}) async {
    final contactReceived = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ContatoPage(
                  contact: c,
                )));

    if (contactReceived != null) {
      if (c != null) {
        await contactHelper.update(contactReceived);
      } else {
        await contactHelper.insert(contactReceived);
      }

      _getAllContacts();
    }
  }
}
