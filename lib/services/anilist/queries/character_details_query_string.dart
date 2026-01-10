final mediaCharacterDetailsQueryString = '''
  query (\$id: Int!) {
    Character (id: \$id){
      id
      name {
        full
      }
      dateOfBirth {
        day
        month 
        year
      }
      description
      favourites
      image {
        large
      }
      media {
        edges {
          characterRole
        }
      }
    }
  }
''';
