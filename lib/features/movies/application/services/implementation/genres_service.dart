import '../../../data/repository/implementation/database_repository.dart';
import '../../../data/repository/implementation/genres_repository.dart';
import '../../../domain/model/genre_model.dart';
import '../../../presentation/states/data_state.dart';
import '../service_interface.dart';

class GenresService implements IService {
  final GenresRepository genresRepository;
  final DatabaseRepository databaseRepository;

  GenresService({
    required this.genresRepository,
    required this.databaseRepository,
  });

  @override
  Future<DataState<List<GenreModel>>> call({params}) async {
    try {
      final remoteGenres = await genresRepository.fetchGenresList();
      if (remoteGenres is DataSuccess) {
        await Future.forEach(remoteGenres.data!, (GenreModel genre) async {
          databaseRepository.saveGenre(genre);
        });
        return DataSuccess(
          remoteGenres.data!,
        );
      } else {
        final savedGenres = await databaseRepository.getSavedGenres();
        if (savedGenres.data!.isEmpty) {
          return const DataEmpty();
        } else {
          return DataSuccess(savedGenres.data!);
        }
      }
    } catch (e) {
      return DataFailure(
        Exception(e),
      );
    }
  }
}
