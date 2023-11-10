import 'package:flutter/material.dart';

import '../../../../../../routing/movie_router.dart';
import '../../../../data/dto/movie_preview_dto.dart';
import 'grid_row_movie_preview.dart';

class GridContainerMoviePreview extends StatelessWidget {
  const GridContainerMoviePreview({
    super.key,
    required this.movie,
  });

  final MoviePreviewDto movie;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black54,
      width: MediaQuery.of(context).size.width,
      child: Card(
        color: Colors.black26,
        child: GestureDetector(
          onTap: () {
            Navigator.pushNamed(
              context,
              NamedRoutes.movieDetails,
              arguments: movie,
            );
          },
          child: GridRowMoviePreview(
            backdrop: movie.movie.backdropUrl,
            title: movie.movie.title,
          ),
        ),
      ),
    );
  }
}
