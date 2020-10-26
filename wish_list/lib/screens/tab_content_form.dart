import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:wishlist/model/movie.dart';
import 'package:wishlist/database/movie_dao.dart';

class TabContentForm extends StatefulWidget {
  CameraDescription camera;
  Movie movie;

  TabContentForm({ @required this.camera, this.movie});

  @override
  _TabContentFormState createState() => _TabContentFormState();
}

class _TabContentFormState extends State<TabContentForm> {
  TextEditingController _nameTextEditing, _authorTextEditing, _yearTextEditing;
  String _imagePath;

  int _status = 0;

  List dropDownItems = [
    "Assistido",
    "Não assistido",
  ];

  final _formKey = GlobalKey<FormState>();


  _createTextEdition (String value) {
    return new TextEditingController.fromValue(new TextEditingValue(text: value,selection: new TextSelection.collapsed(offset: value.length-1)));
  }

  @override
  void initState() {
    super.initState();

    _nameTextEditing = TextEditingController();
    _authorTextEditing = TextEditingController();
    _yearTextEditing = TextEditingController();

    if (widget.movie != null) {
      _nameTextEditing = _createTextEdition(widget.movie.name);
      _authorTextEditing = _createTextEdition(widget.movie.author);
      _yearTextEditing = _createTextEdition(widget.movie.year.toString());
      _imagePath = widget.movie.photo;
      _status = widget.movie.status;
    }

  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        children: <Widget>[
          Center(child: _buttonToLoadImage(context),),
          SizedBox(height: 10.0,),

          _label("Nome"),
          TextFormField(
            controller: _nameTextEditing,
            validator: (value) => (value.isEmpty) ? "Preencha o nome, por favor" : null
          ),
          SizedBox(height: 10.0,),

          _label("Autor"),
          TextFormField(
            controller: _authorTextEditing,
            validator: (value) => (value.isEmpty) ? "Preencha o nome do autor, por favor" : null
          ),
          SizedBox(height: 10.0,),

          _label("Ano"),
          TextFormField(
            controller: _yearTextEditing,
            keyboardType: TextInputType.number,
            validator: (value) {
              try {
                var n = int.parse(value);
                return (n > DateTime.now().year) ? "Data informada é maior que a data atual" : null;
              } on FormatException {
                return "Data inválida";
              }
            }
          ),
          SizedBox(height: 10.0,),

          _label("Status"),
//          _dropdown(context),
          _radioButtons(),
          SizedBox(height: 10.0,),

          Container(
            width: double.infinity,
            child: ElevatedButton(
              child: Text(widget.movie != null ? "atualizar" : "salvar"),
              onPressed: () => _save(context)
            ),
          )
        ],
      ),
    );
  }

  _save(BuildContext context) async {
    if (_imagePath == null) {
      Scaffold
          .of(context)
          .showSnackBar(SnackBar(content: Text('Imagem inválida, por favor selecione uma foto')));

    } else if (_formKey.currentState.validate()) {
      Movie _movie = Movie(
          name: _nameTextEditing.text,
          photo: _imagePath,
          author: _authorTextEditing.text,
          status: _status,
          year: int.parse(_yearTextEditing.text)
      );

      if (widget.movie != null) {
        _movie.id = widget.movie.id;
      }

      ProgressDialog pr = ProgressDialog(context, isDismissible: false);
      pr.update(message: "Salvando dados");
      await pr.show();

      var movieDao = MovieDAO();

      await movieDao.save(_movie);

      await pr.hide();

      Scaffold
          .of(context)
          .showSnackBar(SnackBar(content: Text('Salvo com sucesso')));

      if (widget.movie != null) {
        Navigator.pop(context);
      } else {
        _nameTextEditing = _createTextEdition("");
        _authorTextEditing = _createTextEdition("");
        _yearTextEditing = _createTextEdition("");
      }
    }
  }

  _radioButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Radio(
          value: _status == 0 ? 0 : 1,
          groupValue: 0,
          onChanged: (value) {
            setState(() {
              _status = 0;
            });

            print("value radio 0: $value");
            print("status: $_status");

          },
        ),
        new Text('Não assistido',),
        Radio(
          value: _status == 1 ? 0 : 1,
          groupValue: 0,
          onChanged: (value) {
            setState(() {
              _status = 1;
            });

            print("value radio 1: $value");
            print("status: $_status");
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

  _loadImage() {
    if (File(_imagePath).existsSync()) {
      return Image.file(File(_imagePath), fit: BoxFit.fitWidth,);
    } else {
      return Image.asset("assets/images/default_image.jpg", fit: BoxFit.fitWidth,);
    }
  }

  _buttonToLoadImage(BuildContext context) => _imagePath == null ?
    Container(height: 150,
        child: RaisedButton(
            child: Text("Carregar imagem"),
            onPressed: () => _showPicker(context)
        )
    ):
    Container(height: 150,
      child: FlatButton(
        child: _loadImage(),
        onPressed: () => _showPicker(context),
      ),
    );

  _imgFromCamera() async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 50
    );

    setState(() {
      _imagePath = image.path;
    });
  }

  _imgFromGallery() async {
    File image = await  ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50
    );

    setState(() {
      _imagePath = image.path;
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
                      title: new Text('Galeria'),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Câmera'),
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
