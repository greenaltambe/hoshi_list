import 'package:hoshi_list/models/media.dart';

final dummyMediaDetails = <int, MediaDetails>{
  1: MediaDetails(
    id: 1,
    romajiTitle: 'Fullmetal Alchemist: Brotherhood',
    bannerImageUrl: 'https://picsum.photos/400/600?1', // poster
    coverImageUrl: 'https://picsum.photos/900/500?1', // cover / banner
    description:
        'Two brothers search for the Philosopher’s Stone after an attempt  '
        'to revive their deceased mother goes horribly wrong.',
    format: MediaFormat.tv,
    status: MediaStatus.finished,
    startDate: DateTime(2009, 4, 5),
    episodes: 64,
    averageScore: 91,
    genres: ['Action', 'Adventure', 'Drama', 'Fantasy'],
  ),

  2: MediaDetails(
    id: 2,
    romajiTitle: 'Attack on Titan',
    bannerImageUrl: 'https://picsum.photos/400/600?2',
    coverImageUrl: 'https://picsum.photos/900/500?2',
    description:
        'Humanity fights for survival against giant humanoid Titans '
        'behind massive walls.',
    format: MediaFormat.tv,
    status: MediaStatus.finished,
    startDate: DateTime(2013, 4, 7),
    episodes: 87,
    averageScore: 88,
    genres: ['Action', 'Drama', 'Fantasy'],
  ),

  5: MediaDetails(
    id: 5,
    romajiTitle: 'Jujutsu Kaisen',
    bannerImageUrl: 'https://picsum.photos/400/600?5',
    coverImageUrl: 'https://picsum.photos/900/500?5',
    description:
        'A boy swallows a cursed object and becomes host to a powerful curse, '
        'dragging him into the world of jujutsu sorcerers.',
    format: MediaFormat.tv,
    status: MediaStatus.releasing,
    startDate: DateTime(2020, 10, 3),
    episodes: 47,
    averageScore: 84,
    genres: ['Action', 'Supernatural'],
  ),
};
