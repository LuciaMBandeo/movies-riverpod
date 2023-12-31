import '../../domain/model/movie_model.dart';

class MovieDto extends MovieModel {
  MovieDto({
    required super.adult,
    required super.backdrop,
    required super.genres,
    required super.id,
    required super.originalLanguage,
    required super.originalTitle,
    required super.overview,
    required super.popularity,
    required super.poster,
    required super.releaseDate,
    required super.title,
    required super.video,
    required super.voteAverage,
    required super.voteCount,
    required super.category,
  });

  factory MovieDto.fromJson(Map<String, dynamic> result, String category){
    return MovieDto(
      adult: result['adult'],
      backdrop: result['backdrop_path'],
      genres: List.from(result['genre_ids']),
      id: result['id'],
      originalLanguage: result['original_language'],
      originalTitle: result['original_title'],
      overview: result['overview'],
      popularity: result['popularity'],
      poster: result['poster_path'],
      releaseDate: result['release_date'],
      title: result['title'],
      video: result['video'],
      voteAverage: result['vote_average'],
      voteCount: result['vote_count'],
      category: <String>[category],);
  }
}
