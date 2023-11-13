import 'dart:async';

import '../../../../constants/strings.dart';
import '../../../../utils/enums/endpoints.dart';
import '../../application/services/implementation/genres_service.dart';
import '../../application/services/implementation/movies_service.dart';
import '../../data/dto/movie_preview_dto.dart';
import '../../domain/model/genre_model.dart';
import '../../domain/model/movie_model.dart';
import '../states/data_state.dart';
import 'i_controller.dart';

class MoviesController implements IController {
  MoviesController({
    required this.genresService,
    required this.moviesService,
  });

  final GenresServiceImpl genresService;
  final MoviesServiceImpl moviesService;
  final _popularMovies =
      StreamController<DataState<List<MoviePreviewDto>>>.broadcast();
  final _topRatedMovies =
      StreamController<DataState<List<MoviePreviewDto>>>.broadcast();
  final _nowPlayingMovies =
      StreamController<DataState<List<MoviePreviewDto>>>.broadcast();
  final _upcomingMovies =
      StreamController<DataState<List<MoviePreviewDto>>>.broadcast();

  Stream<DataState<List<MoviePreviewDto>>> get popularMoviesStream =>
      _popularMovies.stream;

  Stream<DataState<List<MoviePreviewDto>>> get topRatedMoviesStream =>
      _topRatedMovies.stream;

  Stream<DataState<List<MoviePreviewDto>>> get nowPlayingMoviesStream =>
      _nowPlayingMovies.stream;

  Stream<DataState<List<MoviePreviewDto>>> get upcomingMoviesStream =>
      _upcomingMovies.stream;

  @override
  void initialize() async {
    fetchEndpointsMovies(
      Endpoints.popular,
    );
  }

  ///Returns the genres corresponding to the list of genresId, or an empty list in case of error
  Future<List<GenreModel>> _fetchMoviesGenres(List<int> genresId) async {
    final result = await genresService.call(
      params: genresId,
    );
    if (result is DataSuccess) {
      return result.data!;
    } else {
      return [];
    }
  }

  void addStateStream(
    Endpoints endpoint,
    DataState<List<MoviePreviewDto>> result,
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
    addStateStream(endpoint, const DataLoading());
    try {
      final result = await moviesService.call(
        params: endpoint,
      );
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
          DataSuccess(moviePreview),
        );
      } else {
        addStateStream(
          endpoint,
          const DataEmpty(),
        );
      }
    } catch (e) {
      return addStateStream(
        endpoint,
        DataFailure(
          Exception(
            Strings.errorMovieNotFound,
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _popularMovies.close();
    _topRatedMovies.close();
    _nowPlayingMovies.close();
    _upcomingMovies.close();
  }
}
