import '../../../../../constants/strings.dart';
import 'movies_database.dart';

class DatabaseInitializer {
  late MoviesDatabase _databaseInstance;

  Future<void> _initializeDB() async {
    _databaseInstance = await $FloorMoviesDatabase
        .databaseBuilder(Strings.databaseName)
        .build();
  }

  MoviesDatabase getDatabaseInstance() {
    _initializeDB();
    return _databaseInstance;
  }
}
