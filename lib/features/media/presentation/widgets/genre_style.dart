import 'package:flutter/material.dart';
import 'package:hoshi_list/features/media/domain/media_enums.dart';

extension GenreStyle on Genre {
  Color get color => switch (this) {
    Genre.action => const Color(0xFFD32F2F),
    Genre.adventure => const Color(0xFF1976D2),
    Genre.comedy => const Color(0xFFFBC02D),
    Genre.drama => const Color(0xFF7B1FA2),
    Genre.ecchi => const Color(0xFFE64A19),
    Genre.fantasy => const Color(0xFF512DA8),
    Genre.hentai => const Color(0xFF00897B),
    Genre.horror => const Color(0xFF303F9F),
    Genre.mahouShoujo => const Color(0xFFF57C00),
    Genre.mecha => const Color(0xFF455A64),
    Genre.music => const Color(0xFFFFA000),
    Genre.mystery => const Color(0xFF0288D1),
    Genre.psychological => const Color(0xFF388E3C),
    Genre.romance => const Color(0xFFC2185B),
    Genre.sciFi => const Color(0xFF1565C0),
    Genre.sliceOfLife => const Color(0xFF5D4037),
    Genre.sports => const Color(0xFF00796B),
    Genre.supernatural => const Color(0xFF6A1B9A),
    Genre.thriller => const Color(0xFFC62828),
    Genre.other => const Color(0xFF546E7A),
  };
}
