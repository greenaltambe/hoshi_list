import 'package:flutter/material.dart';
import 'package:hoshi_list/features/media/domain/media_browse_query.dart';
import 'package:hoshi_list/features/media/presentation/widgets/media_filter_sheet.dart';
import 'package:hoshi_list/features/media/presentation/widgets/media_grid.dart';

/// Full-screen grid of a query's results with a sort/filter sheet.
class MediaGridScreen extends StatefulWidget {
  const MediaGridScreen({super.key, required this.query, required this.title});

  final MediaBrowseQuery query;
  final String title;

  @override
  State<MediaGridScreen> createState() => _MediaGridScreenState();
}

class _MediaGridScreenState extends State<MediaGridScreen> {
  late MediaBrowseQuery _query = widget.query;

  Future<void> _openFilters() async {
    final updated = await showMediaFilterSheet(context, _query);
    if (updated != null && updated != _query) {
      setState(() => _query = updated);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            tooltip: 'Sort and filter',
            icon: const Icon(Icons.filter_list),
            onPressed: _openFilters,
          ),
        ],
      ),
      body: MediaGrid(query: _query),
    );
  }
}
