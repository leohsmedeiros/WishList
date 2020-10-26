import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wishlist/database/movie_dao.dart';
import 'package:wishlist/model/movie.dart';

class TabContentListMovies extends StatefulWidget {
  int status;
  MovieDAO _movieDAO;

  TabContentListMovies({ @required this.status }) {
    this._movieDAO = MovieDAO();
  }

  @override
  _TabContentListMoviesState createState() => _TabContentListMoviesState();
}

class _TabContentListMoviesState extends State<TabContentListMovies> {
  @override
  Widget build(BuildContext context) {
    print ("widget.status: ${widget.status}");

    return FutureBuilder(
      future: widget._movieDAO.findAllByStatus(widget.status),
      builder: (BuildContext context, AsyncSnapshot<List<Movie>> snapshot) {
        print ("after snapshot: widget.status: ${widget.status}");

        if (snapshot.hasData && snapshot.data.length > 0) {
          List<Widget> cards = snapshot.data.map((data) {
            return Container(
              height: 100,
              child: _card(data),
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

  _card(Movie movie) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Image.file(File(movie.photo), fit: BoxFit.fitWidth,),
            _movieInfo(movie),
            _popupMenu(movie),
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

  _popupMenu(Movie movie) {
    return PopupMenuButton(
        onSelected: (choice) => _choiceAction(choice, movie),
        itemBuilder: (BuildContext context) =>
            ["edit", "delete"].map((e) => PopupMenuItem<String>(value: e, child: Text(e),)).toList()
    );
  }

  void _choiceAction(String choice, Movie movie) {
    if(choice == "delete") {
      widget
          ._movieDAO
          .delete(movie.id)
          .then((value) => setState(() {}));
    } else {

    }
  }
}
