import '../../../../../utils/enums/endpoints.dart';
import '../../../../../utils/enums/states.dart';
import '../../../presentation/states/data_state.dart';
import '../../datasources/remote/api_service.dart';
import '../../dto/result_dto.dart';
import '../interfaces/i_movies_repository.dart';

class MoviesRepository extends IMoviesRepository {
  final ApiService apiService;

  MoviesRepository({
    required this.apiService,
  });

  @override
  Future<DataState<ResultDto>> fetchMovies(Endpoints chosenEndpoint) async {
    try {
      DataState<dynamic> result = await apiService.fetchMovieList(
        chosenEndpoint,
      );
      if (result.state == States.success) {
        return DataSuccess<ResultDto>(
          ResultDto.fromJson(
            result.data,
            chosenEndpoint.endpointName,
          ),
        );
      } else {
        return DataFailure<ResultDto>(
          result.error!,
        );
      }
    } catch (e) {
      return DataFailure(
        Exception(e),
      );
    }
  }
}
