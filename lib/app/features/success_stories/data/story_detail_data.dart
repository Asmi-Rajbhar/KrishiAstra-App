import 'package:krishiastra/app/features/success_stories/domain/entities/story_detail.dart';
import 'package:krishiastra/app/core/utils/app_images.dart';

class SuccessStories {
  static final List<StoryDetail> stories = [
    const StoryDetail(
      videoUrl: 'https://www.youtube.com/watch?v=example1',
      thumbnailUrl: AppImages.storyRameshThumbnail,
      authorName: 'Ramesh Patel',
      authorImage: AppImages.storyRameshThumbnail,

      location: 'Gujarat, India',
      headline: 'How Ramesh tripled his Sugarcane yield',
      yieldIncrease: '+20%',
      costSaved: '₹500',
      contentParagraphs: [
        'Discover the innovative fertilization techniques that transformed Ramesh\'s farm into a high-yield success in record time.',
        'By adopting a new set of bio-fertilizers and precision irrigation, Ramesh was able to reduce water consumption by 30% while boosting crop health.',
      ],
      highlightTitle: 'Key Takeaway',
      highlightText:
          'The combination of soil testing and targeted nutrient application was the game-changer for my farm.',
    ),
    const StoryDetail(
      videoUrl: '',
      thumbnailUrl: AppImages.storySunitaThumbnail,
      authorName: 'Sunita Sharma',
      authorImage: AppImages.storyAuthorPlaceholder2,
      location: 'Maharashtra, India',
      headline: 'Sunita\'s Organic Revolution',
      yieldIncrease: '+50%',
      costSaved: '₹20,000',
      contentParagraphs: [
        'After years of chemical farming, Sunita switched to organic compost and saw her soil health improve drastically.',
        'Her story is a testament to the power of sustainable farming practices in building long-term soil fertility and reducing dependency on chemical inputs.',
      ],
      highlightTitle: 'From the Farmer',
      highlightText:
          'Going organic was the best decision I ever made. My soil is alive again, and my crops are healthier than ever.',
    ),
    const StoryDetail(
      videoUrl: 'https://www.youtube.com/watch?v=example2',
      thumbnailUrl: AppImages.storyAnilThumbnail,
      authorName: 'Anil Kumar',
      authorImage: AppImages.storyAuthorPlaceholder3,
      location: 'Punjab, India',
      headline: 'Smart Irrigation with Anil',
      yieldIncrease: '+40%',
      costSaved: '₹35,000',
      contentParagraphs: [
        'See how Anil managed to save 40% more water using simple sensor-based drip irrigation systems in his arid region.',
        'This technology allowed him to automate watering schedules based on real-time soil moisture data, leading to significant water and labor savings.',
      ],
      highlightTitle: 'Tech in Action',
      highlightText:
          'The sensors are my eyes in the field. I know exactly when and how much to water my crops without any guesswork.',
    ),
  ];
}
