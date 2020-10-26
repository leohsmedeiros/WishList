import 'dart:async';

import 'package:sqflite/sqflite.dart';

import 'db_helper.dart';
import '../model/movie.dart';

// Data Access Object
class MovieDAO {

  Future<Database> get db => DatabaseHelper.getInstance().db;

  Future<int> save(Movie movie) async {
    var dbClient = await db;
    var id = await dbClient.insert("movies", movie.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    print('id: $id');
    return id;
  }

  Future<List<Movie>> findAll() async {
    final dbClient = await db;

    final list = await dbClient.rawQuery('select * from movies');

    return list.map<Movie>((json) => Movie.fromJson(json)).toList();
  }

  Future<List<Movie>> findAllByStatus(int status) async {
    final dbClient = await db;

    final list = await dbClient.rawQuery('select * from movies where status = ?',[status]);

    return list.map<Movie>((json) => Movie.fromJson(json)).toList();
  }

  Future<int> delete(int id) async {
    var dbClient = await db;
    return await dbClient.rawDelete('delete from movies where id = ?', [id]);
  }

  Future<int> deleteAll() async {
    var dbClient = await db;
    return await dbClient.rawDelete('delete from movies');
  }
}
