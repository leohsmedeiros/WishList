import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wishlist/screens/tab_content_form.dart';

class TabPage extends StatefulWidget {
  CameraDescription camera;

  TabPage({ @required this.camera });

  @override
  _TabPageState createState() => _TabPageState();
}

class _TabPageState extends State<TabPage> {
  int _selectedIndex = 0;
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
              FlatButton(
                child: Text("Não assistidos",
                  style: TextStyle(
                    decoration: _selectedIndex == 0 ? TextDecoration.underline : TextDecoration.none,
                    color: _selectedIndex == 0 ? Colors.blue : Colors.black,
                  ),
                ),
                onPressed: () => _onItemTabTapped(0),),
              Container(color: Colors.blueGrey, width: 0.5, height: 30,),
              FlatButton(
                child: Text("Assistidos",
                  style: TextStyle(
                    decoration: _selectedIndex == 1 ? TextDecoration.underline : TextDecoration.none,
                    color: _selectedIndex == 1 ? Colors.blue : Colors.black,
                  ),
                ),
                onPressed: () => _onItemTabTapped(1),),
              Container(color: Colors.blueGrey, width: 0.5, height: 30,),
              FlatButton(
                child: Text("Cadastrar",
                  style: TextStyle(
                    decoration: _selectedIndex == 2 ? TextDecoration.underline : TextDecoration.none,
                    color: _selectedIndex == 2 ? Colors.blue : Colors.black,
                  )
                ),
                onPressed: () => _onItemTabTapped(2),),
              Container(color: Colors.blueGrey, width: 0.5, height: 30,),
            ],
          ),
        ),
      ),
      body: _body(context),
    );
  }

  void _onItemTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.jumpToPage(index);
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
          TabContentForm(camera: widget.camera,),
        ],
      ),
    );
  }
}
