import 'package:flutter/material.dart';
import 'package:hoshi_list/features/media/widgets/media_details/media_details_widgets/media_relations_list.dart';

class RelationsTab extends StatelessWidget {
  const RelationsTab({super.key, required this.mediaId});

  final int mediaId;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(child: MediaRelationsList(mediaId: mediaId)),
    );
  }
}
