import 'package:flutter/material.dart';

/// A widget to display a loading indicator in a horizontal media list.
class LoadingHorizontalMediaList extends StatelessWidget {
  const LoadingHorizontalMediaList({super.key});
  @override
  Widget build(BuildContext context) {
    return Center(child: CircularProgressIndicator());
  }
}
