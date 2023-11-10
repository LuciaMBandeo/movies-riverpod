import 'package:floor/floor.dart';

import '../../../../domain/model/genre_model.dart';

@dao
abstract class GenresDao {
  @Query('SELECT * FROM GenreEntity')
  Future<List<GenreModel>> fetchGenres();

  @Query('SELECT * FROM GenreEntity WHERE id = :id')
  Future<GenreModel?> fetchGenreById(int id);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertGenre(GenreModel movie);
}
