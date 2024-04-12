import 'package:flutter/material.dart';

class RegisterCredentialsForm extends StatefulWidget {
  final Map<String, TextEditingController> controllers;
  const RegisterCredentialsForm({super.key, required this.controllers});

  @override
  State<RegisterCredentialsForm> createState() => _RegisterCredentialsFormState();
}

class _RegisterCredentialsFormState extends State<RegisterCredentialsForm> {
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Correo*',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      )),
                  const SizedBox(
                    height: 10.0,
                  ),
                  TextField(
                    controller: widget.controllers['email'],
                    enableSuggestions: true,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      hintText: 'Ingresa tu correo',
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
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Nickname*',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      )),
                  const SizedBox(
                    height: 10.0,
                  ),
                  TextField(
                    controller: widget.controllers['username'],
                    enableSuggestions: true,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      hintText: 'Ingresa tu nickname',
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
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Ingresa tu contraseña*',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      )),
                  const SizedBox(
                    height: 10.0,
                  ),
                  TextField(
                    controller: widget.controllers['password'],
                    obscureText: _obscurePassword,
                    enableSuggestions: true,
                    autocorrect: false,
                    // change height of the textfield

                    decoration: InputDecoration(
                        hintText: 'Ingresa tu contraseña',
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Repite tu contraseña*',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      )),
                  const SizedBox(
                    height: 10.0,
                  ),
                  TextField(
                    controller: widget.controllers['confirm'],
                    obscureText: _obscureConfirm,
                    enableSuggestions: true,
                    autocorrect: false,
                    // change height of the textfield

                    decoration: InputDecoration(
                        hintText: 'Repite tu contraseña',
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 10),
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12.0)),
                        ),
                        suffix: IconButton(
                          icon: _obscureConfirm
                              ? const Icon(Icons.visibility_off)
                              : const Icon(Icons.visibility),
                          onPressed: () {
                            // change the state of the textfield
                            setState(() {
                              _obscureConfirm = !_obscureConfirm;
                            });
                          },
                        )),
                  ),
                ],
              ),
            ),
Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Tipo de Usuario*',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  )),
                const SizedBox(
                  height: 10.0,
                ),
                DropdownButtonFormField<String>(
                  value: widget.controllers['role']?.text,
                  items: const [
                    DropdownMenuItem(
                      value: '1',
                      child: Text('Estudiante'),
                    ),
                    DropdownMenuItem(
                      value: '2',
                      child: Text('Profesor'),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      widget.controllers['role']?.text = value!;
                    });
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12.0)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}