import 'package:equatable/equatable.dart';

/// Domain entity representing a movie genre
class GenreEntity extends Equatable {
  final int id;
  final String name;
  final String? imageUrl;

  const GenreEntity({
    required this.id,
    required this.name,
    this.imageUrl,
  });

  @override
  List<Object?> get props => [id, name, imageUrl];
}
