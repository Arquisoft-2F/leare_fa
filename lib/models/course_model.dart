class CourseModel {
  String course_id;
  String course_name;
  String course_description;
  String creator_id;
  String chat_id;
  bool is_public;
  String picture_id;
  String created_at;
  String updated_at;
  List<ModuleModel> modules;
  List<CategoryModel> categories;

  CourseModel({
    required this.course_id,
    required this.course_name,
    required this.course_description,
    required this.creator_id,
    required this.chat_id,
    required this.is_public,
    required this.picture_id,
    required this.created_at,
    required this.updated_at,
    required this.modules,
    required this.categories,
  });

  static CourseModel fromMap({required Map map}) {
    CourseModel courseModel = CourseModel(
      course_id: map['course_id'],
      course_name: map['course_name'],
      course_description: map['course_description'],
      creator_id: map['creator_id'],
      chat_id: map['chat_id'] != null ? map['chat_id'] : '',
      is_public: map['is_public'],
      picture_id: map['picture_id'],
      created_at: map['created_at'],
      updated_at: map['updated_at'],
      modules: List<ModuleModel>.from(
          map['modules'].map((x) => ModuleModel.fromMap(map: x)).toList()),
      categories: List<CategoryModel>.from(
          map['categories'].map((x) => CategoryModel.fromMap(map: x)).toList()),
    );
    return courseModel;
  }
}

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

class ModuleModel {
  String module_id;
  String module_name;
  int pos_index;
  List<SectionModel> sections;

  ModuleModel({
    required this.module_id,
    required this.module_name,
    required this.pos_index,
    required this.sections,
  });

  static ModuleModel fromMap({required Map map}) {
    ModuleModel moduleModel = ModuleModel(
      module_id: map['module_id'],
      module_name: map['module_name'],
      pos_index: map['pos_index'],
      sections: List<SectionModel>.from(
          map['sections'].map((x) => SectionModel.fromMap(map: x)).toList()),
    );
    return moduleModel;
  }
}

class SectionModel {
  String? section_id;
  String section_name;
  String section_content;
  String video_id;
  List<String> files_array;
  int pos_index;

  SectionModel({
    this.section_id,
    required this.section_name,
    required this.section_content,
    required this.video_id,
    required this.files_array,
    required this.pos_index,
  });

  static SectionModel fromMap({required Map map}) {
    SectionModel sectionModel = SectionModel(
      section_id: map['section_id'],
      section_name: map['section_name'],
      section_content: map['section_content'],
      video_id: map['video_id'],
      files_array: map['files_array'] != null
          ? List<String>.from(map['files_array'])
          : [],
      pos_index: map['pos_index'],
    );
    return sectionModel;
  }
}
