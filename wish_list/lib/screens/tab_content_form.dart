import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TabContentForm extends StatelessWidget {
  String _name, _author, _year, _status;

  List dropDownItems = [
    "Assistido",
    "Não assistido",
  ];


  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text("Cadastrar Filme"),

            SizedBox(height: 20.0,),
            _label("Nome"),
            TextField(onChanged: (text) => _name = text,),

            SizedBox(height: 20.0,),
            _label("Autor"),
            TextField(onChanged: (text) => _author = text,),

            SizedBox(height: 20.0,),
            _label("Ano"),
            TextField(onChanged: (text) => _year = text,),

            SizedBox(height: 20.0,),
            _label("Status"),
            _dropdown(context),
          ],
        ),
      ),
    );
  }

  _dropdown(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(12.0),
      child: DropdownButtonHideUnderline(
        child: DropdownButton(
          hint: Text(
            "${_status == null ? 'Selecione o status' : _status}",
          ),
          isExpanded: true,
          iconSize: 25.0,
          iconEnabledColor: Colors.black,
          items: dropDownItems.map(
                (val) {
              return DropdownMenuItem<String>(
                value: val,
                child: Text(val),
              );
            },
          ).toList(),
          onChanged: (val) {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
        ),
      ),
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
}
