import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:leare_fa/widgets/widgets.dart';

class TabsSection extends StatelessWidget {
  final String sectionName;
  final String content;
  final resources;
  const TabsSection(
      {super.key,
      required this.content,
      required this.resources,
      required this.sectionName});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: DefaultTabController(
        length: 2,
        child: Container(
          child: Column(
            children: [
              const TabBar(
                tabs: [
                  Tab(
                    child: Text('Contenido', style: TextStyle(fontSize: 17)),
                  ),
                  Tab(
                    child: Text('Recursos', style: TextStyle(fontSize: 17)),
                  ),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    ListView(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(sectionName,
                                  style: TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold)),
                              SizedBox(
                                height: 10,
                              ),
                              Text(content,
                                  textAlign: TextAlign.justify,
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.normal)),
                            ],
                          ),
                        )
                      ],
                    ),
                    ListView(
                        children: resources.map<ResourceCard>((resource) {
                      return ResourceCard(
                        resourceName: resource,
                      );
                    }).toList()),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
