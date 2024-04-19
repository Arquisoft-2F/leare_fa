import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:leare_fa/models/user_model.dart';
import 'package:leare_fa/utils/graphql_user.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'edit_user_page.dart';

class UserArguments {
  final String profileId;
  UserArguments(this.profileId);
}

class UserProfilePage extends StatefulWidget {
  final String? profileId;
  const UserProfilePage({super.key, this.profileId});
  
  @override
  UserProfilePageState createState() => UserProfilePageState();
}

class UserProfilePageState extends State<UserProfilePage> {
  late SharedPreferences prefs;
  late bool _isLoading = true;
  var args;
  late UserModel user;
  late String userId;
  final GraphQLUser _graphQLUser = GraphQLUser();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      setState(() {
          args = (ModalRoute.of(context)?.settings.arguments ??
              UserArguments('')) as UserArguments;
        });
      var profileId = args.profileId;
      if ( profileId != null ){
        fetchUserData();
      }
    });
  }

  void fetchUserData() async {
    try {
      prefs = await SharedPreferences.getInstance();
      Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(prefs.getString('token') as String);
      String userID = jwtDecodedToken['UserID'];
      user = await _graphQLUser.userbyId(id: args.profileId as String);
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
              user.picture_id != 'n/a' && user.picture_id != 'NotFound' ?
              CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(user.picture_id as String), 
              ) 
              :
              const CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage('https://static.vecteezy.com/system/resources/thumbnails/009/292/244/small/default-avatar-icon-of-social-media-user-vector.jpg'), 
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
                    icon: const FaIcon(FontAwesomeIcons.linkedin),
                    onPressed: () async {
                        await Clipboard.setData(ClipboardData(text: user.linkedin_link!));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Enlace de LinkedIn copiado al portapapeles'),
                          ),
                        );
                    },
                  ),
                  IconButton(
                    icon: const FaIcon(FontAwesomeIcons.facebook),
                    onPressed: () async {
                          await Clipboard.setData(ClipboardData(text: user.facebook_link!));
                          ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Enlace de Facebook copiado al portapapeles'),
                          ),
                        );
                    },
                  ),
                  IconButton(
                    icon: const FaIcon(FontAwesomeIcons.twitter),
                    onPressed: () async {
                          await Clipboard.setData(ClipboardData(text: user.twitter_link!));
                          ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Enlace de Twitter copiado al portapapeles'),
                          ),
                        );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.language),
                    onPressed: () async {
                          await Clipboard.setData(ClipboardData(text: user.web_site!));
                          ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Enlace de Sitio Web copiado al portapapeles'),
                          ),
                        );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  args.profileId == userId ? 
                  Row(children: [
                    ElevatedButton(
                      onPressed: () async {
                      var res = await Navigator.pushNamed(context, '/editProfile', arguments: EditUserArguments(args.profileId)) as bool?;
                      if (res!=null && res){
                        setState(() {
                          fetchUserData();
                        });
                      }
                      },
                    child: const Text('Editar'),
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
