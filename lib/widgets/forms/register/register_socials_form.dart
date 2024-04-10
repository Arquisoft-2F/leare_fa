import 'package:flutter/material.dart';

class RegisterSocialsForm extends StatefulWidget {
  final Map<String, TextEditingController> controllers;
  const RegisterSocialsForm({super.key, required this.controllers});

  @override
  State<RegisterSocialsForm> createState() => _RegisterSocialsFormState();
}

class _RegisterSocialsFormState extends State<RegisterSocialsForm> {
  final _formKey = GlobalKey<FormState>();

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
                Text('Website',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    )),
                const SizedBox(
                  height: 10.0,
                ),
                TextField(
                  controller: widget.controllers['website'],
                  enableSuggestions: true,
                  keyboardType: TextInputType.url,
                  decoration: const InputDecoration(
                    hintText: 'Ingresa tu Sitio Web',
                    prefixIcon: Icon(Icons.language),
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
                Text('LinkedIn',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    )),
                const SizedBox(
                  height: 10.0,
                ),
                TextField(
                  controller: widget.controllers['linkedin'],
                  enableSuggestions: true,
                  keyboardType: TextInputType.url,
                  decoration: const InputDecoration(
                    hintText: 'Ingresa tu LinkedIn',
                    prefixIcon: Icon(Icons.work),
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
                Text('Facebook',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    )),
                const SizedBox(
                  height: 10.0,
                ),
                TextField(
                  controller: widget.controllers['facebook'],
                  enableSuggestions: true,
                  keyboardType: TextInputType.url,
                  decoration: const InputDecoration(
                    hintText: 'Ingresa tu Facebook',
                    prefixIcon: Icon(Icons.facebook),
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
                Text('Twitter',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    )),
                const SizedBox(
                  height: 10.0,
                ),
                TextField(
                  controller: widget.controllers['twitter'],
                  enableSuggestions: true,
                  keyboardType: TextInputType.url,
                  decoration: const InputDecoration(
                    hintText: 'Ingresa tu X',
                    prefixIcon: Icon(Icons.work),
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
        ],
      ),
    );
  }
}
