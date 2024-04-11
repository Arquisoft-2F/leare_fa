import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:leare_fa/widgets/section/section_video.dart';

class SectionPage extends StatefulWidget {
  const SectionPage({super.key});

  @override
  State<SectionPage> createState() => _SectionPageState();
}

class _SectionPageState extends State<SectionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              Stack(
                children: [
                  SectionVideo(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ImageFiltered(
                          imageFilter: ImageFilter.blur(),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50)),
                            child: IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: const Icon(
                                  Icons.arrow_back_ios_new_outlined,
                                  color: Color.fromRGBO(255, 255, 255, 1.0),
                                  size: 35,
                                )),
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.fullscreen,
                                  color: Color.fromRGBO(255, 255, 255, 1.0),
                                  size: 40,
                                )),
                            IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.more_vert,
                                  color: Color.fromRGBO(255, 255, 255, 1.0),
                                  size: 40,
                                )),
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
              Container(
                width: double.infinity, // Set width to fill the available space
                // Set height as needed
                // Container background color for visualization
                child: Row(
                  children: [
                    Expanded(
                        child: ElevatedButton(
                            style: ButtonStyle(
                                shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.zero,
                              ),
                            )),
                            onPressed: () {},
                            child: Text('Contenido'))),
                    Expanded(
                        child: ElevatedButton(
                            style: ButtonStyle(
                                shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.zero,
                              ),
                            )),
                            onPressed: () {},
                            child: Text('Recursos'))),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
