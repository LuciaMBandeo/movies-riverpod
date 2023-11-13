import '../../../../../utils/enums/endpoints.dart';
import '../../../domain/model/genre_model.dart';
import '../../../domain/model/movie_model.dart';
import '../../../presentation/states/data_state.dart';
import '../../datasources/local/movies_database.dart';

abstract class IDatabaseRepository {
  Future<void> saveMovie(MovieModel movie, Endpoints endpoint);

  Future<DataState<List<MovieModel>>> getSavedMovies(Endpoints endpoint);

  Future<MovieModel?> getMovieById(MovieModel movie);

  Future<void> saveGenre(GenreModel genre);

  Future<DataState<List<GenreModel>>> getSavedGenres();

  Future<GenreModel?> getGenreById(GenreModel genre);
}

class DatabaseRepositoryImpl implements IDatabaseRepository {
  MoviesDatabase? moviesDatabase;

  DatabaseRepositoryImpl(
    this.moviesDatabase,
  );

  @override
  Future<void> saveMovie(
    MovieModel movie,
    Endpoints endpoint,
  ) async {
    MovieModel? existingMovie = await getMovieById(movie);
    if (existingMovie != null) {
      if (!existingMovie.category.contains(endpoint.endpointName)) {
        existingMovie.category.add(endpoint.endpointName);
        await moviesDatabase.moviesDao.insertMovie(existingMovie);
      }
    } else {
      await moviesDatabase.moviesDao.insertMovie(movie);
    }
  }

  @override
  Future<DataState<List<MovieModel>>> getSavedMovies(
    Endpoints endpoint,
  ) async {
    List<MovieModel> savedMovies = [];
    try {
      savedMovies =
          await moviesDatabase.moviesDao.fetchMovies(endpoint.endpointName);
      return DataSuccess(savedMovies);
    } catch (e) {
      return DataFailure(Exception(e));
    }
  }

  @override
  Future<MovieModel?> getMovieById(MovieModel movie) {
    return moviesDatabase.moviesDao.fetchMovieById(movie.id);
  }

  @override
  Future<void> saveGenre(GenreModel genre) async {
    GenreModel? existingGenre = await getGenreById(genre);
    if (existingGenre != null) {
      await moviesDatabase.genresDao.insertGenre(genre);
    }
  }

  @override
  Future<DataState<List<GenreModel>>> getSavedGenres() async {
    List<GenreModel> savedGenres = [];
    try {
      savedGenres = await moviesDatabase.genresDao.fetchGenres();
      return DataSuccess(savedGenres);
    } catch (e) {
      return DataFailure(
        Exception(e),
      );
    }
  }

  @override
  Future<GenreModel?> getGenreById(GenreModel genre) {
    return moviesDatabase.genresDao.fetchGenreById(genre.id);
  }
}
