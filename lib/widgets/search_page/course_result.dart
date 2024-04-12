import 'dart:math';

import 'package:flutter/material.dart';

import '../../models/models.dart';

class CourseResult extends StatelessWidget {
  final SearchModel searchResult;
  final void Function()? onTap;
  const CourseResult({super.key, required this.searchResult, this.onTap});

  @override
  Widget build(BuildContext context) {
    final a = searchResult.post.description!.length;
    return ListTile(
      title: Text(searchResult.post.name),
      subtitle: Text('${searchResult.post.description!.substring(0, max(a, 20))} ${a > 20 ? '...' : ''}'),
      leading: Container(
        width: 50.0,
        height: 50.0,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(searchResult.post.picture!),
            fit: BoxFit.cover,
          ),
          color: Theme.of(context).colorScheme.secondary.withOpacity(0.6),
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      onTap: onTap,
    );
  }
}