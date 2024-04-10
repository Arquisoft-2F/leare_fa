import 'package:flutter/material.dart';
import 'package:leare_fa/models/login_model.dart';
import 'package:leare_fa/utils/graphql_login.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final GraphQLLogin _graphQLLogin = GraphQLLogin();
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Ingrese su email o nickname',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      )),
                  const SizedBox(
                    height: 10.0,
                  ),
                  TextField(
                    controller: usernameController,
                    enableSuggestions: true,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      hintText: 'Email o nickname',
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Ingrese su contraseña',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      )),
                  const SizedBox(
                    height: 10.0,
                  ),
                  TextField(
                    controller: passwordController,
                    obscureText: _obscurePassword,
                    enableSuggestions: true,
                    autocorrect: false,
                    // change height of the textfield

                    decoration: InputDecoration(
                        hintText: 'Contraseña',
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 10),
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12.0)),
                        ),
                        suffix: IconButton(
                          icon: _obscurePassword
                              ? const Icon(Icons.visibility_off)
                              : const Icon(Icons.visibility),
                          onPressed: () {
                            // change the state of the textfield
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        )),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (usernameController.text.isEmpty ||
                    passwordController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Por favor, complete todos los campos'),
                    ),
                  );
                } else {
                  LoginModel loginRequest = await _graphQLLogin.login(
                      email: usernameController.text,
                      password: passwordController.text);
                  if (loginRequest.flag == "true") {
                    Navigator.pushNamed(context, '/home');
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Usuario o contraseña incorrectos'),
                      ),
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
              child: const Text('Iniciar Sesión'),
            )
          ],
        ));
  }
}
