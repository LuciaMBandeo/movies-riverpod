import '../../domain/model/genre_model.dart';
import '../../domain/model/movie_model.dart';

class MoviePreviewDto {
  final MovieModel movie;
  final List<GenreModel> genres;

  MoviePreviewDto(
    this.movie,
    this.genres,
  );
}
