import 'package:floor/floor.dart';

@entity
class GenreModel {
  @primaryKey
  final int id;
  final String name;

  GenreModel({
    required this.id,
    required this.name,
  });

  @override
  int get hashCode => id.hashCode + name.hashCode;

  @override
  bool operator ==(Object other) =>
      other is GenreModel && id == other.id && name == other.name;
}
