final userProfileQueryString = '''
query {
  Viewer {
    id
    name
    about
    avatar {
      large
    }
  }
}
''';
