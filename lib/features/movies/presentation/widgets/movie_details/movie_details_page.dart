import 'package:flutter/material.dart';
import 'row_like_movie.dart';
import 'sized_box_intro_info.dart';
import 'text_subtitle.dart';

import '../../../../../constants/dimens.dart';
import '../../../../../constants/strings.dart';
import '../../../data/dto/movie_preview_dto.dart';
import '../common_widgets/scrollable_genres.dart';
import '../common_widgets/text_info.dart';

class MovieDetailsPage extends StatefulWidget {
  const MovieDetailsPage({
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _MovieDetailsPageState();
}

class _MovieDetailsPageState extends State<MovieDetailsPage> {
  static const _paddingAllExtraInfo = 15.0;
  static const _paddingBottomOverview = 20.0;

  @override
  Widget build(BuildContext context) {
    final MoviePreviewDto movie =
        ModalRoute.of(context)!.settings.arguments as MoviePreviewDto;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_rounded,
          ),
          onPressed: () {
            Navigator.pop(
              context,
            );
          },
        ),
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: const Color(
        Dimens.backgroundColor,
      ),
      body: SafeArea(
        child: ListView(
          children: [
            SizedBoxIntroInfo(
              movie.movie.backdropUrl,
              movie.movie.posterUrl,
              movie.movie.title,
              movie.movie.releaseDate,
              movie.movie.voteAverage,
            ),
            ScrollableGenres(
              genres: movie.genres,
            ),
            Padding(
              padding: const EdgeInsets.all(
                _paddingAllExtraInfo,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const TextSubtitle(
                    Strings.overview,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      bottom: _paddingBottomOverview,
                    ),
                    child: TextInfo(
                      movie.movie.overview,
                    ),
                  ),
                  const TextSubtitle(
                    Strings.originalTitle,
                  ),
                  TextInfo(movie.movie.originalTitle),
                  const RowLikeMovie(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
