class SavedLocation {
  final String id;
  final String name;
  final String addressLine;
  final bool isPrimary;
  /// Set when the location comes from the map or API (needed for `POST .../guardian/locations`).
  final double? latitude;
  final double? longitude;

  const SavedLocation({
    required this.id,
    required this.name,
    required this.addressLine,
    this.isPrimary = false,
    this.latitude,
    this.longitude,
  });

  /// Bold line on location tiles: text before the first ` — ` / ` – ` / ` - ` separator.
  String get tileTitle {
    final split = _splitCombinedLabel();
    if (split != null) return split.$1;
    final n = name.trim();
    return n.isNotEmpty ? n : addressLine.trim();
  }

  /// Grey line on tiles: text after the separator; omitted when empty or duplicate.
  String? get tileSubtitle {
    final split = _splitCombinedLabel();
    if (split != null) {
      final sub = split.$2.trim();
      return sub.isEmpty ? null : sub;
    }
    final n = name.trim();
    final a = addressLine.trim();
    if (a.isEmpty || a == n) return null;
    return a;
  }

  /// If [name] or [addressLine] still holds a combined `"Title — detail"` string, split it.
  (String, String)? _splitCombinedLabel() {
    const separators = [' — ', ' – ', ' - '];
    for (final field in [name, addressLine]) {
      final s = field.trim();
      if (s.isEmpty) continue;
      for (final sep in separators) {
        final i = s.indexOf(sep);
        if (i >= 0) {
          final t = s.substring(0, i).trim();
          final u = s.substring(i + sep.length).trim();
          return (t, u);
        }
      }
    }
    return null;
  }
}
