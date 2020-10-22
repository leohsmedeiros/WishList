import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wishlist/screens/tab_content_form.dart';

class TabPage extends StatelessWidget {
  PageController _pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Wish List"),
        backgroundColor: Colors.blue,
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 10,
        child: Container(
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              FlatButton(child: Text("Não listados"), onPressed: () => _pageController.jumpToPage(0),),
              Container(color: Colors.blueGrey, width: 0.5, height: 30,),
              FlatButton(child: Text("Assistidos"), onPressed: () => _pageController.jumpToPage(1),),
              Container(color: Colors.blueGrey, width: 0.5, height: 30,),
              FlatButton(child: Text("Cadastro"), onPressed: () => _pageController.jumpToPage(2),),
            ],
          ),
        ),
      ),
      body: PageView(
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
          TabContentForm(),
        ],
      ),
    );
  }

}
