import 'package:flutter/material.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});
  
  @override
  UserProfilePageState createState() => UserProfilePageState();
}

class UserProfilePageState extends State<UserProfilePage> {
  @override
  Widget build(BuildContext context) {
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
              const Text(
                'Nombre de Usuario',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Username'),
                  SizedBox(width: 10),
                  Text('|'),
                  SizedBox(width: 10),
                  Text('Nacionalidad'),
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
                  ElevatedButton(
                    onPressed: () {
                      // Acción para editar perfil
                    },
                    child: const Text('Editar'),
                  ),
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
              const Text(
                'Una descripción bien aspera mi rey',
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
