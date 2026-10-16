import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hoshi_list/core/error/app_exception.dart';
import 'package:hoshi_list/core/widgets/async_value_view.dart';
import 'package:hoshi_list/core/widgets/form_fields.dart';
import 'package:hoshi_list/core/widgets/sheet_drag_handle.dart';
import 'package:hoshi_list/features/library/domain/library_models.dart';
import 'package:hoshi_list/features/library/domain/media_list_status.dart';
import 'package:hoshi_list/features/library/presentation/library_providers.dart';
import 'package:hoshi_list/features/media/domain/media.dart';
import 'package:hoshi_list/features/media/domain/media_enums.dart';

/// Opens the "edit my list entry" sheet for [media].
Future<void> showMediaEntrySheet(BuildContext context, MediaDetails media) {
  return showDraggableSheet<void>(
    context,
    builder: (context, scrollController) =>
        MediaEntrySheet(media: media, scrollController: scrollController),
  );
}

class MediaEntrySheet extends ConsumerWidget {
  const MediaEntrySheet({
    super.key,
    required this.media,
    required this.scrollController,
  });

  final MediaDetails media;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entry = ref.watch(mediaListEntryProvider(media.id));
    return AsyncValueView(
      value: entry,
      onRetry: () => ref.invalidate(mediaListEntryProvider(media.id)),
      data: (entry) => _EntryForm(
        media: media,
        initial: entry,
        scrollController: scrollController,
      ),
    );
  }
}

class _EntryForm extends ConsumerStatefulWidget {
  const _EntryForm({
    required this.media,
    required this.initial,
    required this.scrollController,
  });

  final MediaDetails media;
  final MediaListEntryDetails? initial;
  final ScrollController scrollController;

  @override
  ConsumerState<_EntryForm> createState() => _EntryFormState();
}

class _EntryFormState extends ConsumerState<_EntryForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _score;
  late final TextEditingController _progress;
  late final TextEditingController _repeat;
  late final TextEditingController _notes;
  late MediaListStatus _status;
  DateTime? _startedAt;
  DateTime? _completedAt;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    final initial = widget.initial;
    String text(int? value) => value == null || value == 0 ? '' : '$value';
    _score = TextEditingController(text: text(initial?.score));
    _progress = TextEditingController(text: text(initial?.progress));
    _repeat = TextEditingController(text: text(initial?.repeat));
    _notes = TextEditingController(text: initial?.notes ?? '');
    _status = initial?.status ?? MediaListStatus.planning;
    _startedAt = initial?.startedAt;
    _completedAt = initial?.completedAt;
  }

  @override
  void dispose() {
    _score.dispose();
    _progress.dispose();
    _repeat.dispose();
    _notes.dispose();
    super.dispose();
  }

  String? _validateInt(String? value, {int max = 1 << 31, String? maxError}) {
    if (value == null || value.isEmpty) return null;
    final parsed = int.tryParse(value);
    if (parsed == null || parsed < 0) return 'Enter a whole number';
    if (parsed > max) return maxError ?? 'Must be at most $max';
    return null;
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);
    setState(() => _isSubmitting = true);

    try {
      await ref
          .read(libraryActionsProvider)
          .save(
            MediaListEntryInput(
              mediaId: widget.media.id,
              status: _status,
              progress: int.tryParse(_progress.text) ?? 0,
              score: int.tryParse(_score.text) ?? 0,
              repeat: int.tryParse(_repeat.text) ?? 0,
              notes: _notes.text,
              startedAt: _startedAt,
              completedAt: _completedAt,
            ),
            widget.media.type,
          );
      navigator.pop();
      messenger.showSnackBar(const SnackBar(content: Text('List updated')));
    } catch (error) {
      messenger.showSnackBar(SnackBar(content: Text(describeError(error))));
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final media = widget.media;
    final total = media.totalUnits;

    return SingleChildScrollView(
      controller: widget.scrollController,
      padding: EdgeInsets.fromLTRB(
        16,
        16,
        16,
        32 + MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Center(child: SheetDragHandle()),
            Text(
              media.romajiTitle,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const Divider(height: 32),
            _Field(
              label: 'Status',
              child: Wrap(
                spacing: 8,
                runSpacing: 4,
                children: [
                  for (final status in MediaListStatus.values)
                    ChoiceChip(
                      showCheckmark: false,
                      label: Text(status.label(media.type)),
                      selected: _status == status,
                      onSelected: (_) => setState(() => _status = status),
                    ),
                ],
              ),
            ),
            _Field(
              label: 'Score',
              child: TextFormField(
                controller: _score,
                keyboardType: TextInputType.number,
                validator: (v) =>
                    _validateInt(v, max: 100, maxError: 'Score is 0 to 100'),
                decoration: outlinedInputDecoration(
                  icon: Icons.star_border_rounded,
                  suffixText: '/ 100',
                  hint: '0',
                ),
              ),
            ),
            _Field(
              label: media.type == MediaType.anime ? 'Episodes' : 'Chapters',
              child: TextFormField(
                controller: _progress,
                keyboardType: TextInputType.number,
                validator: (v) => _validateInt(
                  v,
                  max: total ?? (1 << 31),
                  maxError: 'There are only $total in total',
                ),
                decoration: outlinedInputDecoration(
                  icon: Icons.menu_book_rounded,
                  hint: '0',
                  suffixText: total == null ? null : '/ $total',
                ),
              ),
            ),
            _Field(
              label: 'Start date',
              child: DateField(
                value: _startedAt,
                firstDate: DateTime(1980),
                lastDate: DateTime.now(),
                onChanged: (date) => setState(() => _startedAt = date),
              ),
            ),
            _Field(
              label: 'End date',
              child: DateField(
                value: _completedAt,
                firstDate: DateTime(1980),
                lastDate: DateTime.now(),
                onChanged: (date) => setState(() => _completedAt = date),
              ),
            ),
            _Field(
              label: 'Repeat count',
              child: TextFormField(
                controller: _repeat,
                keyboardType: TextInputType.number,
                validator: _validateInt,
                decoration: outlinedInputDecoration(
                  icon: Icons.repeat,
                  hint: '0',
                ),
              ),
            ),
            _Field(
              label: 'Notes',
              child: TextFormField(
                controller: _notes,
                keyboardType: TextInputType.multiline,
                minLines: 3,
                maxLines: 10,
                decoration: outlinedInputDecoration(),
              ),
            ),
            const SizedBox(height: 8),
            FilledButton(
              onPressed: _isSubmitting ? null : _submit,
              child: _isSubmitting
                  ? const SizedBox.square(
                      dimension: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}

class _Field extends StatelessWidget {
  const _Field({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }
}
