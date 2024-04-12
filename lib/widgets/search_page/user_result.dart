import 'dart:math';

import 'package:flutter/material.dart';

import '../../models/models.dart';

class UserResult extends StatelessWidget {
  final SearchModel searchResult;
  final void Function()? onTap;
  const UserResult({super.key, required this.searchResult, this.onTap});

  @override
  Widget build(BuildContext context) {
    final fullname = '${searchResult.post.name} ${searchResult.post.lastname!}';
    final a = fullname.length;
    return ListTile(
      title: Text(searchResult.post.nickname!),
      subtitle: Text('${fullname.substring(0, min(a, 20))} ${a > 20 ? '...' : ''}'),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(searchResult.post.picture!),
      ),
      onTap: onTap,
    );
  }
}