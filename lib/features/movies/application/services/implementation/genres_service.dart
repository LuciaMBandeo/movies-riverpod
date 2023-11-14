import '../interface/i_service.dart';

import '../../../data/repository/implementation/database_repository_impl.dart';
import '../../../data/repository/implementation/genres_repository_impl.dart';
import '../../../domain/model/genre_model.dart';
import '../../../presentation/states/data_state.dart';

class GenresServiceImpl implements IService {
  final IGenresRepository genresRepository;
  final IDatabaseRepository databaseRepository;

  GenresServiceImpl({
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
