import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:leare_fa/pages/category_page.dart';
import 'package:leare_fa/pages/create_course_page.dart';
import 'package:leare_fa/pages/create_section_page.dart';
import 'package:leare_fa/pages/create_section_page.dart';
import 'package:leare_fa/pages/edit_section_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:universal_io/io.dart';
import 'pages/pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  runApp(MyApp(token: prefs.getString('token')));
}

class MyApp extends StatelessWidget {
  final String? token;

  const MyApp({required this.token, super.key});

  @override
  Widget build(BuildContext context) {
    final HttpLink httpLink = HttpLink('https://35.215.4.97/graphql');
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
          home: (token == null)
              ? const LandingPage()
              : (JwtDecoder.isExpired(token!))
                  ? const LandingPage()
                  : const NavScreen(),
          routes: {
            '/login': (context) => const LoginPage(),
            '/register': (context) => const RegisterPage(),
            '/home': (context) => const NavScreen(),
            '/search': (context) => const NavScreen(),
            '/chat': (context) => const ChatPage(),
            '/chats': (context) => const NavScreen(),
            '/profile': (context) => const NavScreen(),
            '/editProfile': (context) => const EditProfilePage(),
            '/category': (context) => const CategoryPage(),
            '/course': (context) => const CoursePage(),
            '/createCourse': (context) => CreateCoursePage(),
            '/editCourse': (context) => const EditCoursePage(),
            '/section': (context) => const SectionPage(),
            '/createSection': (context) => const CreateSectionPage(),
            '/editSection': (context) => const EditSectionPage(),
          },
        ));
  }
}
