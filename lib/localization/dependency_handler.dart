import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import '../features/movies/application/services/implementation/genres_service.dart';
import '../features/movies/application/services/implementation/movies_service.dart';
import '../features/movies/application/services/interface/IService.dart';
import '../features/movies/data/datasources/local/movies_database.dart';
import '../features/movies/data/datasources/remote/api_data_source.dart';
import '../features/movies/data/repository/implementation/database_repository_impl.dart';
import '../features/movies/data/repository/implementation/genres_repository_impl.dart';
import '../features/movies/data/repository/implementation/movies_repository_impl.dart';

final client = Provider<Client>((ref) => Client());

const String _databaseName = 'movies_database.db';
final moviesDatabase = FutureProvider<MoviesDatabase>(
  (ref) async =>
      await $FloorMoviesDatabase.databaseBuilder(_databaseName).build(),
);

final apiDataSource = Provider<IApiDataSource>(
  (ref) => ApiDataSourceImpl(
    client: ref.watch(
      client,
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

final databaseRepository = Provider<IDatabaseRepository>(
  (ref) => DatabaseRepositoryImpl(
    ref.watch(moviesDatabase),
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
      databaseRepository: ref.watch(databaseRepository)),
);

final genresService = Provider<IService>(
  ((ref) => GenresServiceImpl(
      genresRepository: ref.watch(genresRepository),
      databaseRepository: ref.watch(databaseRepository))),
);

//BLoC is left
