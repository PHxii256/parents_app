class SavedLocation {
  final String id;
  final String name;
  final String addressLine;
  final bool isPrimary;

  const SavedLocation({
    required this.id,
    required this.name,
    required this.addressLine,
    this.isPrimary = false,
  });
}
