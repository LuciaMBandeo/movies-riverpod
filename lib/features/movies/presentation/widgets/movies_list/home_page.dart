import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../utils/enums/pages.dart';
import '../../../../../utils/providers.dart';
import '../../controller/movies_controller.dart';
import '../common_widgets/drawer/home_drawer.dart';
import '../common_widgets/home_page_app_bar.dart';
import 'now_playing_movies_category.dart';
import 'popular_movies_category.dart';
import 'top_rated_movies_category.dart';
import 'upcoming_movies_category.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage>
    with TickerProviderStateMixin {
  late final PageController pageController;
  late final TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(
      length: Pages.values.length,
      vsync: this,
    );
    pageController = PageController();
    ref.read(moviesControllerProvider);
  }

  @override
  void dispose() {
    tabController.dispose();
    pageController.dispose();
    super.dispose();
  }

  Widget getList(Pages pages, MoviesController moviesController) {
    switch (pages) {
      case Pages.popular:
        return PopularMoviesCategory(
          moviesController: moviesController,
        );
      case Pages.topRated:
        return TopRatedMoviesCategory(
          moviesController: moviesController,
        );
      case Pages.nowPlaying:
        return NowPlayingMoviesCategory(
          moviesController: moviesController,
        );
      case Pages.upcoming:
        return UpcomingMoviesCategory(
          moviesController: moviesController,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final moviesController = ref.watch(moviesControllerProvider);

    return Scaffold(
      appBar: HomePageAppBar(
        pageController: pageController,
        tabController: tabController,
      ),
      drawer: const HomeDrawer(),
      body: Container(
        width: MediaQuery.of(context).size.width,
        color: Colors.black,
        child: PageView(
          controller: pageController,
          children: [
            for (Pages pages in Pages.values)
              getList(
                pages,
                moviesController,
              ),
          ],
          onPageChanged: (int index) {
            tabController.animateTo(index);
          },
        ),
      ),
    );
  }
}
