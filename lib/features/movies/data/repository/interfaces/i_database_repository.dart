import '../../../../../utils/enums/endpoints.dart';
import '../../../domain/model/genre_model.dart';
import '../../../domain/model/movie_model.dart';
import '../../../presentation/states/data_state.dart';

abstract class IDatabaseRepository {
  Future<void> saveMovie(MovieModel movie, Endpoints endpoint);

  Future<DataState<List<MovieModel>>> getSavedMovies(Endpoints endpoint);

  Future<MovieModel?> getMovieById(MovieModel movie);

  Future<void> saveGenre(GenreModel genre);

  Future<DataState<List<GenreModel>>> getSavedGenres();

  Future<GenreModel?> getGenreById(GenreModel genre);
}
