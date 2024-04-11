import 'package:flutter/material.dart';
import 'package:leare_fa/pages/pages.dart';

class NavScreen extends StatelessWidget {
  const NavScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> routes = [
      '/home',
      '/search',
      '/chats',
      '/profile/me',
    ];

    final Map<String, Widget?> pages = {
      '/home': const Center(child: Text('Home Page')),
      '/search': const SearchPage(),
      '/chats': const ChatsPage(),
      '/profile/me': null,
    };

    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Image(
              width: 30,
              image: AssetImage('assets/leare.png'),
            ),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.search,
              size: 30.0,
            ),
            label: 'Buscar',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.chat,
              size: 30.0,
            ),
            label: 'Chats',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
              size: 30.0,
            ),
            label: 'Perfil',
          ),
        ],
        currentIndex: routes.indexOf(ModalRoute.of(context)!.settings.name!),
        onTap: (index) => Navigator.pushNamed(context, routes[index]),
      ),
      body: pages[ModalRoute.of(context)!.settings.name!],
    );
  }
}
