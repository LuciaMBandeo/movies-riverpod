import 'dart:convert';

import '../../../../../utils/enums/states.dart';
import '../../../presentation/states/data_state.dart';
import '../../datasources/remote/api_service.dart';
import '../../dto/genre_dto.dart';
import '../interfaces/i_genres_repository.dart';

class GenresRepository implements IGenresRepository {
  final ApiService apiService;

  GenresRepository({
    required this.apiService,
  });

  @override
  Future<DataState<List<GenreDto>>> fetchGenresList() async {
    try {
      DataState<dynamic> result = await apiService.fetchGenresList();
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
