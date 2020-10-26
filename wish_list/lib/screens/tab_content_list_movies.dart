import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wishlist/database/movie_dao.dart';
import 'package:wishlist/model/movie.dart';

class TabContentListMovies extends StatefulWidget {
  int status;

  TabContentListMovies({ @required this.status });

  @override
  _TabContentListMoviesState createState() => _TabContentListMoviesState();
}

class _TabContentListMoviesState extends State<TabContentListMovies> {
  @override
  Widget build(BuildContext context) {
    var moviesDao = MovieDAO();
    print ("widget.status: ${widget.status}");

    return FutureBuilder(
      future: moviesDao.findAllByStatus(widget.status),
      builder: (BuildContext context, AsyncSnapshot<List<Movie>> snapshot) {
        print ("after snapshot: widget.status: ${widget.status}");

        if (snapshot.hasData && snapshot.data.length > 0) {
          List<Widget> cards = snapshot.data.map((data) {
            return Container(
              height: 100,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Image.file(File(data.photo), fit: BoxFit.fitWidth,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Text(data.name, style: TextStyle(fontWeight: FontWeight.bold),),
                          Text(data.status == 1 ? "Assistido" : "Não Assistido"),
                        ],
                      ),
                      PopupMenuButton(
                          onSelected: (choice) => _choiceAction(choice, data, moviesDao),
                          itemBuilder: (BuildContext context) =>
                          ["edit", "delete"].map((e) => PopupMenuItem<String>(value: e, child: Text(e),)).toList()
                      ),
                    ],
                  ),
                ),
              ),
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

  void _choiceAction(String choice, Movie movie, MovieDAO moviesDAO) {
    if(choice == "delete") {
      moviesDAO
          .delete(movie.id)
          .then((value) => setState(() {}));
    }


//    if(choice == "edit"){
//      print('Choice: $choice');
//    }
//    else if(choice == "delete"){
//      print('Subscribe');
//    }
//    else if(choice == Constants.SignOut){
//      print('SignOut');
//    }
  }
}
