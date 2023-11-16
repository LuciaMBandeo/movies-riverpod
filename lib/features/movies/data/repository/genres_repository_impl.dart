import 'dart:convert';

import '../../../../../constants/strings.dart';
import '../../../../../utils/enums/states.dart';
import '../../domain/model/genre_model.dart';
import '../../presentation/states/data_state.dart';
import '../datasources/remote/api_data_source.dart';
import '../dto/genre_dto.dart';

abstract class IGenresRepository {
  Future<DataState<List<GenreDto>>> fetchGenresListDto();
  Future<DataState<List<GenreModel>>> fetchGenresList();
}

class GenresRepositoryImpl implements IGenresRepository {
  final IApiDataSource apiDataSource;

  GenresRepositoryImpl({
    required this.apiDataSource,
  });

  @override
  Future<DataState<List<GenreDto>>> fetchGenresListDto() async {
    try {
      DataState<dynamic> result = await apiDataSource.fetchGenresList();
      if (result.state == States.success) {
        return DataSuccess(
          List<GenreDto>.from(
            jsonDecode(result.data)["genres"].map(
              (genre) => GenreDto.fromJson(genre),
            ),
          ),
        );
      } else {
        return DataFailure(
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
  Future<DataState<List<GenreModel>>> fetchGenresList() async {
    try {
      final remoteGenres = await fetchGenresListDto();
      if (remoteGenres is DataSuccess) {
        return DataSuccess(
          remoteGenres.data!,
        );
      } else {
        return DataFailure(Exception(Strings.errorMovieNotFound));
      }
    } catch (e) {
      return DataFailure(
        Exception(e),
      );
    }
  }
}
