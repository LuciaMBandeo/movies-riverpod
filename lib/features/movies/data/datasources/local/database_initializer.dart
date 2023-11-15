import '../../../../../constants/strings.dart';
import 'movies_database.dart';

class DatabaseInitializer {
  Future<MoviesDatabase> initializeDB() async {
    MoviesDatabase databaseInstance;
    databaseInstance = await $FloorMoviesDatabase
        .databaseBuilder(Strings.databaseName)
        .build();

    return databaseInstance;
  }
}
