import 'package:flutter/material.dart';

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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          AnimatedCrossFade(
            firstChild: Text(
              widget.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            secondChild: Text(widget.description),
            crossFadeState: _isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 100),
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
      ),
    );
  }
}
