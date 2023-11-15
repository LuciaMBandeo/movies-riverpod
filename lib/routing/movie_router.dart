import 'package:flutter/material.dart';

import '../features/movies/presentation/widgets/movie_details/movie_details_page.dart';
import '../features/movies/presentation/widgets/movies_list/home_page.dart';

class NamedRoutes {
  static const String homePage = "/";
  static const String movieDetails = "movie_details";
  static const String aboutTheApp = "about_the_app";
}

class MovieRouter {
  //no agregamos la pagina de about the app aun,queda TODO
  static Map<String, WidgetBuilder> routes() {
    return {
      NamedRoutes.homePage: (BuildContext context) => const HomePage(),
      NamedRoutes.movieDetails: (BuildContext context) =>
          const MovieDetailsPage(),
      //NamedRoutes.aboutTheApp: (BuildContext context) =>
      //   const AboutTheAppPage(),
    };
  }
}
