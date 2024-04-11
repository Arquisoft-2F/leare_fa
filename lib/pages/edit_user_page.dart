import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:leare_fa/models/user_model.dart';
import 'package:leare_fa/utils/graphql_user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfilePage extends StatefulWidget {
  final String? profileUserId;
  const EditProfilePage({required this.profileUserId, super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();

}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nationalityController = TextEditingController();
  final TextEditingController _linkedinController = TextEditingController();
  final TextEditingController _twitterController = TextEditingController();
  final TextEditingController _facebookController = TextEditingController();
  final TextEditingController _webpageController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  late String? userId;
  late bool isEditingUser = false;
  late bool isEditingBio = false;
  late SharedPreferences prefs;
  late bool _isLoading = true;
  late UserModel user;
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
      String userId = jwtDecodedToken['UserID'];
      user = await _graphQLUser.userbyId(id: widget.profileUserId as String);
      setState(() {
        userId = userId;
        user = user;
        _isLoading = false;
         // Data is fetched, no longer loading
      });
    } catch (error) {
      // Handle error if fetching data fails
      print("Error fetching user data: $error");
      setState(() {
        userId = userId;
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
        title: const Text('Editar Perfil'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            Center(
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 60,
                    backgroundImage: AssetImage('assets/profile_picture.jpg'), // Imagen de perfil actual
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: () {
                      // Acción para editar imagen de perfil
                    },
                    child: const Text('Editar imagen de perfil'),
                  ),
                ],
              ),
            ),
            const Divider(),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Información de perfil',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    // Acción para editar información de perfil
                    setState(() {
                      isEditingUser = !isEditingUser;
                    });
                  }, 
                  icon: const Icon(Icons.edit),
              )
            ]),

            const SizedBox(height: 10),
            isEditingUser ? Column(
              children: [
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: user.name),
                ),
                TextField(
                  controller: _lastNameController,
                  decoration: InputDecoration(labelText: user.lastname),
                ),
                TextField(
                  controller: _nicknameController,
                  decoration: InputDecoration(labelText: user.nickname),
                ),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: user.email),
                ),
                TextField(
                  controller: _nationalityController,
                  decoration: InputDecoration(labelText: user.nationality),
                ),
                TextField(
                  controller: _linkedinController,
                  decoration: InputDecoration(labelText: user.linkedin_link),
                ),
                TextField(
                  controller: _twitterController,
                  decoration: InputDecoration(labelText: user.twitter_link),
                ),
                TextField(
                  controller: _facebookController,
                  decoration: InputDecoration(labelText: user.facebook_link),
                ),
                TextField(
                  controller: _webpageController,
                  decoration: InputDecoration(labelText: user.web_site),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    // Acción para guardar cambios
                    setState(() {
                      isEditingUser = false;
                    });
                  },
                  child: const Text('Guardar cambios'),
                ),
              ],
            ) : Column(
              children: [
            ProfileInfoItem(title: 'Nombre', value: user.name),
            ProfileInfoItem(title: 'Apellido', value: user.lastname),
            ProfileInfoItem(title: 'Nickname', value: user.nickname),
            ProfileInfoItem(title: 'Correo', value: user.email),
            ProfileInfoItem(title: 'Nacionalidad', value: user.nationality),
            ProfileInfoItem(title: 'LinkedIn', value: user.linkedin_link as String),
            ProfileInfoItem(title: 'Twitter', value: user.twitter_link as String),
            ProfileInfoItem(title: 'Facebook', value: user.facebook_link as String),
            ProfileInfoItem(title: 'Pagina Web', value: user.web_site as String),
            ]),
            const SizedBox(height: 10),

            const Divider(),
            const SizedBox(height: 10),
              Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Biografia',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      isEditingBio = !isEditingBio;
                    });
                  }, 
                  icon: const Icon(Icons.edit),
              )
            ]),
            const SizedBox(height: 10),
            isEditingBio ? Column(
              children: [
              TextField(
              controller: _bioController,
              maxLines: null, // Allows unlimited lines
              decoration: InputDecoration(
                hintText: user.biography,
                border: const OutlineInputBorder(),
              )),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    // Acción para guardar cambios
                    setState(() {
                      isEditingBio = false;
                    });
                  },
                  child: const Text('Guardar cambios'),
                ),
              ],
            ) : Column(
              children: [
                Text(
                  user.biography as String),
              ]),
            const SizedBox(height: 10),
            const Divider(),
            const SizedBox(height: 10),
            const Text(
              'Opciones de cuenta',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Acción para cambiar contraseña
              },
              child: const Text('Cambiar contraseña'),
            ),
            ElevatedButton(
              onPressed: () {
                // Acción para eliminar cuenta
              },
              child: const Text('Eliminar cuenta', style: TextStyle(color: Colors.red),
            ),
        )],
        ),
      ),
    );
  }
}
}

class ProfileInfoItem extends StatelessWidget {
  final String title;
  final String value;

  const ProfileInfoItem({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
          Text(
            value,
            style: const TextStyle(color: Colors.grey),
          ),
      ],
    );
  }
}
