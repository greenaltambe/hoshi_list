import 'package:hoshi_list/models/constants/media_list_status.dart';
import 'package:hoshi_list/models/media_list_group.dart';
import 'package:hoshi_list/services/anilist/mappers/media_mapper.dart';

class MediaListCollectionMapper {
  const MediaListCollectionMapper();

  List<MediaListGroup> fromJson(Map<String, dynamic> json) {
    /// Media list collection is a list of media list Group
    /// media list group is a model of a group/list like (watching, planning etc)
    final List<MediaListGroup> mediaListCollection = [];

    /// If errors happens in the returned string by al throw error
    if (json['errors'] != null) {
      throw Exception('Error from Anilist API: ${json['errors']}');
    }

    /// Check for ensuring consistent format in data returend by anilist
    if (json['data'] == null ||
        json['data']['MediaListCollection'] == null ||
        json['data']['MediaListCollection']['lists'] == null) {
      throw Exception('Invalid data format from Anilist API');
    }

    // Obtain the list having media list groups
    final listOfMediaListsJson =
        json['data']['MediaListCollection']['lists']
            as List<dynamic>; // List of lists

    // For each list in listOfMediaListJson, map and obtain a MediaListGroup
    for (var mediaListJson in listOfMediaListsJson) {
      mediaListCollection.add(MapMediaListGroup().fromJson(mediaListJson));
    }

    return mediaListCollection;
  }
}

class MapMediaListGroup {
  const MapMediaListGroup();

  MediaListGroup fromJson(Map<String, dynamic> json) {
    final name = json['name'] as String? ?? 'Unknown';
    final isCustomList = json['isCustomList'] as bool? ?? false;
    final mediaStatus = stringToMediaListStatus[json['status'] as String?];
    final entriesJson =
        json['entries']; // This consists of media + id of entry (for some reason each media item has its own id in the list)
    // Map each entry to MediaListEntry
    final List<MediaListEntry> mediaListEntryList = [];
    for (var entry in entriesJson) {
      final entryId = entry['id'];
      final userScore = entry['score'] as int? ?? 0;
      final userProgress = entry['progress'] as int? ?? 0;
      final mediaJson = entry['media'];
      final media = MediaMapper().fromJson(mediaJson);
      final mediaListEntry = MediaListEntry(
        entryId: entryId,
        userScore: userScore,
        userProgress: userProgress,
        media: media,
      );
      mediaListEntryList.add(mediaListEntry);
    }

    return MediaListGroup(
      name: name,
      isCustomList: isCustomList,
      mediaStatus: mediaStatus,
      entries: mediaListEntryList,
    );
  }
}
