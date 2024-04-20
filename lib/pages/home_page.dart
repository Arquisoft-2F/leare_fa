import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:leare_fa/models/models.dart';
import 'package:leare_fa/pages/category_page.dart';
import 'package:leare_fa/pages/course_page.dart';
import 'package:leare_fa/utils/graphql_feed.dart';
import 'package:leare_fa/widgets/widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<FeedModel> feed = [];

  //"picture_id": "https://codigofacilito.com/system/courses/thumbnails/000/000/188/original/Frame_22_%281%29.png?1639153561",

  @override
  void initState() {
    super.initState();
    GraphQLFeed().getFeed().then((value) {
      setState(() {
        feed = value;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: ListView(
          children: feed.where((data) => data.courses.isNotEmpty ).map((cat) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/category', arguments: CategoryArguments(cat.category)),
                    child: Text(
                      cat.category.name,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10.0),
                CarouselSlider(
                  items: cat.courses.map<Widget>((course) {
                    return GestureDetector(
                      child: CourseCard(
                        course: course,
                      ),
                      onTap: () => {
                        Navigator.pushNamed(context, '/course', arguments: CourseArguments(course.id)),
                      
                      },
                    );
                  }).toList(),
                  options: CarouselOptions(
                    aspectRatio: 16/9,
                    initialPage: 0,
                    scrollDirection: Axis.horizontal,
                    enableInfiniteScroll: false,
                    enlargeCenterPage: true,
                    animateToClosest: true,
                  ),
                ),
              ],
            );
            }).toList(),
        ),
      ),
    );
  }
}