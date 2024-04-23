import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:leare_fa/pages/home_page.dart';
import 'package:leare_fa/pages/pages.dart';
import 'package:leare_fa/widgets/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NavScreen extends StatelessWidget {
  const NavScreen({super.key});


  @override
  Widget build(BuildContext context) {
    final List<String> routes = [
      '/chats',
      '/home',
      '/profile'
    ];

    final Map<String, Widget?> pages = {
      '/chats': const ChatsPage(),
      '/home': const HomePage(),
      '/profile': const UserProfilePage(),
    };

    print(routes.contains(ModalRoute.of(context)!.settings.name!));

    return Scaffold(
      bottomNavigationBar: SafeArea(
        child: Container(
          height: 80.0,
          alignment: Alignment.center,
          margin: EdgeInsets.only(
            left: MediaQuery.of(context).size.width * (Responsive.isMobile(context) ? 0.08 : Responsive.isTablet(context) ? 0.2 : 0.3),
            right: MediaQuery.of(context).size.width * (Responsive.isMobile(context) ? 0.08 : Responsive.isTablet(context) ? 0.2 : 0.3), 
            bottom: 10.0),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(30.0),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                spreadRadius: 1.0,
                blurRadius: 10.0,
              ),
            ],
          ),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.chat,
                  size: 30.0,
                ),
                label: 'Chats',
              ),
              BottomNavigationBarItem(
                icon: Image(
                  width: 30,
                  image: AssetImage('assets/leare.png'),
                ),
                label: 'Inicio',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.person,
                  size: 30.0,
                ),
                label: 'Perfil',
              ),
            ],
            currentIndex: routes.contains(ModalRoute.of(context)!.settings.name!) ? routes.indexOf(ModalRoute.of(context)!.settings.name!) : 1,
            onTap: (index) async { 
                if (index == 2) {
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(prefs.getString('token') as String);
                  String userID = jwtDecodedToken['UserID'];
                  print(userID);
                  Navigator.pushNamed(context, '/profile', arguments: UserArguments(userID));
                }
                else {
                  Navigator.pushNamed(context, routes[index]);
                }
          
              },
          ),
        ),
      ),
      body: pages[ModalRoute.of(context)!.settings.name!] ?? const HomePage(),
    );
  }
}
