import 'package:flutter/material.dart';
import 'package:leare_fa/models/search_model.dart';
import 'package:leare_fa/utils/graphql_search.dart';
import 'package:leare_fa/widgets/search_page/category_result.dart';
import 'package:leare_fa/widgets/search_page/user_result.dart';
import 'package:leare_fa/widgets/widgets.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<SearchModel> _searchResults = [];
  List<String> _filters = ["Course", "Category", "User"];
  final GraphQLSearch _graphQLSearch = GraphQLSearch();

  List<SearchModel> get _searchResultsFiltered {
    if (_filters.isEmpty) {
      return _searchResults;
    }
    return _searchResults.where((result) => _filters.contains(result.post.type)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Container(
      color: colorScheme.surface,
      child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 0.0),
          child: Column(
            children: [
              SearchAnchor(
                isFullScreen: true,
                viewBackgroundColor: colorScheme.surface,
                viewSurfaceTintColor: colorScheme.surface,
                viewOnChanged: (value) async {
                  if (value.isNotEmpty) {
                    await _graphQLSearch.search(q: value).then((results) {
                      setState(() {
                        _searchResults = results;
                      });
                    });
                  }
                },
                builder: (context, controller) {
                  return Column(
                    children: [
                      SearchBar(
                        controller: controller,
                        autoFocus: true,
                        elevation: const MaterialStatePropertyAll(1.0),
                        surfaceTintColor:
                            MaterialStatePropertyAll(colorScheme.surfaceVariant),
                        shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        )),
                        hintText: 'Buscar',
                        side: const MaterialStatePropertyAll(BorderSide.none),
                        onTap: () => controller.openView(),
                        onChanged: (_) => controller.openView(),
                        leading: const Icon(Icons.search),
                      ),
                    ],
                  );
                },
                suggestionsBuilder: (context, controller) {
                  return <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                if (_filters.contains("Course")) {
                                  _filters = List.from(_filters.where((element) => element != "Course").toList());
                                } else {
                                  _filters = List.from(_filters + ["Course"]);
                                }
                              });
                            }, 
                            style: ElevatedButton.styleFrom(
                              backgroundColor: !_filters.contains('Course') ? colorScheme.surfaceVariant : colorScheme.primaryContainer,
                              textStyle: TextStyle(color: !_filters.contains('Course') ? colorScheme.onSurfaceVariant : colorScheme.onPrimaryContainer),
                            ),
                            child: const Text('Courses'),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                if (_filters.contains("Category")) {
                                  _filters = List.from(_filters.where((element) => element != "Category").toList());
                                } else {
                                  _filters = List.from(_filters + ["Category"]);
                                }
                              });
                            }, 
                            style: ElevatedButton.styleFrom(
                              backgroundColor: !_filters.contains('Category') ? colorScheme.surfaceVariant : colorScheme.errorContainer,
                              textStyle: TextStyle(color:  !_filters.contains('Category') ? colorScheme.onSurfaceVariant : colorScheme.onErrorContainer),
                            ),
                            child: const Text('Categories'),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                if (_filters.contains("User")) {
                                  _filters = List.from(_filters.where((element) => element != "User").toList());
                                } else {
                                  _filters = List.from(_filters + ["User"]);
                                }
                              });
                            }, 
                            style: ElevatedButton.styleFrom(
                              backgroundColor: !_filters.contains('User') ? colorScheme.surfaceVariant : colorScheme.tertiaryContainer,
                              textStyle: TextStyle(color:  !_filters.contains('User') ? colorScheme.onSurfaceVariant : colorScheme.onTertiaryContainer),
                            ),
                            child: const Text('Users'),
                          ),
                        ],
                      ),
                    ),
                  ]+_searchResultsFiltered.map((result) {

                    final Map<String, Widget> resultTiles = {
                      "Course": CourseResult(searchResult: result, onTap: () => print('Course Tap'),),
                      "Category": CategoryResult(searchResult: result, onTap: () => print('Category Tap'),),
                      "User": UserResult(searchResult: result, onTap: () => print('user Tap'),),
                    };
                    return resultTiles[result.post.type]!;
                  }).toList();
                },
              )
            ],
          )),
    );
  }
}
