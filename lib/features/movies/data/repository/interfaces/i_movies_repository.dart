import '../../../../../utils/enums/endpoints.dart';
import '../../../presentation/states/data_state.dart';
import '../../dto/result_dto.dart';

abstract class IMoviesRepository {
  Future<DataState<ResultDto>> fetchMovies(Endpoints chosenEndpoint);
}
