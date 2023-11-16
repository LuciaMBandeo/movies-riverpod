import 'dart:async';

import '../../../../utils/enums/endpoints.dart';
import '../../data/dto/movie_preview_dto.dart';
import '../../data/repository/implementation/genres_repository_impl.dart';
import '../../data/repository/implementation/movies_repository_impl.dart';
import '../../domain/model/genre_model.dart';
import '../../domain/model/movie_model.dart';
import '../states/data_state.dart';

class MoviesController {
  MoviesController({
    required this.genresRepository,
    required this.moviesRepository,
  });

  final IGenresRepository genresRepository;
  final IMoviesRepository moviesRepository;
  final _popularMovies = StreamController<List<MoviePreviewDto>>.broadcast();
  final _topRatedMovies = StreamController<List<MoviePreviewDto>>.broadcast();
  final _nowPlayingMovies = StreamController<List<MoviePreviewDto>>.broadcast();
  final _upcomingMovies = StreamController<List<MoviePreviewDto>>.broadcast();

  Stream<List<MoviePreviewDto>> get popularMoviesStream =>
      _popularMovies.stream;

  Stream<List<MoviePreviewDto>> get topRatedMoviesStream =>
      _topRatedMovies.stream;

  Stream<List<MoviePreviewDto>> get nowPlayingMoviesStream =>
      _nowPlayingMovies.stream;

  Stream<List<MoviePreviewDto>> get upcomingMoviesStream =>
      _upcomingMovies.stream;

  ///Returns the genres corresponding to the list of genresId, or an empty list in case of error
  Future<List<GenreModel>> _fetchMoviesGenres(List<int> genresId) async {
    final result = await genresRepository.fetchGenresList();
    if (result is DataSuccess) {
      return result.data!;
    } else {
      return [];
    }
  }

  void addStateStream(
    Endpoints endpoint,
    List<MoviePreviewDto> result,
  ) {
    switch (endpoint) {
      case Endpoints.popular:
        _popularMovies.sink.add(
          result,
        );
        break;
      case Endpoints.topRated:
        _topRatedMovies.sink.add(
          result,
        );
        break;
      case Endpoints.nowPlaying:
        _nowPlayingMovies.sink.add(
          result,
        );
        break;
      case Endpoints.upcoming:
        _upcomingMovies.sink.add(
          result,
        );
        break;
    }
  }

  Future<void> fetchEndpointsMovies(Endpoints endpoint) async {
    List<MovieModel> movieListEndpoint = [];
    try {
      final result = await moviesRepository.fetchMoviesList(endpoint);
      if (result is DataSuccess) {
        movieListEndpoint = result.data!;
        List<GenreModel> genres = await _fetchMoviesGenres(
          movieListEndpoint
              .map(
                (movie) => movie.genres,
              )
              .expand(
                (element) => element,
              )
              .toList(),
        );
        List<MoviePreviewDto> moviePreview = movieListEndpoint.map((movie) {
          final movieGenres = genres
              .where(
                (genre) => movie.genres.contains(genre.id),
              )
              .toList();
          return MoviePreviewDto(
            movie,
            movieGenres,
          );
        }).toList();
        addStateStream(
          endpoint,
          moviePreview,
        );
      }
    } catch (e) {
      return addStateStream(
        endpoint,
        [],
      );
    }
  }
}
