import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hoshi_list/features/media/widgets/media_list/grid_media_list/anime_manga_grid.dart';
import 'package:hoshi_list/models/media_list_query.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _textController = TextEditingController();
  var _currentSearchType = MediaTypeAL.anime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          autofocus: true,
          onSubmitted: (value) {
            final searchQuery = MediaQueryAL(
              type: _currentSearchType,
              searchString: value,
            );

            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (ctx) {
                  return AnimeMangaGrid(
                    query: searchQuery,
                    title: 'Search Results',
                  );
                },
              ),
            );
          },
          controller: _textController,
          decoration: InputDecoration(
            hintText: 'Search...',
            border: InputBorder.none,
          ),
          keyboardType: TextInputType.text,
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1.0),
          child: Container(color: Colors.grey[300], height: 1.0),
        ),

        actions: [
          PopupMenuButton(
            icon: Icon(Icons.filter_list),
            itemBuilder: (context) => [
              PopupMenuItem(child: Text('Anime')),
              PopupMenuItem(child: Text('Manga')),
            ],
          ),
        ],
      ),
    );
  }
}
