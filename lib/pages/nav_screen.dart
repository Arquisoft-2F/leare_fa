import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:leare_fa/pages/home_page.dart';
import 'package:leare_fa/pages/pages.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NavScreen extends StatelessWidget {
  const NavScreen({super.key});


  @override
  Widget build(BuildContext context) {
    final List<String> routes = [
      '/home',
      '/search',
      '/chats',
    ];

    final Map<String, Widget?> pages = {
      '/home': const HomePage(),
      '/search': const SearchPage(),
      '/chats': const ChatsPage(),
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
        onTap: (index) async { 
            if (index == 3) {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(prefs.getString('token') as String);
              String userID = jwtDecodedToken['UserID'];
              Navigator.push(context, MaterialPageRoute(builder: (context) => UserProfilePage(profileUserId: userID)));
            }
            else {
              Navigator.pushNamed(context, routes[index]);
            }

          },
      ),
      body: pages[ModalRoute.of(context)!.settings.name!],
    );
  }
}
