final staffDetailsQueryString = '''
  query (\$id: Int!) {
    Staff (id: \$id){
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
      characters {
        edges {
          role
        }
      }
    }
  }
''';
