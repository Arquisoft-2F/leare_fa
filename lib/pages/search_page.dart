import 'package:flutter/material.dart';
import 'package:leare_fa/models/search_model.dart';
import 'package:leare_fa/utils/graphql_search.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<SearchModel> _searchResults = [];
  final GraphQLSearch _graphQLSearch = GraphQLSearch();

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
                  print(value);
                  if (value.isNotEmpty) {
                    await _graphQLSearch.search(q: value).then((results) {
                      setState(() {
                        _searchResults = results;
                      });
                    });
                  }
                },
                builder: (context, controller) {
                  return SearchBar(
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
                    leading: const Icon(Icons.search),
                  );
                },
                suggestionsBuilder: (context, controller) {
                  return _searchResults.map((result) {
                    return ListTile(
                      title: Text(result.post.name),
                      onTap: () {
                        controller.clear();
                        // Navigate to search result page
                      },
                    );
                  }).toList();
                },
              )
            ],
          )),
    );
  }
}
