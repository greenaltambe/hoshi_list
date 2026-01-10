import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class MediaDescription extends StatefulWidget {
  const MediaDescription({super.key, required this.description});

  final String description;

  @override
  State<MediaDescription> createState() => _MediaDescriptionState();
}

class _MediaDescriptionState extends State<MediaDescription> {
  var _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimatedCrossFade(
          firstChild: SizedBox(
            height: 40,
            child: Html(data: widget.description, shrinkWrap: true),
          ),
          secondChild: Html(data: widget.description),
          crossFadeState: _isExpanded
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 200),
          alignment: Alignment.topLeft,
        ),
        IconButton(
          icon: _isExpanded
              ? AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (child, animation) =>
                      RotationTransition(turns: animation, child: child),
                  child: Icon(Icons.expand_less),
                )
              : AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (child, animation) =>
                      RotationTransition(turns: animation, child: child),
                  child: Icon(Icons.expand_more),
                ),
          onPressed: () {
            setState(() {
              _isExpanded = !_isExpanded;
            });
          },
        ),
      ],
    );
  }
}
