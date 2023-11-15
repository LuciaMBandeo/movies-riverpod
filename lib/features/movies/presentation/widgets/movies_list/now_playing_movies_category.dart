import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../utils/enums/endpoints.dart';
import '../../../../../utils/providers.dart';
import '../../controller/movies_controller.dart';
import 'list_widgets/list_container_movie_preview.dart';

class NowPlayingMoviesCategory extends ConsumerWidget {
  const NowPlayingMoviesCategory({
    super.key,
    required this.moviesController,
  });

  final MoviesController moviesController;
  final Endpoints endpoint = Endpoints.nowPlaying;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nowPlayingStream = ref.watch(
      moviesControllerStreamProvider(endpoint),
    );
    return nowPlayingStream.when(
      loading: () => const CircularProgressIndicator(),
      data: (data) => Scaffold(
        body: SafeArea(
          child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: data.length,
            itemBuilder: (
              BuildContext context,
              int index,
            ) {
              return ListContainerMoviePreview(
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
