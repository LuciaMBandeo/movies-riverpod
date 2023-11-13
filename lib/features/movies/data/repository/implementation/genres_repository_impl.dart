import 'dart:convert';

import '../../../../../utils/enums/states.dart';
import '../../../presentation/states/data_state.dart';
import '../../datasources/remote/api_data_source.dart';
import '../../dto/genre_dto.dart';

abstract class IGenresRepository {
  Future<DataState<List<GenreDto>>> fetchGenresList();
}

class GenresRepositoryImpl implements IGenresRepository {
  final IApiDataSource apiDataSource;

  GenresRepositoryImpl({
    required this.apiDataSource,
  });

  @override
  Future<DataState<List<GenreDto>>> fetchGenresList() async {
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
}
