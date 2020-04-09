import 'dart:io';
import 'dart:math';
import 'package:agenda/helpers/contact_helper.dart';
import "package:flutter/material.dart";
import 'package:image_picker/image_picker.dart';

class ContactPage extends StatefulWidget {

   final Contact contact;
   ContactPage({this.contact}); // entre chaves deixa o parametro opcional 

  @override 
  _ContactPageState createState() => _ContactPageState(); 
}

class _ContactPageState extends State<ContactPage> {

  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  final _focusname = FocusNode();

  bool _userEdited = false;
  Contact _edited;

  void _limparCampos() {
    setState(() {
    _nomeController.clear();
    _emailController.clear();
    _phoneController.clear();
    _edited.name = null;
    });
  }

  var idNumer = new Random();


  @override 
  void initState() {
    super.initState();
    if(widget.contact == null ) {
      _edited = Contact();
    }
    else {
      _edited = Contact.fromMap(widget.contact.toMap());
      _nomeController.text = _edited.name;
      _emailController.text = _edited.email;
      _phoneController.text = _edited.phone;
    }
  }


  @override 
  Widget build(BuildContext context) {
    return WillPopScope( onWillPop: _requestPop,
      child: Scaffold(
      appBar: AppBar(title: Text(_edited.name ?? "Novo Contato"), backgroundColor: Colors.red, centerTitle: true,
       actions: <Widget>[
      IconButton(icon: Icon(Icons.refresh,color: Colors.white,), onPressed: () {_limparCampos();},)
    ],
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {
        if(_edited.name != null && _edited.name.isNotEmpty  ){
          if(_edited.id == null){
            _edited.id = idNumer.nextInt(100);
          }
          Navigator.pop(context, _edited); // volta para a anterior
        } else {
          FocusScope.of(context).requestFocus(_focusname); // chama o focus 
        }
      }, 
      child: Icon(Icons.save,),backgroundColor: Colors.red, 
      ),
      body:
      SingleChildScrollView(
        padding: EdgeInsets.all(10),
        child:Column(
          children: <Widget>[
            GestureDetector(
              child: Container(width: 140, height: 140, decoration: BoxDecoration(shape: BoxShape.circle,
              image: DecorationImage(image: _edited.img != null ? FileImage(File(_edited.img)) : AssetImage("Images/person.png"),fit: BoxFit.cover
              )
              ),),
              onTap: () {
                ImagePicker.pickImage(source: ImageSource.camera).then((file) {
                  if(file == null ) return;
                  setState(() {
                    _edited.img = file.path;
                  });
                });
              },
            ),
            TextField(
              decoration:InputDecoration(labelText: "Nome"),onChanged:(text) {
                _userEdited = true;
                setState(() {
                  _edited.name = text;
                });
              } ,
              controller: _nomeController,
              focusNode: _focusname,
            ),
            TextField(
              decoration:InputDecoration(labelText: "E-mail"),onChanged:(text) {
                _userEdited = true;
                  _edited.email = text;
              },
              keyboardType: TextInputType.emailAddress ,
              controller: _emailController,
            ),
            TextField(
              decoration:InputDecoration(labelText: "Telefone"),onChanged:(text) {
                _userEdited = true;
                  _edited.phone = text;
              } ,
              keyboardType: TextInputType.phone ,
              controller: _phoneController,

            )
          ]
        ),
      ),

    ), );
  }

  Future<bool> _requestPop(){
    if(_userEdited ){
      showDialog(context: context, 
      builder: (context){
        return AlertDialog(
          title: Text("Descartar Alterações ?"),
          content: Text("Se sair as alterações serão perdidas"),
          actions: <Widget>[
            FlatButton(child: Text("Cancelar"), onPressed: () {
              Navigator.pop(context);
            },
            ),
            FlatButton(child: Text("Confirmar"), onPressed: () {
            Navigator.pop(context);
            Navigator.pop(context);
            } ,
            )
          ],
        );
      });
      return Future.value(false);
    } 
    else {
      Future.value(true);
    }
  }
}