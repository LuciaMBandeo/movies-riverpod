import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import '../features/movies/application/services/implementation/genres_service.dart';
import '../features/movies/application/services/implementation/movies_service.dart';
import '../features/movies/application/services/interface/i_service.dart';
import '../features/movies/data/datasources/local/database_initializer.dart';
import '../features/movies/data/datasources/local/movies_database.dart';
import '../features/movies/data/datasources/remote/api_data_source.dart';
import '../features/movies/data/dto/movie_preview_dto.dart';
import '../features/movies/data/repository/implementation/database_repository_impl.dart';
import '../features/movies/data/repository/implementation/genres_repository_impl.dart';
import '../features/movies/data/repository/implementation/movies_repository_impl.dart';
import '../features/movies/presentation/controller/movies_controller.dart';
import 'enums/endpoints.dart';

final moviesDatabaseProvider = Provider<MoviesDatabase>(
  (ref) => DatabaseInitializer().getDatabaseInstance(),
);

final databaseRepository = Provider<IDatabaseRepository>(
  (ref) => DatabaseRepositoryImpl(
    ref.watch(
      moviesDatabaseProvider,
    ),
  ),
);

final clientProvider = Provider<Client>((ref) => Client());

final apiDataSource = Provider<IApiDataSource>(
  (ref) => ApiDataSourceImpl(
    client: ref.watch(
      clientProvider,
    ),
  ),
);

final moviesRepository = Provider<IMoviesRepository>(
  (ref) => MoviesRepositoryImpl(
    apiDataSource: ref.watch(
      apiDataSource,
    ),
  ),
);

final genresRepository = Provider<IGenresRepository>(
  (ref) => GenresRepositoryImpl(
    apiDataSource: ref.watch(
      apiDataSource,
    ),
  ),
);

final moviesService = Provider<IService>(
  (ref) => MoviesServiceImpl(
    moviesRepository: ref.watch(moviesRepository),
    databaseRepository: ref.watch(
      databaseRepository,
    ),
  ),
);

final genresService = Provider<IService>(
  (ref) => GenresServiceImpl(
    genresRepository: ref.watch(genresRepository),
    databaseRepository: ref.watch(databaseRepository),
  ),
);

final moviesControllerProvider = Provider<MoviesController>(
  (ref) => MoviesController(
    genresService: ref.watch(genresService),
    moviesService: ref.watch(moviesService),
  ),
);

final moviesControllerStreamProvider = StreamProvider.family
    .autoDispose<List<MoviePreviewDto>, Endpoints>((ref, endpoint) {
  final moviesController = ref.watch(moviesControllerProvider);
  moviesController.fetchEndpointsMovies(endpoint);
  switch (endpoint) {
    case Endpoints.popular:
      return moviesController.popularMoviesStream;
    case Endpoints.topRated:
      return moviesController.topRatedMoviesStream;
    case Endpoints.nowPlaying:
      return moviesController.nowPlayingMoviesStream;
    case Endpoints.upcoming:
      return moviesController.upcomingMoviesStream;
  }
});
