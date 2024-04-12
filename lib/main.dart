import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:leare_fa/pages/chat_page.dart';
import 'package:leare_fa/pages/edit_user_page.dart';
import 'package:leare_fa/pages/user_page.dart';
import 'package:leare_fa/widgets/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'pages/pages.dart';



void main() async 
{
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  runApp(MyApp(token: prefs.getString('token')));
}

class MyApp extends StatelessWidget {
  final String? token;

  const MyApp({
    required this.token,
    super.key
    });
  
  @override
  Widget build(BuildContext context) {
    final String? userID = JwtDecoder.decode(token as String)['UserID'];
    final HttpLink httpLink = HttpLink('http://35.215.20.21:5555/graphql');
    final ValueNotifier<GraphQLClient> client = ValueNotifier<GraphQLClient>(
      GraphQLClient(
        cache: GraphQLCache(),
        link: httpLink,
      ),
    );

    return GraphQLProvider(
        client: client,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
                seedColor: const Color.fromARGB(255, 4, 58, 102),
                secondary: const Color.fromARGB(255, 98, 204, 252)),
            useMaterial3: true,
          ),
          home: const LandingPage(),
          routes: {
            '/login': (context) => const LoginPage(),
            '/register': (context) => const RegisterPage(),
            '/home': (context) => const NavScreen(),
            '/search': (context) => const SearchPage(),
            // '/chat': (context) => const ChatPage(),
            '/chats': (context) => const ChatsPage(),
            '/profile/me': (context) => UserProfilePage(profileUserId: userID),
            '/course': (context) => const CoursePage()
          },
        ));
  }
}
