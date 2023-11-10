import '../../../data/repository/implementation/database_repository.dart';
import '../../../data/repository/implementation/movies_repository.dart';
import '../../../domain/model/movie_model.dart';
import '../../../presentation/states/data_state.dart';
import '../service_interface.dart';

class MoviesService implements IService {
  final MoviesRepository moviesRepository;
  final DatabaseRepository databaseRepository;

  MoviesService({
    required this.moviesRepository,
    required this.databaseRepository,
  });

  @override
  Future<DataState<List<MovieModel>>> call({params}) async {
    try {
      final remoteMovies = await moviesRepository.fetchMovies(params);
      if (remoteMovies is DataSuccess) {
        await Future.forEach(remoteMovies.data!.results,
            (MovieModel movie) async {
          databaseRepository.saveMovie(movie, params);
        });
        return DataSuccess(remoteMovies.data!.results);
      } else {
        final savedMovies = await databaseRepository.getSavedMovies(params);
        if (savedMovies.data!.isEmpty) {
          return const DataEmpty();
        } else {
          return DataSuccess(savedMovies.data!);
        }
      }
    } catch (e) {
      return DataFailure(
        Exception(e),
      );
    }
  }
}
