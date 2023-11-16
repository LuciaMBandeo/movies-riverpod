import '../../../../../constants/strings.dart';
import '../../../../../utils/enums/endpoints.dart';
import '../../../../../utils/enums/states.dart';
import '../../domain/model/movie_model.dart';
import '../../presentation/states/data_state.dart';
import '../datasources/remote/api_data_source.dart';
import '../dto/result_dto.dart';

abstract class IMoviesRepository {
  Future<DataState<ResultDto>> fetchMoviesResult(Endpoints chosenEndpoint);
  Future<DataState<List<MovieModel>>> fetchMoviesList(Endpoints chosenEndpoint);
}

class MoviesRepositoryImpl extends IMoviesRepository {
  final IApiDataSource apiDataSource;

  MoviesRepositoryImpl({
    required this.apiDataSource,
  });

  @override //fetch movies result?
  Future<DataState<ResultDto>> fetchMoviesResult(
    Endpoints chosenEndpoint,
  ) async {
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

  @override
  Future<DataState<List<MovieModel>>> fetchMoviesList(
    Endpoints chosenEndpoint,
  ) async {
    try {
      final remoteMovies = await fetchMoviesResult(chosenEndpoint);
      if (remoteMovies is DataSuccess) {
        return DataSuccess(
          remoteMovies.data!.results,
        );
      } else {
        return DataFailure(
          Exception(
            Strings.errorMovieNotFound,
          ),
        );
      }
    } catch (e) {
      return DataFailure(
        Exception(e),
      );
    }
  }
}
