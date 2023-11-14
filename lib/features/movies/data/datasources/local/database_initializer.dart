import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../constants/strings.dart';
import 'movies_database.dart';

class DatabaseInitializer {
  late MoviesDatabase _databaseInstance;

  Future<void> _initializeDB() async {
    _databaseInstance = await $FloorMoviesDatabase
        .databaseBuilder(Strings.databaseName)
        .build();
  }

  MoviesDatabase getDatabaseInstance(){
    // WidgetsFlutterBinding.ensureInitialized();
    _initializeDB();
    return _databaseInstance;
  }
}
