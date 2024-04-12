import 'package:flutter/material.dart';

class ResourceCard extends StatelessWidget {
  final String resourceName;
  const ResourceCard({super.key, required this.resourceName});

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color(0xffd3e4ff),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(7),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          resourceName,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.normal),
                        ),
                        const Icon(Icons.file_download)
                      ]),
                ))));
  }
}
