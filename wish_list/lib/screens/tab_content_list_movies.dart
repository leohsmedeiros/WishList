import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wishlist/database/movie_dao.dart';
import 'package:wishlist/model/movie.dart';
import 'package:wishlist/screens/tab_content_form.dart';

class TabContentListMovies extends StatefulWidget {
  int status;
  CameraDescription camera;
  MovieDAO _movieDAO;

  TabContentListMovies({ @required this.status, @required this.camera }) {
    this._movieDAO = MovieDAO();
  }

  @override
  _TabContentListMoviesState createState() => _TabContentListMoviesState();
}

class _TabContentListMoviesState extends State<TabContentListMovies> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: widget._movieDAO.findAllByStatus(widget.status),
      builder: (BuildContext context2, AsyncSnapshot<List<Movie>> snapshot) {
        if (snapshot.hasData && snapshot.data.length > 0) {
          List<Widget> cards = snapshot.data.map((data) {
            return Container(
              height: 100,
              child: _card(data, context),
            );
          }).toList();

          return Column(
            children: cards,
          );

        } else {
          return Container(
            width: double.infinity,
            child: Text("Nenhum resultado encontrado", textAlign: TextAlign.center,),
          );
        }
      },
    );
  }


  _loadImage(Movie movie) {
    if (File(movie.photo).existsSync()) {
      return Image.file(File(movie.photo), fit: BoxFit.fitWidth,);
    } else {
      return Image.asset("assets/images/default_image.jpg", fit: BoxFit.fitWidth,);
    }
  }


  _card(Movie movie, BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            _loadImage(movie),
            _movieInfo(movie),
            _popupMenu(movie, context),
          ],
        ),
      ),
    );
  }

  _movieInfo(Movie movie) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Text(movie.name, style: TextStyle(fontWeight: FontWeight.bold),),
        Text(movie.status == 1 ? "Assistido" : "Não Assistido"),
      ],
    );
  }

  _popupMenu(Movie movie, BuildContext context) {
    return PopupMenuButton(
        onSelected: (choice) => _choiceAction(choice, movie, context),
        itemBuilder: (BuildContext context) =>
            ["edit", "delete"].map((e) => PopupMenuItem<String>(value: e, child: Text(e),)).toList()
    );
  }

  void _choiceAction(String choice, Movie movie, BuildContext context) {
    if(choice == "delete") {
      widget
          ._movieDAO
          .delete(movie.id)
          .then((value) => setState(() {}));
    } else {
      Navigator.push(context,
          MaterialPageRoute(
              builder: (BuildContext context) =>
                  Scaffold(
                    appBar: AppBar(title: Text("Edição de filme"),),
                    body: TabContentForm(camera: widget.camera, movie: movie,)
                  )
          )
      ).then((value) => setState(() {}));

    }
  }
}
