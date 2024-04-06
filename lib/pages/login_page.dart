
import 'package:flutter/material.dart';
import 'package:leare_fa/components/my_button.dart';
import 'package:leare_fa/components/my_textfield.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  // text editing controllers
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  // sign user in method
  void signUserIn() {

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 47, 72, 88),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 25),

              // logo
              const Image(
                image: AssetImage('assets/leare.png'),
                width: 150,
                ),

              const SizedBox(height: 50),

              const Text(
                'Inicia sesión para descubrir más',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 25),

              // username textfield
              MyTextField(
                controller: usernameController,
                hintText: 'Username',
                obscureText: false,
                size: 20,
              ),

              const SizedBox(height: 10),

              // password textfield
              MyTextField(
                controller: passwordController,
                hintText: 'Contraseña',
                obscureText: true,
                size: 20,
              ),
        

              const SizedBox(height: 20),

              MyButton(
                onTap: () => Navigator.pushNamed(context, '/home'),
                text: 'Iniciar Sesión',
                size: 25,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
