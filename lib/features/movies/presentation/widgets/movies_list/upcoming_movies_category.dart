import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../utils/enums/endpoints.dart';
import '../../controller/movies_controller.dart';
import 'grid_widgets/grid_container_movie_preview.dart';
import '../../../../../utils/providers.dart';

class UpcomingMoviesCategory extends ConsumerWidget {
  const UpcomingMoviesCategory({
    super.key,
    required this.moviesController,
  });

  final MoviesController moviesController;

  final Endpoints endpoint = Endpoints.upcoming;
  static const int _gridViewChildren = 2;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final upcomingStream = ref.watch(
      moviesControllerStreamProvider(endpoint),
    );
    return upcomingStream.when(
      loading: () => const CircularProgressIndicator(),
      data: (data) => Scaffold(
        body: SafeArea(
          child: GridView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: _gridViewChildren,
            ),
            itemCount: data.length,
            itemBuilder: (
              BuildContext context,
              int index,
            ) {
              return GridContainerMoviePreview(
                movie: data[index],
              );
            },
          ),
        ),
      ),
      error: (
        error,
        stackTrace,
      ) =>
          Text(
        'Error: $error',
      ),
    );
  }
}
