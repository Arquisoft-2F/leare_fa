import 'package:flutter/material.dart';
import 'package:leare_fa/widgets/my_button.dart';
import 'package:leare_fa/widgets/my_textfield.dart';
import 'package:country_picker/country_picker.dart';
import 'package:leare_fa/widgets/widgets.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  RegisterPageState createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  // Credentials
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmController = TextEditingController();

  // Info
  final firstnameController = TextEditingController();
  final lastnameController = TextEditingController();
  final countryController = TextEditingController();
  final biographyController = TextEditingController();

  // Socials
  final facebookController = TextEditingController();
  final twitterController = TextEditingController();
  final linkedinController = TextEditingController();
  final websiteController = TextEditingController();

  String country = '';
  String currentSection = 'credentials';

  
  void registerUser() {
    // Implement registration logic here
    if (usernameController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        confirmController.text.isNotEmpty &&
        firstnameController.text.isNotEmpty &&
        lastnameController.text.isNotEmpty &&
        country.isNotEmpty) {
      print('User registered'); // [TODO] Implement registration logic
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, llena todos los campos requeridos (*)'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final registerSections = {
      'credentials': {
        'title': 'Crea una cuenta',
        'subtitle': 'Inicia un camino en el apredizaje',
        'form': RegisterCredentialsForm(controllers: {
          'username': usernameController,
          'email': emailController,
          'password': passwordController,
          'confirm': confirmController,
        }),
        'action': () {
          setState(() {
            currentSection = 'info';
          });
        },
      },
      'info': {
        'title': 'Cuentanos un poco más',
        'subtitle': 'Te queremos conocer mejor',
        'form': RegisterInfoForm(controllers: {
          'firstname': firstnameController,
          'lastname': lastnameController,
          'country': countryController,
          'bio': biographyController,
        }, onCountrySelect: (country) => setState(() {
          countryController.text = country.name;
          this.country = country.name;
        }),),
        'action': () {
          setState(() {
            currentSection = 'socials';
          });
        },
      },
      'socials': {
        'title': 'Cómo te podemos encontrar?',
        'subtitle': 'Conéctate con los demás',
        'form': RegisterSocialsForm(controllers: {
          'facebook': facebookController,
          'twitter': twitterController,
          'linkedin': linkedinController,
          'website': websiteController,
        },),
        'action': () {
          registerUser();
        },
      },
    };
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            if (currentSection == 'credentials') {
              Navigator.pop(context);
            } else {
              setState(() {
                currentSection = currentSection == 'socials' ? 'info' : 'credentials';
              });
            }
          },
        ),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(
              height: 100,
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 40.0,
                      left: 25.0,
                      right: 25.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          registerSections[currentSection]!['title'] as String,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          registerSections[currentSection]!['subtitle'] as String,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        Expanded(
                          child: Column(
                            children: [
                              registerSections[currentSection]!['form'] as Widget,
                              const SizedBox(height: 20.0),
                              ElevatedButton(
                                onPressed: registerSections[currentSection]!['action'] as void Function(),
                                style: ElevatedButton.styleFrom(
                                  minimumSize: const Size(double.infinity, 50),
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                                ),
                                child: Text(currentSection == 'socials' ? 'Registrarse' : 'Siguiente'),
                              )
                            ],
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Divider(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                              thickness: 1,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  "Ya tienes una cuenta?",
                                  style: TextStyle(color: Colors.black),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pushNamed(context, '/login');
                                  },
                                  child: Text(
                                    'Inicia Sesión',
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary),
                                  ),
                                )
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
