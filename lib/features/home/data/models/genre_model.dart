import '../../domain/entities/genre_entity.dart';

class GenreModel extends GenreEntity {
  const GenreModel({required super.id, required super.name, super.imageUrl});

  factory GenreModel.fromJson(Map<String, dynamic> json) {
    return GenreModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      imageUrl: json['imageUrl'],
    );
  }

  /// Create a copy with imageUrl
  GenreModel copyWithImage(String? imageUrl) {
    return GenreModel(id: id, name: name, imageUrl: imageUrl);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'imageUrl': imageUrl};
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
