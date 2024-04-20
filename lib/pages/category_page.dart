import 'package:flutter/material.dart';
import 'package:leare_fa/models/feed_model.dart';
import 'package:leare_fa/pages/pages.dart';
import 'package:leare_fa/utils/graphql_category.dart';
import 'package:leare_fa/widgets/home/course_card.dart';

class CategoryArguments {
  final Category? category;
  CategoryArguments(this.category);
}

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  List<Course> categoryCourses = [];
  final GraphQLCategory _graphQLCategory = GraphQLCategory();
  var args;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      setState(() {
        args = (ModalRoute.of(context)?.settings.arguments ?? CategoryArguments(null)) as CategoryArguments;
      });
      print(args.category.name);
      fetchCategoryCourses();
    });
  }

  void fetchCategoryCourses() async {
    try {
      if (args.category != null) {
        categoryCourses = await _graphQLCategory.getCoursesByCategory(category: args.category.id);
        setState(() {
          categoryCourses = categoryCourses;
        });
        print(categoryCourses.toString());
      }
    } catch (error) {
      print("Error fetching Data");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(args != null ? args.category?.name : 'Categorías'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        child: categoryCourses.length > 0 ? ListView.builder(
          itemCount: categoryCourses.length,
          itemBuilder: (context, index) {
            print('$index ${categoryCourses.length}');
            return index%2 != 0 ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Navigator.pushNamed(context, '/course', arguments: CourseArguments(categoryCourses[index].id)),
                      child: CourseCard(course: categoryCourses[index],)),
                  ),
                  index < categoryCourses.length-1 ? Expanded(
                    child: GestureDetector(
                      onTap: () => Navigator.pushNamed(context, '/course', arguments: CourseArguments(categoryCourses[index+1].id)),
                      child: CourseCard(course: categoryCourses[index+1])),
                  ) : const Expanded(child: SizedBox(),),
                ],
              ),
            ) : const SizedBox();
          },
        ) : const Center(
          child: Text("Esta categoría aún no tiene cursos"),
        )
      ) ,
    );
  }
}