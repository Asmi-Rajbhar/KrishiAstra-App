// Language is injected automatically by DioClient's language interceptor.
// Do NOT add 'lang' to individual queryParameters.
import 'package:krishiastra/app/features/home/domain/repositories/i_home_repository.dart';
import 'package:krishiastra/app/features/home/domain/entities/crop_card_entity.dart';

class HomeRepository implements IHomeRepository {
  HomeRepository();

  @override
  Future<List<CropCardEntity>> getHomeCrops() async {
    // Return only future scope hardcoded crops as requested by the user
    return [
      const CropCardEntity(
        imageUrl:
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTabjkABlfcZvwF0F3wgcH-3676jfEq6gcMHQ&s',
        badge: 'highYield',
        name: 'maize',
      ),
      const CropCardEntity(
        imageUrl:
            'https://images.unsplash.com/photo-1586201375761-83865001e31c?q=80&w=800&auto=format&fit=crop',
        badge: 'cashCrop',
        name: 'rice',
      ),
      const CropCardEntity(
        imageUrl:
            'https://images.unsplash.com/photo-1537640538966-79f369143f8f?q=80&w=800&auto=format&fit=crop',
        badge: 'exportQuality',
        name: 'grapes',
      ),
      const CropCardEntity(
        imageUrl:
            'https://goqii.com/blog/wp-content/uploads/shutterstock_1467898517-1024x682.jpg',
        badge: 'proteinRich',
        name: 'soybeans',
      ),
      const CropCardEntity(
        imageUrl:
            'https://images.unsplash.com/photo-1574323347407-f5e1ad6d020b?q=80&w=800&auto=format&fit=crop',
        badge: 'resilient',
        name: 'wheat',
      ),
    ];
  }
}
