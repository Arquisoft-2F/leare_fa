import 'package:flutter/material.dart';
import 'package:leare_fa/models/feed_model.dart';

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
  var args;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      setState(() {
        args = (ModalRoute.of(context)?.settings.arguments ?? CategoryArguments(null)) as CategoryArguments;
      });
      print(args.category);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(args != null ? args.category?.name : 'Categorías'),
      ),
      body: Center(
        child: Text(args != null ? 'Categorías ${ args.category?.name ?? 'No hay categoría seleccionada'}' : 'Categorías'),
      ),
    );
  }
}