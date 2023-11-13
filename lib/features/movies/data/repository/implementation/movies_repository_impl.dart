import '../../../../../utils/enums/endpoints.dart';
import '../../../../../utils/enums/states.dart';
import '../../../presentation/states/data_state.dart';
import '../../datasources/remote/api_data_source.dart';
import '../../dto/result_dto.dart';

abstract class IMoviesRepository {
  Future<DataState<ResultDto>> fetchMovies(Endpoints chosenEndpoint);
}

class MoviesRepositoryImpl extends IMoviesRepository {
  final IApiDataSource apiDataSource;

  MoviesRepositoryImpl({
    required this.apiDataSource,
  });

  @override
  Future<DataState<ResultDto>> fetchMovies(Endpoints chosenEndpoint) async {
    try {
      DataState<dynamic> result = await apiDataSource.fetchMovieList(
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
