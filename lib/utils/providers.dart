import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import '../features/movies/data/datasources/remote/api_data_source.dart';
import '../features/movies/data/dto/movie_preview_dto.dart';
import '../features/movies/data/repository/genres_repository_impl.dart';
import '../features/movies/data/repository/movies_repository_impl.dart';
import '../features/movies/presentation/controller/movies_controller.dart';
import 'enums/endpoints.dart';

final clientProvider = Provider<Client>((ref) => Client());

final apiDataSource = Provider<IApiDataSource>(
  (ref) => ApiDataSourceImpl(
    client: ref.read(
      clientProvider,
    ),
  ),
);

final moviesRepository = Provider<IMoviesRepository>(
  (ref) => MoviesRepositoryImpl(
    apiDataSource: ref.read(
      apiDataSource,
    ),
  ),
);

final genresRepository = Provider<IGenresRepository>(
  (ref) => GenresRepositoryImpl(
    apiDataSource: ref.read(
      apiDataSource,
    ),
  ),
);

final moviesControllerProvider = Provider<MoviesController>(
  (ref) => MoviesController(
    genresRepository: ref.read(genresRepository),
    moviesRepository: ref.read(moviesRepository),
  ),
);

final moviesControllerStreamProvider =
    StreamProvider.family.autoDispose<List<MoviePreviewDto>, Endpoints>(
  (ref, endpoint) {
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
  },
);
