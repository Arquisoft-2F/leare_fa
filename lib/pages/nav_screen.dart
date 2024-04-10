import 'package:flutter/material.dart';
import 'package:leare_fa/pages/pages.dart';

class NavScreen extends StatelessWidget {
  const NavScreen({super.key});


  @override
  Widget build(BuildContext context) {
    final List<String> routes = [
      '/search',
      '/home',
      '/profile',
    ];

    final Map<String, Widget?> pages = {
      '/search' : const SearchPage(),
      '/home': const Center( child: Text('Home Page')),
      '/profile': null,
    };

    return  Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.search, size: 30.0,),
            label: 'Buscar',
          ),
          BottomNavigationBarItem(
            icon: Image(
              width: 30,
              image: AssetImage('assets/leare.png'),
            ),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, size: 30.0,),
            label: 'Perfil',
          ),
        ],
        currentIndex: routes.indexOf(ModalRoute.of(context)!.settings.name!),
        onTap: (index) => Navigator.pushNamed(context, routes[index]),
      ) ,
      body: pages[ModalRoute.of(context)!.settings.name!],
    );
  }
}