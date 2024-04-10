import 'package:flutter/material.dart';

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
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
            const Text(
              'Información de perfil',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const ProfileInfoItem(title: 'Nombre', value: 'Sebastian'),
            const ProfileInfoItem(title: 'Apellido', value: 'Perra'),
            const ProfileInfoItem(title: 'Correo', value: 'jsarmiento@gmail.com'),
            // Agrega más ProfileInfoItem según los datos del perfil
            const Divider(),
            const SizedBox(height: 10),
            const Text(
              'Biografía',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            // Widget para la biografía editable
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
        TextButton(
          onPressed: () {
            // Acción para editar el campo de perfil
          },
          child: Text(
            value,
            style: const TextStyle(color: Colors.blue),
          ),
        ),
      ],
    );
  }
}
