import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hoshi_list/features/browse/providers/media_list_provider.dart';
import 'package:hoshi_list/features/media/widgets/media_list/media_list_card.dart';
import 'package:hoshi_list/models/media_list_query.dart';

class AnimeMangaGrid extends ConsumerStatefulWidget {
  const AnimeMangaGrid({super.key, required this.query, required this.title});

  final MediaQueryAL query;
  final String title;

  @override
  ConsumerState<AnimeMangaGrid> createState() => _AnimeMangaGridState();
}

class _AnimeMangaGridState extends ConsumerState<AnimeMangaGrid> {
  final _formKey = GlobalKey<FormState>();
  late MediaQueryAL _currentQuery;
  MediaSort? _formSortOption;

  @override
  void initState() {
    super.initState();
    _currentQuery = widget.query;
  }

  @override
  Widget build(BuildContext context) {
    final mediaState = ref.watch(mediaListProvider(_currentQuery));
    final notifier = ref.read(mediaListProvider(_currentQuery).notifier);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(34),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    FilterChip(
                      avatar: Icon(Icons.filter_list),
                      label: Text('Filters'),
                      onSelected: (bool selected) {
                        _showSortOptions(context);
                      },
                    ),
                  ],
                ),
              ),
              Container(color: Colors.grey[300], height: 1.0),
            ],
          ),
        ),
      ),
      body: mediaState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Text(
            'Error loading',
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              color: Theme.of(context).colorScheme.error,
            ),
          ),
        ),
        data: (items) {
          return NotificationListener<ScrollNotification>(
            onNotification: (scrollInfo) {
              if (scrollInfo.metrics.pixels >
                  scrollInfo.metrics.maxScrollExtent * 0.9) {
                notifier.loadNextPage();
              }
              return false;
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 2 / 3,
                ),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return SizedBox(child: MediaListCard(item: item));
                },
              ),
            ),
          );
        },
      ),
    );
  }

  void _showSortOptions(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      isDismissible: true,

      useSafeArea: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      context: context,
      builder: (ctx) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        builder: (ctx, scrollController) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Text(
                      'Sort Options',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Spacer(),
                    TextButton(
                      onPressed: () {
                        _formKey.currentState!.reset();
                      },
                      child: Text('Reset'),
                    ),
                    FilledButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          _currentQuery = _currentQuery.copyWith(
                            sort: _formSortOption,
                            page: 1,
                          );
                          setState(() {
                            ref.read(mediaListProvider(_currentQuery).notifier);
                          });
                          Navigator.of(context).pop();
                        }
                      },
                      child: const Text('Filter'),
                    ),
                  ],
                ),
              ),
              Container(height: 1, color: Theme.of(context).dividerColor),

              Expanded(
                child: Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              'Sort By',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            Spacer(),
                            DropdownMenuFormField<MediaSort>(
                              onSaved: (newValue) => {
                                _formSortOption = newValue,
                              },
                              validator: (value) => value == null
                                  ? 'Please select a sort option'
                                  : null,
                              initialSelection: _currentQuery.sort,
                              dropdownMenuEntries: mediaSortToString.entries
                                  .map((entry) {
                                    return DropdownMenuEntry<MediaSort>(
                                      value: entry.key,
                                      label: entry.value["name"]!,
                                    );
                                  })
                                  .toList(),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
