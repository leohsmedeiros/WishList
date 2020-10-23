import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wishlist/screens/tab_content_form.dart';

class TabPage extends StatelessWidget {
  CameraDescription camera;

  TabPage({ @required this.camera });

  PageController _pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              FlatButton(child: Text("Não assistidos"), onPressed: () => _pageController.jumpToPage(0),),
              Container(color: Colors.blueGrey, width: 0.5, height: 30,),
              FlatButton(child: Text("Assistidos"), onPressed: () => _pageController.jumpToPage(1),),
              Container(color: Colors.blueGrey, width: 0.5, height: 30,),
              FlatButton(child: Text("Cadastrar"), onPressed: () => _pageController.jumpToPage(2),),
              Container(color: Colors.blueGrey, width: 0.5, height: 30,),
            ],
          ),
        ),
      ),
      body: _body(context),
    );
  }

  _body(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: PageView(
        controller: _pageController,
        children: <Widget>[
          Center(
            child: Container(
              child: Text('Não Listados'),
            ),
          ),
          Center(
            child: Container(
              child: Text('Listados'),
            ),
          ),
          TabContentForm(camera: camera,),
        ],
      ),
    );
  }
}
