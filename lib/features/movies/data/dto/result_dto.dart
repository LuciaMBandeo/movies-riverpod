import 'movie_dto.dart';

class ResultDto {
  final int page;
  final List<MovieDto> results;
  final int totalPages;
  final int totalResults;

  ResultDto({
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });

  factory ResultDto.fromJson(
    Map<String, dynamic> result,
    String category,
  ) {
    List<MovieDto> movieList = (result['results'] as List<dynamic>)
        .map(
          (movie) => MovieDto.fromJson(movie as Map<String, dynamic>, category),
        )
        .toList();
    return ResultDto(
      page: result['page'],
      results: movieList,
      totalPages: result['total_pages'],
      totalResults: result['total_results'],
    );
  }
}
