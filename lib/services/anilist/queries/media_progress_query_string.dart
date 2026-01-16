final mediaProgressQueryString = r'''
query MediaProgress ($id: Int) {
  Media (id: $id) {
    mediaListEntry {
      mediaId
      status
      progress
      score
      repeat
      notes
      startedAt {
        day
        month
        year
      }
      completedAt {
        day
        month
        year
      }
      customLists
      private
    }
  }
}
''';

/**
 * query MediaProgress ($id: Int) {
  Media (id: $id) {
    mediaListEntry {
      status
      progress
      score
      repeat
      notes
      startedAt {
        day
        month
        year
      }
      completedAt {
        day
        month
        year
      }
      customLists
      private
    }
  }
}

 * 
 */
