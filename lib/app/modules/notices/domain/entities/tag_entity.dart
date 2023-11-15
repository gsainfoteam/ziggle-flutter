class TagEntity {
  final int id;
  final String name;

  TagEntity(this.id, this.name);
}

extension TagEntityCopyWith on TagEntity {
  TagEntity copyWith({
    int? id,
    String? name,
  }) {
    return TagEntity(
      id ?? this.id,
      name ?? this.name,
    );
  }
}
