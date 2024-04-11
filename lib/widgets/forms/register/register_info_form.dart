import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';

class RegisterInfoForm extends StatefulWidget {
  final Map<String, TextEditingController> controllers;
  final void Function(Country country) onCountrySelect;
  const RegisterInfoForm(
      {super.key, required this.controllers, required this.onCountrySelect});

  @override
  State<RegisterInfoForm> createState() => _RegisterInfoFormState();
}

class _RegisterInfoFormState extends State<RegisterInfoForm> {
  final _formKey = GlobalKey<FormState>();
  String country = '';

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
                Text('Nombres*',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    )),
                const SizedBox(
                  height: 10.0,
                ),
                TextField(
                  controller: widget.controllers['firstname'],
                  enableSuggestions: true,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    hintText: 'Ingresa tus nombres',
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
                Text('Apellidos*',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    )),
                const SizedBox(
                  height: 10.0,
                ),
                TextField(
                  controller: widget.controllers['lastname'],
                  enableSuggestions: true,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    hintText: 'Ingresa tus apellidos',
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
                Text('Biografía',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    )),
                const SizedBox(
                  height: 10.0,
                ),
                TextField(
                  controller: widget.controllers['bio'],
                  enableSuggestions: true,
                  keyboardType: TextInputType.multiline,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    hintText: 'Ingresa tu biografía',
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
                Text('Nacionalidad*',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    )),
                const SizedBox(
                  height: 10.0,
                ),
                TextField(
                  readOnly: true,
                  onTap: () {
                    showCountryPicker(
                      context: context,
                      showPhoneCode: false,
                      onSelect: (Country country) => widget.onCountrySelect(country),
                    );
                  },
                  controller: widget.controllers['country'],
                  decoration: const InputDecoration(
                    hintText: 'País',
                    contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12.0)),
                    ),
                    suffixIcon: Icon(Icons.arrow_drop_down),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
