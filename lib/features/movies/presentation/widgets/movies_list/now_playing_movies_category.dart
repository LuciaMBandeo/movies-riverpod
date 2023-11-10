import 'package:flutter/material.dart';

import '../../../../../constants/strings.dart';
import '../../../../../utils/enums/endpoints.dart';
import '../../controller/movies_controller.dart';
import '../../states/data_state.dart';
import 'list_widgets/list_container_movie_preview.dart';


class NowPlayingMoviesCategory extends StatefulWidget {
  const NowPlayingMoviesCategory({
    super.key,
    required this.moviesBloc,
  });

  final MoviesController moviesBloc;

  @override
  State<StatefulWidget> createState() => _NowPLayingMoviesState();
}

class _NowPLayingMoviesState extends State<NowPlayingMoviesCategory> {
  final Endpoints endpoint = Endpoints.nowPlaying;

  @override
  void initState() {
    super.initState();
    widget.moviesBloc.fetchEndpointsMovies(
      endpoint,
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () {
            return widget.moviesBloc.fetchEndpointsMovies(
              endpoint,
            );
          },
          child: StreamBuilder(
            stream: widget.moviesBloc.nowPlayingMoviesStream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data is DataFailure) {
                  return Text(
                    snapshot.data!.error.toString(),
                  );
                } else if (snapshot.data is DataSuccess) {
                  final movieList = snapshot.data?.data ?? [];
                  return ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: movieList.length,
                    itemBuilder: (
                      BuildContext context,
                      int index,
                    ) {
                      return ListContainerMoviePreview(
                        movie: movieList[index],
                      );
                    },
                  );
                } else if (snapshot.data is DataEmpty) {
                  return Column(
                    children: [
                      Image.asset(
                        Strings.noMoviesFoundImagePath,
                      ),
                      const Text(Strings.errorMovieNotFound),
                    ],
                  );
                }
              }
              return const CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}
