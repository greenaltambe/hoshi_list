import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hoshi_list/models/constants/media_list_status.dart';
import 'package:hoshi_list/models/media.dart';
import 'package:hoshi_list/models/media_mutation_query.dart';
import 'package:hoshi_list/services/anilist/anilist_provider.dart';

class MediaMutationBottomSheet extends ConsumerStatefulWidget {
  const MediaMutationBottomSheet({super.key, required this.mediaDetails});

  final MediaDetails mediaDetails;

  @override
  ConsumerState<MediaMutationBottomSheet> createState() =>
      _MediaMutationBottomSheetState();
}

class _MediaMutationBottomSheetState
    extends ConsumerState<MediaMutationBottomSheet> {
  final _mutationFormKey = GlobalKey<FormState>();
  int? _formRawScore; // score out of 100
  int? _formProgress; // number of episodes/chapters watched/read
  MediaListStatus? _formStatus; // current status in the media list
  int? _formRepeat; // number of times rewatched/reread
  String? _formNotes; // user notes
  DateTime? _formStartedAt;
  DateTime? _formCompletedAt;

  final _startAtController = TextEditingController();
  final _completedAtController = TextEditingController();

  bool _isSubmitting = false;

  @override
  void dispose() {
    _startAtController.dispose();
    _completedAtController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      maxChildSize: 0.9,
      minChildSize: 0.4,
      initialChildSize: 0.6,
      builder: (context, scrollController) => SingleChildScrollView(
        controller: scrollController,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              // The drag handle
              Container(
                height: 5,
                width: 50,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2.5),
                ),
              ),

              // Title of media being edited
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    widget.mediaDetails.romajiTitle,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),
              Divider(), // A divider to separate the title from the form
              // The mutation form
              Form(
                key: _mutationFormKey,
                child: Column(
                  children: [
                    // Status form field - ChoiceChips for each MediaListStatus
                    FormFieldCustom(
                      label: 'Status',
                      field: Wrap(
                        spacing: 8,
                        runSpacing: 4,
                        children: MediaListStatus.values.map((status) {
                          return ChoiceChip(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            showCheckmark: false,
                            label: Text(mediaListStatusToAnimeString[status]!),
                            selected: _formStatus == status,
                            onSelected: (selected) {
                              setState(() {
                                _formStatus = selected ? status : _formStatus;
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ),

                    SizedBox(height: 16), // Spacing between fields

                    FormFieldCustom(
                      label: 'Score',
                      field: TextFormField(
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return null; // Allow empty input
                          }
                          final intValue = int.tryParse(value);
                          if (intValue == null ||
                              intValue < 0 ||
                              intValue > 100) {
                            return 'Please enter a valid score between 0 and 100';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: '0',
                          suffixText: '/ 100',
                          suffixIcon: Icon(Icons.star_border_rounded),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 16,
                          ),
                          isDense: true,
                        ),

                        onSaved: (value) {
                          _formRawScore = int.tryParse(value ?? '');
                        },
                      ),
                    ),

                    SizedBox(height: 16), // Spacing between fields

                    FormFieldCustom(
                      label: 'Episodes/Chapters',
                      field: TextFormField(
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return null; // Allow empty input
                          }
                          final intValue = int.tryParse(value);
                          if (intValue == null || intValue < 0) {
                            return 'Please enter a valid number';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: '0',
                          suffixIcon: Icon(Icons.menu_book_rounded),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 16,
                          ),
                          isDense: true,
                        ),
                        onSaved: (value) {
                          _formProgress = int.tryParse(value ?? '');
                        },
                      ),
                    ),

                    SizedBox(height: 16), // Spacing between fields

                    FormFieldCustom(
                      label: 'Start Date',
                      field: TextFormField(
                        controller: _startAtController,
                        readOnly: true,
                        decoration: InputDecoration(
                          hintText: 'Select start date',
                          suffixIcon: Icon(Icons.calendar_month),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 16,
                          ),
                          isDense: true,
                        ),
                        onTap: () async {
                          final DateTime? pickedDate = await showDatePicker(
                            context: context,
                            firstDate: DateTime(1980),
                            lastDate: DateTime.now(),
                          );

                          if (pickedDate != null) {
                            setState(() {
                              _formStartedAt = pickedDate;
                              _startAtController.text =
                                  '${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}';
                            });
                          }
                        },
                      ),
                    ),

                    SizedBox(height: 16), // Spacing between fields

                    FormFieldCustom(
                      label: 'End Date',
                      field: TextFormField(
                        controller: _completedAtController,
                        readOnly: true,
                        decoration: InputDecoration(
                          hintText: 'Select end date',
                          suffixIcon: Icon(Icons.calendar_month),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 16,
                          ),
                          isDense: true,
                        ),
                        onTap: () async {
                          final DateTime? pickedDate = await showDatePicker(
                            context: context,
                            firstDate: DateTime(1980),
                            lastDate: DateTime.now(),
                          );

                          if (pickedDate != null) {
                            setState(() {
                              _formCompletedAt = pickedDate;
                              _completedAtController.text =
                                  '${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}';
                            });
                          }
                        },
                      ),
                    ),

                    SizedBox(height: 16), // Spacing between fields

                    FormFieldCustom(
                      label: 'Repeat Count',
                      field: TextFormField(
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return null; // Allow empty input
                          }
                          final intValue = int.tryParse(value);
                          if (intValue == null || intValue < 0) {
                            return 'Please enter a valid repeat count';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: '0',
                          suffixIcon: Icon(Icons.repeat),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 16,
                          ),
                          isDense: true,
                        ),

                        onSaved: (value) {
                          _formRepeat = int.tryParse(value ?? '');
                        },
                      ),
                    ),

                    SizedBox(height: 16), // Spacing between fields

                    FormFieldCustom(
                      label: 'Notes',
                      field: TextFormField(
                        keyboardType: TextInputType.multiline,
                        minLines: 3,
                        maxLines: 10,
                        textAlignVertical: TextAlignVertical.top,
                        decoration: InputDecoration(
                          hintText:
                              'Gintama is the greatest anime ever made...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 16,
                          ),
                        ),

                        onSaved: (value) {
                          _formNotes = value;
                        },
                      ),
                    ),

                    SizedBox(height: 24), // Spacing before submit button

                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: _isSubmitting ? null : _submitForm,
                        style: FilledButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: _isSubmitting
                            ? const SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text('Submit'),
                      ),
                    ),

                    SizedBox(height: 48), // Spacing at the bottom
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submitForm() async {
    final isValid = _mutationFormKey.currentState?.validate() ?? false;

    if (_formStatus == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please select a status')));
      return;
    }

    if (!isValid) {
      return;
    }

    _mutationFormKey.currentState?.save();
    setState(() {
      _isSubmitting = true;
    });

    try {
      final mediaMutation = MediaMutationQuery(
        mediaId: widget.mediaDetails.id,
        mediaListStatus: _formStatus!,
        progress: _formProgress,
        scoreRaw: _formRawScore,
        repeat: _formRepeat,
        notes: _formNotes,
        startedAt: _formStartedAt,
        completedAt: _formCompletedAt,
      );

      final alClient = ref.read(anilistProvider);
      final response = await alClient.saveMediaMutation(mediaMutation);

      if (response.statusCode == 200) {
        if (mounted) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Media updated successfully')),
          );
        }
      } else {
        throw Exception('Failed to update media');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }
}

class FormFieldCustom extends StatelessWidget {
  const FormFieldCustom({super.key, required this.label, required this.field});

  final String label;
  final Widget field;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: 16),
        field,
      ],
    );
  }
}
