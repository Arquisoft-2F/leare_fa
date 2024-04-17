import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: CarouselSlider(
          items: const [1, 2, 3, 4].map((e) {
            return Container(
            width: MediaQuery.of(context).size.width * 0.8,
            margin: const EdgeInsets.symmetric(horizontal: 3.0),
            decoration: const BoxDecoration(
              color: Colors.lightBlue,
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            ),
            child: Center(child: Text('Hello $e')),
          );}).toList(),
          options: CarouselOptions(
            aspectRatio: 16/9,
            initialPage: 0,
            scrollDirection: Axis.horizontal,
            enableInfiniteScroll: false,
            reverse: false,
            animateToClosest: true,
          ) ),
      ),
    );
  }
}