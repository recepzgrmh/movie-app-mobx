import '../../domain/entities/genre_entity.dart';

/// Data model for genre, extends the domain entity
class GenreModel extends GenreEntity {
  const GenreModel({
    required super.id,
    required super.name,
  });

  factory GenreModel.fromJson(Map<String, dynamic> json) {
    return GenreModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

/// Response model for genre list API
class GenreResponseModel {
  final List<GenreModel> genres;

  GenreResponseModel({required this.genres});

  factory GenreResponseModel.fromJson(Map<String, dynamic> json) {
    return GenreResponseModel(
      genres: json['genres'] != null
          ? List<GenreModel>.from(
              (json['genres'] as List).map((x) => GenreModel.fromJson(x)),
            )
          : [],
    );
  }
}
