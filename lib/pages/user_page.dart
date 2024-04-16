import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:leare_fa/models/user_model.dart';
import 'package:leare_fa/utils/graphql_user.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'edit_user_page.dart';

class UserProfilePage extends StatefulWidget {
  final String? profileUserId;
  const UserProfilePage({required this.profileUserId, super.key});
  
  @override
  UserProfilePageState createState() => UserProfilePageState();
}

class UserProfilePageState extends State<UserProfilePage> {
  late SharedPreferences prefs;
  late bool _isLoading = true;
  late UserModel user;
  late String userId;
  final GraphQLUser _graphQLUser = GraphQLUser();
  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  void fetchUserData() async {
    try {
      prefs = await SharedPreferences.getInstance();
      Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(prefs.getString('token') as String);
      String userID = jwtDecodedToken['UserID'];
      user = await _graphQLUser.userbyId(id: widget.profileUserId as String);
      setState(() {
        userId = userID;
        user = user;
        _isLoading = false; // Data is fetched, no longer loading
      });
    } catch (error) {
      // Handle error if fetching data fails
      print("Error fetching user data: $error");
      setState(() {
        user = user;
        _isLoading = false; // Loading indicator should be turned off even in case of error
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    else{
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              const CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('assets/profile_picture.jpg'), 
              ),
              const SizedBox(height: 10),
              Text(
                '${user.name} ${user.lastname}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(user.nickname),
                  const SizedBox(width: 10),
                  const Text('|'),
                  const SizedBox(width: 10),
                  Text(user.nationality),
                ],
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.work),
                    onPressed: () {
                      // Abrir LinkedIn
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.facebook),
                    onPressed: () {
                      // Abrir Facebook
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.media_bluetooth_off),
                    onPressed: () {
                      // Abrir Twitter
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.language),
                    onPressed: () {
                      // Abrir página web
                    },
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  widget.profileUserId == userId ? 
                  Row(children: [
                    ElevatedButton(
                      onPressed: () async {
                      var res = await Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfilePage(profileUserId: widget.profileUserId,)));
                      if (res!=null && res){
                        setState(() {
                          fetchUserData();
                        });
                      }
                      },
                    child: const Text('Editar'),
                  ),
                    ElevatedButton(
                    onPressed: () {
                      
                    },
                    child: const Text('Compartir'),
                  ),
                  ],
                  ):
                  ElevatedButton(
                    onPressed: () {
                      // Acción para compartir perfil
                    },
                    child: const Text('Compartir'),
                  ),
                ],
              ),
              const SizedBox(height: 10),
                SizedBox(
                width: MediaQuery.of(context).size.width * 0.8, // Ajusta el ancho del Divider según el ancho de la pantalla
                child: const Divider(),
              ),
              const SizedBox(height: 10),
              const Text(
                'Biografía',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                user.biography != null ? user.biography as String : 'Sin biografía',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
                SizedBox(
                width: MediaQuery.of(context).size.width * 0.8, // Ajusta el ancho del Divider según el ancho de la pantalla
                child: const Divider(),
              ),
              const SizedBox(height: 10),
              const Text(
                'Mis Cursos',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),

            ],
          ),
        ),
      ),
    );
    }
  }
}
