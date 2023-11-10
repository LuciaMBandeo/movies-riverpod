import 'dart:async';

import 'package:floor/floor.dart';

import '../../../../domain/model/movie_model.dart';

@dao
abstract class MoviesDao {
  @Query("SELECT * FROM MovieEntity WHERE category LIKE '%' || :endpoint || '%'")
  Future<List<MovieModel>> fetchMovies(String endpoint);

  @Query('SELECT * FROM MovieEntity WHERE id = :id')
  Future<MovieModel?> fetchMovieById(int id);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertMovie(MovieModel movie);
}
