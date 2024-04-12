import 'package:flutter/material.dart';

import '../../models/models.dart';

class Results extends StatelessWidget {
  final SearchModel searchResult;
  const Results({super.key, required this.searchResult});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text(searchResult.post.name),
          subtitle: Text(searchResult.post.type == 'Category' ? searchResult.post.description! : ''),
          leading: CircleAvatar(
            backgroundImage: NetworkImage(searchResult.post.picture!),
          ),
        ),
        const Divider(),
      ]);
  }
}