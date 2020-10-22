import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  PageController _pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        color: Colors.green,
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            FlatButton(child: Text("Não listados"), onPressed: () => _pageController.jumpToPage(0),),
            FlatButton(child: Text("Assistidos"), onPressed: () => _pageController.jumpToPage(1),),
            FlatButton(child: Text("Cadastro"), onPressed: () => _pageController.jumpToPage(2),),

          ],
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
          Center(
            child: Container(
              child: Text('Formulário'),
            ),
          ),
        ],
      ),
    );
  }
}
