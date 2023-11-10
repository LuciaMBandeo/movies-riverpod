import 'package:http/http.dart';

import '../features/movies/application/services/implementation/genres_service.dart';
import '../features/movies/application/services/implementation/movies_service.dart';
import '../features/movies/data/datasources/local/movies_database.dart';
import '../features/movies/data/datasources/remote/api_service.dart';
import '../features/movies/data/repository/implementation/database_repository.dart';
import '../features/movies/data/repository/implementation/genres_repository.dart';
import '../features/movies/data/repository/implementation/movies_repository.dart';
import '../features/movies/presentation/controller/movies_controller.dart';


class DependencyHandler {
  late MoviesController _moviesBloc;
  late MoviesRepository _moviesRepository;
  late MoviesService _moviesService;
  late GenresService _genresService;
  late GenresRepository _genresRepository;
  late MoviesDatabase _moviesDatabase;
  late DatabaseRepository _databaseRepository;
  late ApiService _apiService;
  final Client _client = Client();

  static const String _databaseName = 'movies_database.db';

  Future<void> initialize() async {
    _moviesDatabase = await $FloorMoviesDatabase.databaseBuilder(_databaseName).build();
    _apiService = ApiService(client: _client);
    _databaseRepository = DatabaseRepository(_moviesDatabase);
    _moviesRepository = MoviesRepository(apiService: _apiService);
    _genresRepository = GenresRepository(apiService: _apiService);
    _moviesService = MoviesService(
        moviesRepository: _moviesRepository,
        databaseRepository: _databaseRepository,);
    _genresService = GenresService(
        genresRepository: _genresRepository,
        databaseRepository: _databaseRepository,);
    _moviesBloc = MoviesController(
      genresService: _genresService,
      moviesService: _moviesService,
    );
  }

  MoviesDatabase get moviesDatabase => _moviesDatabase;

  ApiService get apiService => _apiService;

  DatabaseRepository get databaseRepository => _databaseRepository;

  MoviesController get moviesBloc => _moviesBloc;

  MoviesService get moviesUseCase => _moviesService;

  GenresService get genresUseCase => _genresService;

  MoviesRepository get moviesRepository => _moviesRepository;

  GenresRepository get genresRepository => _genresRepository;
}
