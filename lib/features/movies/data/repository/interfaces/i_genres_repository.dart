import '../../../presentation/states/data_state.dart';
import '../../dto/genre_dto.dart';

abstract class IGenresRepository {
  Future<DataState<List<GenreDto>>> fetchGenresList();
}
