import '../../../../../utils/enums/endpoints.dart';
import '../../../domain/model/genre_model.dart';
import '../../../domain/model/movie_model.dart';
import '../../../presentation/states/data_state.dart';
import '../../datasources/local/dao/genres_dao.dart';
import '../../datasources/local/dao/movies_dao.dart';
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
  Future<MoviesDatabase> moviesDatabase;

  DatabaseRepositoryImpl(
      this.moviesDatabase,
      );

  @override
  Future<void> saveMovie(
      MovieModel movie,
      Endpoints endpoint,
      ) async {
    MoviesDatabase dbInstance = await moviesDatabase;
    MoviesDao moviesDao = dbInstance.moviesDao;
    MovieModel? existingMovie = await getMovieById(movie);
    if (existingMovie != null) {
      if (!existingMovie.category.contains(endpoint.endpointName)) {
        existingMovie.category.add(endpoint.endpointName);
        await moviesDao.insertMovie(existingMovie);
      }
    } else {
      await moviesDao.insertMovie(movie);
    }
  }

  @override
  Future<DataState<List<MovieModel>>> getSavedMovies(
      Endpoints endpoint,
      ) async {
    MoviesDatabase dbInstance = await moviesDatabase;
    MoviesDao moviesDao = dbInstance.moviesDao;
    List<MovieModel> savedMovies = [];
    try {
      savedMovies =
      await moviesDao.fetchMovies(endpoint.endpointName);
      return DataSuccess(savedMovies);
    } catch (e) {
      return DataFailure(Exception(e));
    }
  }

  @override
  Future<MovieModel?> getMovieById(MovieModel movie) async {
    MoviesDatabase dbInstance = await moviesDatabase;
    MoviesDao moviesDao = dbInstance.moviesDao;
    return moviesDao.fetchMovieById(movie.id);
  }

  @override
  Future<void> saveGenre(GenreModel genre) async {
    MoviesDatabase dbInstance = await moviesDatabase;
    GenresDao genresDao = dbInstance.genresDao;
    GenreModel? existingGenre = await getGenreById(genre);
    if (existingGenre != null) {
      await genresDao.insertGenre(genre);
    }
  }

  @override
  Future<DataState<List<GenreModel>>> getSavedGenres() async {
    List<GenreModel> savedGenres = [];
    MoviesDatabase dbInstance = await moviesDatabase;
    GenresDao genresDao = dbInstance.genresDao;
    try {
      savedGenres = await genresDao.fetchGenres();
      return DataSuccess(savedGenres);
    } catch (e) {
      return DataFailure(
        Exception(e),
      );
    }
  }

  @override
  Future<GenreModel?> getGenreById(GenreModel genre) async {
    MoviesDatabase dbInstance = await moviesDatabase;
    GenresDao genresDao = dbInstance.genresDao;
    return genresDao.fetchGenreById(genre.id);
  }
}

