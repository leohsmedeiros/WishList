import 'dart:core';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wishlist/screens/tab_content_form.dart';

class TabPage extends StatefulWidget {
  CameraDescription camera;

  TabPage({@required this.camera});

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
        title: Text(_getItemTabTitleByIndex(_selectedIndex),),
        backgroundColor: Colors.white,
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _tabTitleItem(0),
              _tabTitleItem(1),
              _tabTitleItem(2),
            ],
          ),
        ),
      ),
      body: _body(context),
    );
  }

  _getItemTabTitleByIndex(int index) {
    if (index == 0) {
      return "Não assistidos";
    } else if (index == 1) {
      return "Assistidos";
    } else {
      return "Cadastrar";
    }
  }

  _tabTitleItem(int index) {
    return FlatButton(
      child: Text(
        _getItemTabTitleByIndex(index),
        style: TextStyle(
          decoration: _selectedIndex == index
              ? TextDecoration.underline
              : TextDecoration.none,
          color: _selectedIndex == index ? Colors.blue : Colors.black,
        ),
      ),
      onPressed: () => _onItemTabTapped(index),
    );
  }

  _onItemTabTapped(int index) {
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
          TabContentForm(
            camera: widget.camera,
          ),
        ],
      ),
    );
  }
}
