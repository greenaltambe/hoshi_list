import 'package:flutter/material.dart';
import 'package:hoshi_list/core/widgets/form_fields.dart';
import 'package:hoshi_list/core/widgets/sheet_drag_handle.dart';
import 'package:hoshi_list/features/media/domain/media_browse_query.dart';
import 'package:hoshi_list/features/media/domain/media_enums.dart';

/// Shows the sort/filter sheet. Resolves to the updated query, or null if
/// dismissed.
Future<MediaBrowseQuery?> showMediaFilterSheet(
  BuildContext context,
  MediaBrowseQuery query,
) {
  return showDraggableSheet<MediaBrowseQuery>(
    context,
    builder: (context, scrollController) =>
        MediaFilterSheet(query: query, scrollController: scrollController),
  );
}

class MediaFilterSheet extends StatefulWidget {
  const MediaFilterSheet({
    super.key,
    required this.query,
    required this.scrollController,
  });

  final MediaBrowseQuery query;
  final ScrollController scrollController;

  @override
  State<MediaFilterSheet> createState() => _MediaFilterSheetState();
}

class _MediaFilterSheetState extends State<MediaFilterSheet> {
  late MediaSort _sort = widget.query.sort;
  late MediaFormat? _format = widget.query.filters.format;
  late MediaStatus? _status = widget.query.filters.status;
  late CountryOfOrigin? _country = widget.query.filters.countryOfOrigin;
  late MediaSeason? _season = widget.query.filters.season;
  late DateTime? _minDate = widget.query.filters.minimumReleaseDate;
  late DateTime? _maxDate = widget.query.filters.maximumReleaseDate;
  late int? _minEpisodes = widget.query.filters.minimumEpisodes;
  late int? _maxEpisodes = widget.query.filters.maximumEpisodes;
  late int? _minChapters = widget.query.filters.minimumChapters;
  late int? _maxChapters = widget.query.filters.maximumChapters;
  late int? _minScore = widget.query.filters.minimumAverageScore;
  late int? _maxScore = widget.query.filters.maximumAverageScore;

  /// Bumped on reset so the text fields rebuild with their cleared values.
  int _resetCount = 0;

  bool get _isAnime => widget.query.type == MediaType.anime;

  void _reset() => setState(() {
    _sort = MediaSort.popularityDesc;
    _format = _status = _country = _season = null;
    _minDate = _maxDate = null;
    _minEpisodes = _maxEpisodes = _minChapters = _maxChapters = null;
    _minScore = _maxScore = null;
    _resetCount++;
  });

  void _apply() {
    Navigator.of(context).pop(
      widget.query.copyWith(
        sort: _sort,
        filters: MediaFilters(
          format: _format,
          status: _status,
          countryOfOrigin: _country,
          season: _season,
          minimumReleaseDate: _minDate,
          maximumReleaseDate: _maxDate,
          minimumEpisodes: _minEpisodes,
          maximumEpisodes: _maxEpisodes,
          minimumChapters: _minChapters,
          maximumChapters: _maxChapters,
          minimumAverageScore: _minScore,
          maximumAverageScore: _maxScore,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Row(
            children: [
              Text(
                'Sort & filter',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const Spacer(),
              TextButton(onPressed: _reset, child: const Text('Reset')),
              FilledButton(onPressed: _apply, child: const Text('Apply')),
            ],
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: ListView(
            controller: widget.scrollController,
            padding: const EdgeInsets.all(16),
            children: [
              _Option(
                'Sort by',
                _Dropdown<MediaSort>(
                  value: _sort,
                  items: MediaSort.values,
                  labelOf: (v) => v.label,
                  onChanged: (v) => setState(() => _sort = v ?? _sort),
                ),
              ),
              _Option(
                'Format',
                _Dropdown<MediaFormat>(
                  value: _format,
                  items: MediaFormat.values,
                  labelOf: (v) => v.label,
                  onChanged: (v) => setState(() => _format = v),
                  nullable: true,
                ),
              ),
              _Option(
                'Status',
                _Dropdown<MediaStatus>(
                  value: _status,
                  items: MediaStatus.values,
                  labelOf: (v) => v.label,
                  onChanged: (v) => setState(() => _status = v),
                  nullable: true,
                ),
              ),
              _Option(
                'Country',
                _Dropdown<CountryOfOrigin>(
                  value: _country,
                  items: CountryOfOrigin.values,
                  labelOf: (v) => v.label,
                  onChanged: (v) => setState(() => _country = v),
                  nullable: true,
                ),
              ),
              _Option(
                'Season',
                _Dropdown<MediaSeason>(
                  value: _season,
                  items: MediaSeason.values,
                  labelOf: (v) => v.label,
                  onChanged: (v) => setState(() => _season = v),
                  nullable: true,
                ),
              ),
              _Option(
                'Released after',
                DateField(
                  value: _minDate,
                  firstDate: DateTime(1940),
                  lastDate: DateTime(2100),
                  onChanged: (v) => setState(() => _minDate = v),
                ),
              ),
              _Option(
                'Released before',
                DateField(
                  value: _maxDate,
                  firstDate: DateTime(1940),
                  lastDate: DateTime(2100),
                  onChanged: (v) => setState(() => _maxDate = v),
                ),
              ),
              if (_isAnime) ...[
                _numberOption(
                  'Min episodes',
                  _minEpisodes,
                  (v) => _minEpisodes = v,
                ),
                _numberOption(
                  'Max episodes',
                  _maxEpisodes,
                  (v) => _maxEpisodes = v,
                ),
              ] else ...[
                _numberOption(
                  'Min chapters',
                  _minChapters,
                  (v) => _minChapters = v,
                ),
                _numberOption(
                  'Max chapters',
                  _maxChapters,
                  (v) => _maxChapters = v,
                ),
              ],
              _numberOption('Min score', _minScore, (v) => _minScore = v),
              _numberOption('Max score', _maxScore, (v) => _maxScore = v),
            ],
          ),
        ),
      ],
    );
  }

  Widget _numberOption(String label, int? value, void Function(int?) assign) {
    return _Option(
      label,
      TextFormField(
        key: ValueKey('$label-$_resetCount'),
        initialValue: value?.toString(),
        keyboardType: TextInputType.number,
        decoration: outlinedInputDecoration(),
        onChanged: (text) => assign(int.tryParse(text)),
      ),
    );
  }
}

class _Option extends StatelessWidget {
  const _Option(this.label, this.field);

  final String label;
  final Widget field;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(label, style: Theme.of(context).textTheme.bodyLarge),
          ),
          const SizedBox(width: 16),
          Expanded(flex: 3, child: field),
        ],
      ),
    );
  }
}

class _Dropdown<T> extends StatelessWidget {
  const _Dropdown({
    required this.value,
    required this.items,
    required this.labelOf,
    required this.onChanged,
    this.nullable = false,
  });

  final T? value;
  final List<T> items;
  final String Function(T) labelOf;
  final ValueChanged<T?> onChanged;

  /// Adds an "Any" entry that maps to null.
  final bool nullable;

  @override
  Widget build(BuildContext context) {
    return InputDecorator(
      decoration: outlinedInputDecoration(),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T?>(
          value: value,
          isExpanded: true,
          isDense: true,
          items: [
            if (nullable)
              const DropdownMenuItem(value: null, child: Text('Any')),
            for (final item in items)
              DropdownMenuItem(value: item, child: Text(labelOf(item))),
          ],
          onChanged: onChanged,
        ),
      ),
    );
  }
}
