import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:leare_fa/models/user_model.dart';
import 'package:leare_fa/pages/pages.dart';
import 'package:leare_fa/utils/graphql_delete_user.dart';
import 'package:leare_fa/utils/graphql_edit_password.dart';
import 'package:leare_fa/utils/graphql_edit_user.dart';
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
  final TextEditingController _oldpasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();

  late String? userId;
  late bool isEditingUser = false;
  late bool isEditingBio = false;
  late bool isChangingPassword = false;
  late SharedPreferences prefs;
  late bool _isLoading = true;
  late UserModel user;
  final GraphQLUser _graphQLUser = GraphQLUser();
  final GraphQLEditUser _graphQLEditUser = GraphQLEditUser();
  final GraphQLEditPassword _graphQLEditPassword = GraphQLEditPassword();
  final GraphQLDeleteUser _graphQLDeleteUser = GraphQLDeleteUser();

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

       _nameController.text = user.name;
       _lastNameController.text = user.lastname;
       _nicknameController.text = user.nickname;
       _emailController.text = user.email;
       _nationalityController.text = user.nationality;
       _linkedinController.text = user.linkedin_link as String;
       _twitterController.text = user.twitter_link as String;
       _facebookController.text = user.facebook_link as String;
       _webpageController.text = user.web_site as String;
       _bioController.text = user.biography as String;

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

  void _showDeleteAccountConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Eliminar cuenta"),
          content: const Text("¿Estás seguro que deseas eliminar tu cuenta? Esta acción no se puede deshacer."),
          actions: [
            TextButton(
              onPressed: () async {
                await _graphQLDeleteUser.deleteMe();
                await prefs.clear();
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LandingPage())); // Close the dialog
              },
              child: const Text("Eliminar"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text("Cancelar"),
            ),
          ],
        );
      },
    );
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
            Navigator.pop(context, true);
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
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: "Nombre"),
                ),
                TextFormField(
                  controller: _lastNameController,
                  decoration: const InputDecoration(labelText: "Apellido"),
                ),
                TextFormField(
                  controller: _nicknameController,
                  decoration: const InputDecoration(labelText: "Username"),
                ),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: "Username"),
                ),
                TextFormField(
                  controller: _nationalityController,
                  decoration: const InputDecoration(labelText: "Nacionalidad"),
                ),
                TextFormField(
                  controller: _linkedinController,
                  decoration: const InputDecoration(labelText: "LinkedIn"),
                ),
                TextFormField(
                  controller: _twitterController,
                  decoration: const InputDecoration(labelText: "Twitter"),
                ),
                TextFormField(
                  controller: _facebookController,
                  decoration: const InputDecoration(labelText: "Facebook"),
                ),
                TextFormField(
                  controller: _webpageController,
                  decoration: const InputDecoration(labelText: "Pagina Web"),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      isEditingUser = false;
                      user.name = _nameController.text;
                      user.lastname = _lastNameController.text;
                      user.nickname = _nicknameController.text;
                      user.email = _emailController.text;
                      user.nationality = _nationalityController.text;
                      user.linkedin_link = _linkedinController.text;
                      user.twitter_link = _twitterController.text;
                      user.facebook_link = _facebookController.text;
                      user.web_site = _webpageController.text;
                      user.updated_at = DateTime.now().toString();
                    });
                    await _graphQLEditUser.updateMe(userModel: user);
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
              decoration: const InputDecoration(
                hintText: 'Biografía',
                border: OutlineInputBorder(),
              )),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () async {
                    // Acción para guardar cambios
                    setState(() {
                      isEditingBio = false;
                      user.biography = _bioController.text;
                      user.updated_at = DateTime.now().toString();
                    });
                    await _graphQLEditUser.updateMe(userModel: user);
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
        setState(() {
          isChangingPassword = !isChangingPassword; // Toggle the value
        });
      },
      child: const Text('Cambiar contraseña'),
    ),

          if (isChangingPassword) // Conditionally display the password fields
            Column(
              children: [
                const SizedBox(height: 10),
                const Divider(),
                TextFormField(
                  controller: _oldpasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: "Contraseña actual"),
                ),
                TextFormField(
                  controller: _newPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: "Nueva contraseña"),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () async {
                    // Acción para cambiar contraseña
                    setState(() {
                      isChangingPassword = false;
                    });
                    String res = await _graphQLEditPassword.changePassword(
                      oldPassword: _oldpasswordController.text,
                      newPassword: _newPasswordController.text,
                      id: widget.profileUserId as String);
                    if (res == 'true') {
                      ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Contraseña cambiada con éxito'),
                        ),
                      );
                    }
                    else {
                      ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Error al cambiar contraseña'),
                        ),
                      );
                    }
                  },
                  child: const Text('Confirmar cambio de contraseña'),
                ),
                const SizedBox(height: 10),
                const Divider(),
              ],
            ),

            ElevatedButton(
              onPressed: () {
                _showDeleteAccountConfirmationDialog();
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
