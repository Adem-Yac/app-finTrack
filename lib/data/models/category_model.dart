class CategoryModel {
  const CategoryModel({
    required this.id,
    required this.slug,
    required this.name,
    required this.type,
    this.icon,
    this.color,
  });

  final int id;
  final String slug;
  final String name;
  final String type;
  final String? icon;
  final String? color;

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] as int,
      slug: json['slug'] as String? ?? '',
      name: json['name'] as String? ?? '',
      type: json['type'] as String? ?? 'expense',
      icon: json['icon'] as String?,
      color: json['color'] as String?,
    );
  }
}
