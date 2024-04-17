
import 'package:flutter/material.dart';
import 'package:leare_fa/models/user_model.dart';
import 'package:leare_fa/utils/graphql_register.dart';
import 'package:leare_fa/widgets/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  final roleController = TextEditingController();

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

  late UserModel user;
  late SharedPreferences prefs;

  String country = '';
  String currentSection = 'credentials';

  @override
  void initState(){
    super.initState();
    initSharedPref();
    setState(() {
        roleController.text = '1';
    });
  }

  void initSharedPref() async {
    prefs = await SharedPreferences.getInstance();
  }

  Future<void> registerUser() async {
    // Implement registration logic here
    if (usernameController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        confirmController.text.isNotEmpty &&
        firstnameController.text.isNotEmpty &&
        lastnameController.text.isNotEmpty &&
        country.isNotEmpty && roleController.text.isNotEmpty) {
      
      user = UserModel(
        id: '',
        nickname: usernameController.text,
        email: emailController.text,
        name: firstnameController.text,
        lastname: lastnameController.text,
        nationality: country,
        biography: biographyController.text,
        facebook_link: facebookController.text,
        twitter_link: twitterController.text,
        linkedin_link: linkedinController.text,
        web_site: websiteController.text,
      );

       var res = await GraphQLRegister().createUser(
        userModel: user,
        password: passwordController.text,
        confirmPassword: confirmController.text,
        role: roleController.text,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Usuario registrado exitosamente'),
        ),
      );
      prefs.setString('token', res);
      Navigator.pushNamed(context, '/home');
        
    
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
          'role': roleController,
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
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
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
          SliverToBoxAdapter(
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
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
                    Column(
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
                        ),
                        const SizedBox(height: 20.0),
                      ],
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
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
