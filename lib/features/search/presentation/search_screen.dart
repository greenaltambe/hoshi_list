import 'package:flutter/material.dart';
import 'package:hoshi_list/features/media/domain/media_browse_query.dart';
import 'package:hoshi_list/features/media/domain/media_enums.dart';
import 'package:hoshi_list/features/media/presentation/widgets/media_grid.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();
  MediaType _type = MediaType.anime;
  String _submitted = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _controller,
          autofocus: true,
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            hintText: 'Search ${_type.label}',
            border: InputBorder.none,
          ),
          onSubmitted: (text) => setState(() => _submitted = text.trim()),
        ),
        actions: [
          PopupMenuButton<MediaType>(
            icon: const Icon(Icons.filter_list),
            initialValue: _type,
            onSelected: (type) => setState(() => _type = type),
            itemBuilder: (context) => [
              for (final type in MediaType.values)
                PopupMenuItem(value: type, child: Text(type.label)),
            ],
          ),
        ],
      ),
      body: _submitted.isEmpty
          ? const Center(child: Text('Search for something to watch or read.'))
          : MediaGrid(
              query: MediaBrowseQuery(type: _type, searchText: _submitted),
            ),
    );
  }
}
