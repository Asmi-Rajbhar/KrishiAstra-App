import 'package:equatable/equatable.dart';

/// Entity class for crop cards displayed on the home page.
class CropCardEntity extends Equatable {
  final String imageUrl;
  final String badge;
  final String name;

  const CropCardEntity({
    required this.imageUrl,
    required this.badge,
    required this.name,
  });

  @override
  List<Object?> get props => [imageUrl, badge, name];

  CropCardEntity copyWith({String? imageUrl, String? badge, String? name}) {
    return CropCardEntity(
      imageUrl: imageUrl ?? this.imageUrl,
      badge: badge ?? this.badge,
      name: name ?? this.name,
    );
  }
}
