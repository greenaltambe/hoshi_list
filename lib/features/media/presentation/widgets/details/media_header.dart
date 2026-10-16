import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:hoshi_list/features/media/domain/media.dart';

/// Banner, cover, title, status and genres at the top of the details screen.
class MediaHeader extends StatelessWidget {
  const MediaHeader({super.key, required this.media});

  final MediaDetails media;

  static const double _bannerHeight = 250;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final surface = theme.colorScheme.surface;
    final season = media.season;
    final seasonText = season != null && media.startDate != null
        ? '${season.label} ${media.startDate!.year}'
        : null;

    return Stack(
      children: [
        SizedBox(
          height: _bannerHeight,
          width: double.infinity,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.network(
                media.bannerImageUrl ?? media.coverImageUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => Container(color: Colors.grey[900]),
              ),
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      surface.withAlpha(0),
                      surface.withAlpha(150),
                      surface,
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            top: _bannerHeight - 100,
            left: 16,
            right: 16,
          ),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      media.coverImageUrl,
                      height: 160,
                      width: 110,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          media.romajiTitle,
                          style: theme.textTheme.titleMedium!.copyWith(
                            fontSize: 20,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        if (media.status != null)
                          Text(
                            media.status!.label.toUpperCase(),
                            style: theme.textTheme.bodySmall!.copyWith(
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        if (seasonText != null)
                          Text(seasonText, style: theme.textTheme.bodyMedium),
                        Wrap(
                          spacing: 8,
                          runSpacing: 4,
                          children: [
                            for (final genre in media.genres)
                              Chip(
                                label: Text(genre.label),
                                visualDensity: VisualDensity.compact,
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _ExpandableDescription(html: media.description),
            ],
          ),
        ),
        const SafeArea(
          child: Padding(padding: EdgeInsets.all(8), child: BackButton()),
        ),
      ],
    );
  }
}

class _ExpandableDescription extends StatefulWidget {
  const _ExpandableDescription({required this.html});

  final String html;

  @override
  State<_ExpandableDescription> createState() => _ExpandableDescriptionState();
}

class _ExpandableDescriptionState extends State<_ExpandableDescription> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimatedCrossFade(
          firstChild: SizedBox(
            height: 40,
            child: Html(data: widget.html, shrinkWrap: true),
          ),
          secondChild: Html(data: widget.html),
          crossFadeState: _isExpanded
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 200),
          alignment: Alignment.topLeft,
        ),
        IconButton(
          icon: Icon(_isExpanded ? Icons.expand_less : Icons.expand_more),
          onPressed: () => setState(() => _isExpanded = !_isExpanded),
        ),
      ],
    );
  }
}
