class CategoryModel {
  String category_id;
  String category_name;

  CategoryModel({
    required this.category_id,
    required this.category_name,
  });

  static CategoryModel fromMap({required Map map}) {
    CategoryModel categoryModel = CategoryModel(
      category_id: map['category_id'],
      category_name: map['category_name'],
    );
    return categoryModel;
  }
}