import 'package:flutter/material.dart';
import 'package:hoshi_list/models/constants/media_country_of_origin.dart';
import 'package:hoshi_list/models/constants/media_format.dart';
import 'package:hoshi_list/models/constants/media_season.dart';
import 'package:hoshi_list/models/constants/media_sort.dart';
import 'package:hoshi_list/models/constants/media_status.dart';
import 'package:hoshi_list/models/constants/media_type.dart';
import 'package:hoshi_list/models/media_list_query.dart';

class FilterSheet extends StatefulWidget {
  const FilterSheet({
    super.key,
    required this.currentQuery,
    required this.scrollController,
  });
  final MediaQueryAL currentQuery;
  final ScrollController scrollController;

  @override
  State<FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<FilterSheet> {
  final _formKey = GlobalKey<FormState>();

  MediaSort? _formSortOption;

  MediaFormat? _formFormatOption;

  MediaStatus? _formStatusOption;

  MediaCountryOrigin? _formCountryOfOriginOption;

  MediaSeason? _formSeasonOption;

  DateTime? _formMinimumReleaseYear;

  DateTime? _formMaximumReleaseYear;

  int? _formMinimumEpisodes;

  int? _formMaximumEpisodes;

  int? _formMinimumChapters;

  int? _formMaximumChapters;

  int? _formMinimumAverageScore;

  int? _formMaximumAverageScore;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // =========================================================
        // The header having the title, reset and apply buttons
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Text(
                'Filter Options',
                style: Theme.of(context).textTheme.titleMedium,
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
                  _formKey.currentState!.save();

                  final newQuery = widget.currentQuery.copyWith(
                    sort: _formSortOption,
                    format: _formFormatOption,
                    status: _formStatusOption,
                    countryOfOrigin: _formCountryOfOriginOption,
                    season: _formSeasonOption,
                    minimumReleaseYear: _formMinimumReleaseYear,
                    maximumReleaseYear: _formMaximumReleaseYear,
                    minimumEpisodes: _formMinimumEpisodes,
                    maximumEpisodes: _formMaximumEpisodes,
                    minimumChapters: _formMinimumChapters,
                    maximumChapters: _formMaximumChapters,
                    minimumAverageScore: _formMinimumAverageScore,
                    maximumAverageScore: _formMaximumAverageScore,
                  );
                  Navigator.of(context).pop(newQuery);
                },
                child: const Text('Filter'),
              ),
            ],
          ),
        ),
        Container(height: 1, color: Theme.of(context).dividerColor),
        // =========================================================
        // The form containing filter options
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              controller: widget.scrollController,
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Sort by option
                    FilterOption(
                      title: 'Sort By',
                      field: DropdownButtonFormField<MediaSort>(
                        items: mediaSortToString.entries
                            .map(
                              (entry) => DropdownMenuItem<MediaSort>(
                                value: entry.key,
                                child: Text(entry.value['name']!),
                              ),
                            )
                            .toList(),
                        onSaved: (value) => _formSortOption = value,
                        onChanged: (value) => _formSortOption = value,
                      ),
                    ),
                    SizedBox(height: 16),

                    // Media Format option
                    FilterOption(
                      title: 'Media Format',
                      field: DropdownButtonFormField<MediaFormat>(
                        items: mediaFormatToString.entries
                            .map(
                              (entry) => DropdownMenuItem<MediaFormat>(
                                value: entry.key,
                                child: Text(entry.value),
                              ),
                            )
                            .toList(),
                        onSaved: (value) => _formFormatOption = value,
                        onChanged: (value) => _formFormatOption = value,
                      ),
                    ),
                    SizedBox(height: 16),

                    // Media Status option
                    FilterOption(
                      title: 'Media Status',
                      field: DropdownButtonFormField<MediaStatus>(
                        items: mediaStatusToString.entries
                            .map(
                              (entry) => DropdownMenuItem<MediaStatus>(
                                value: entry.key,
                                child: Text(entry.value),
                              ),
                            )
                            .toList(),
                        onSaved: (value) => _formStatusOption = value,
                        onChanged: (value) => _formStatusOption = value,
                      ),
                    ),
                    SizedBox(height: 16),

                    // Country of Origin option
                    FilterOption(
                      title: 'Country of Origin',
                      field: DropdownButtonFormField<MediaCountryOrigin>(
                        items: mediaCountryOfOriginToString.entries
                            .map(
                              (entry) => DropdownMenuItem<MediaCountryOrigin>(
                                value: entry.key,
                                child: Text(entry.value),
                              ),
                            )
                            .toList(),
                        onSaved: (value) => _formCountryOfOriginOption = value,
                        onChanged: (value) =>
                            _formCountryOfOriginOption = value,
                      ),
                    ),
                    SizedBox(height: 16),

                    // Season option
                    FilterOption(
                      title: 'Season',
                      field: DropdownButtonFormField<MediaSeason>(
                        items: mediaSeasonToString.entries
                            .map(
                              (entry) => DropdownMenuItem<MediaSeason>(
                                value: entry.key,
                                child: Text(entry.value),
                              ),
                            )
                            .toList(),
                        onSaved: (value) => _formSeasonOption = value,
                        onChanged: (value) => _formSeasonOption = value,
                      ),
                    ),
                    SizedBox(height: 16),

                    // Minimum Release Year option
                    FilterOption(
                      title: 'Min Release Year',
                      field: DatePickerField(
                        onSelectedDate: (date) {
                          setState(() {
                            _formMinimumReleaseYear = date;
                          });
                        },
                        selectedDate: _formMinimumReleaseYear,
                      ),
                    ),
                    SizedBox(height: 16),

                    // Maximum Release Year option
                    FilterOption(
                      title: 'Max Release Year',
                      field: DatePickerField(
                        onSelectedDate: (date) {
                          setState(() {
                            _formMaximumReleaseYear = date;
                          });
                        },
                        selectedDate: _formMaximumReleaseYear,
                      ),
                    ),
                    SizedBox(height: 16),

                    if (widget.currentQuery.type == MediaTypeAL.anime)
                      // Minimum Episodes option
                      FilterOption(
                        title: 'Min Episodes',
                        field: SizedBox(
                          width: 100,
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            onSaved: (value) {
                              _formMinimumEpisodes = int.tryParse(value ?? '');
                            },
                          ),
                        ),
                      ),
                    if (widget.currentQuery.type == MediaTypeAL.anime)
                      SizedBox(height: 16),

                    if (widget.currentQuery.type == MediaTypeAL.anime)
                      // Maximum Episodes option
                      FilterOption(
                        title: 'Max Episodes',
                        field: SizedBox(
                          width: 100,
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            onSaved: (value) {
                              _formMaximumEpisodes = int.tryParse(value ?? '');
                            },
                          ),
                        ),
                      ),
                    if (widget.currentQuery.type == MediaTypeAL.anime)
                      SizedBox(height: 16),

                    if (widget.currentQuery.type == MediaTypeAL.manga)
                      // Minimum Episodes option
                      FilterOption(
                        title: 'Min Chapters',
                        field: SizedBox(
                          width: 100,
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            onSaved: (value) {
                              _formMinimumChapters = int.tryParse(value ?? '');
                            },
                          ),
                        ),
                      ),
                    if (widget.currentQuery.type == MediaTypeAL.manga)
                      SizedBox(height: 16),

                    if (widget.currentQuery.type == MediaTypeAL.manga)
                      // Maximum Chapters option
                      FilterOption(
                        title: 'Max Chapters',
                        field: SizedBox(
                          width: 100,
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            onSaved: (value) {
                              _formMaximumChapters = int.tryParse(value ?? '');
                            },
                          ),
                        ),
                      ),
                    if (widget.currentQuery.type == MediaTypeAL.manga)
                      SizedBox(height: 16),

                    // Minimum Average Score option
                    FilterOption(
                      title: 'Min Average Score',
                      field: SizedBox(
                        width: 100,
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          onSaved: (value) {
                            _formMinimumAverageScore = int.tryParse(
                              value ?? '',
                            );
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    // Maximum Average Score option
                    FilterOption(
                      title: 'Max Average Score',
                      field: SizedBox(
                        width: 100,
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          onSaved: (value) {
                            _formMaximumAverageScore = int.tryParse(
                              value ?? '',
                            );
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class FilterOption extends StatelessWidget {
  final String title;
  final Widget field;

  const FilterOption({super.key, required this.title, required this.field});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: Theme.of(context).textTheme.bodyLarge),

        const SizedBox(width: 16), // Add a little spacing
        Expanded(
          child: Align(alignment: Alignment.centerRight, child: field),
        ),
      ],
    );
  }
}

class DatePickerField extends StatelessWidget {
  const DatePickerField({
    super.key,
    required this.onSelectedDate,
    this.selectedDate,
  });

  final DateTime? selectedDate;
  final void Function(DateTime date) onSelectedDate;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final newDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1990),
          lastDate: DateTime(3000),
        );

        if (newDate != null) {
          onSelectedDate(newDate);
        }
      },

      child: InputDecorator(
        decoration: InputDecoration(border: OutlineInputBorder()),
        child: Text(
          selectedDate != null
              ? '${selectedDate!.year}-${selectedDate!.month.toString().padLeft(2, '0')}-${selectedDate!.day.toString().padLeft(2, '0')}'
              : 'Select Date',
        ),
      ),
    );
  }
}
