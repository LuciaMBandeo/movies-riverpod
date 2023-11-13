import '../../domain/model/genre_model.dart';

class GenreDto extends GenreModel {
  GenreDto({
    required super.id,
    required super.name,
  });

  factory GenreDto.fromJson(Map<String, dynamic> result) {
    return GenreDto(
      id: result['id'],
      name: result['name'],
    );
  }
}
