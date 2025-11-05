class SectionModel {
  final int index;
  final String id;
  final SectionType type;

  SectionModel({
    required this.index,
    required this.id,
    required this.type,
  });
}

enum SectionType {
  hero,
  rethinking,
  security,
  protection,
  oneApp,
  connected,
  footer,
}