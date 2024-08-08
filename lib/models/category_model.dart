class CategoryModel {
  final String id;
  final String name;
  final bool isUsed;

  CategoryModel({
    required this.id,
    required this.name,
    this.isUsed = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'isUsed': isUsed,
    };
  }

  factory CategoryModel.fromJson(String id, Map<String, dynamic> json) {
    return CategoryModel(
      id: id,
      name: json['name'] as String,
      isUsed: json['isUsed'] as bool? ?? false,
    );
  }

  CategoryModel copyWith({
    String? id,
    String? name,
    bool? isUsed,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      isUsed: isUsed ?? this.isUsed,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CategoryModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          isUsed == other.isUsed;

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ isUsed.hashCode;

  @override
  String toString() {
    return 'CategoryModel{id: $id, name: $name, isUsed: $isUsed}';
  }
}
