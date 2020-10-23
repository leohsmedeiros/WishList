import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class TabContentForm extends StatefulWidget {
  CameraDescription camera;

  TabContentForm({ @required this.camera });

  @override
  _TabContentFormState createState() => _TabContentFormState();
}

class _TabContentFormState extends State<TabContentForm> {
  String _name, _author, _year;
  String _imagePath;
  File _image;

  bool _status = false;

  List dropDownItems = [
    "Assistido",
    "Não assistido",
  ];

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    print("build tab content");

    return Form(
      key: _formKey,
      child: ListView(
//        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text("Cadastrar Filme",
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          SizedBox(height: 50.0,),

//            Center(
//                child: Image.network("https://www.washingtonpost.com/wp-apps/imrs.php?src=https://arc-anglerfish-washpost-prod-washpost.s3.amazonaws.com/public/HB4AT3D3IMI6TMPTWIZ74WAR54.jpg&w=80"),
//            ),
          Center(child: _buttonToLoadImage(context),),
          SizedBox(height: 10.0,),

          _label("Nome"),
          TextFormField(
            onChanged: (text) => _name = text,
            validator: (value) => (value.isEmpty) ? "Preencha o nome, por favor" : null
          ),
          SizedBox(height: 10.0,),

          _label("Autor"),
          TextFormField(
            onChanged: (text) => _author = text,
            validator: (value) => (value.isEmpty) ? "Preencha o nome do autor, por favor" : null
          ),
          SizedBox(height: 10.0,),

          _label("Ano"),
          TextFormField(
            onChanged: (text) => _year = text,
            validator: (value) => (value.isEmpty) ? "Preencha o ano, por favor" : null
          ),
          SizedBox(height: 10.0,),

          _label("Status"),
//          _dropdown(context),
          _radioButtons(),
          SizedBox(height: 10.0,),

          Container(
            width: double.infinity,
            child: ElevatedButton(
              child: Text("salvar"),
              onPressed: () {
                print("name: $_name");
                print("author: $_author");
                print("year: $_year");
                print("status: $_status");
                print("imagePath: $_imagePath");

                if (_formKey.currentState.validate()) {

                  Scaffold
                      .of(context)
                      .showSnackBar(SnackBar(content: Text('Processing Data')));
                }
              }
            ),
          )
        ],
      ),
    );
  }

  _radioButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Radio(
          value: _status ? 1 : 0,
          groupValue: 0,
          onChanged: (value) {
            print("value radio 0: $value");

            setState(() {
              _status = false;
            });
          },
        ),
        new Text('Não assistido',),
        Radio(
          value: _status ? 0 : 1,
          groupValue: 0,
          onChanged: (value) {
            print("value radio 1: $value");

            setState(() {
              _status = true;
            });
          },
        ),
        new Text('Assistido',),
      ],
    );

  }

  _label(text) {
    return Container(
      width: double.infinity,
//      height: 40,
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(text,
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  _buttonToLoadImage(BuildContext context) => _image == null ?
    RaisedButton(child: Text("Carregar imagem"), onPressed: () => _showPicker(context)):
    Container(height: 150,
      child: FlatButton(
        child: Image.file(_image, fit: BoxFit.fitWidth,),
        onPressed: () => _showPicker(context),
      ),
    );

  _imgFromCamera() async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 50
    );

    setState(() {
      _image = image;
    });
  }

  _imgFromGallery() async {
    File image = await  ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50
    );

    setState(() {
      _image = image;
    });
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        }
    );
  }
}
