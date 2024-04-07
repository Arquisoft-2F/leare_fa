import 'package:flutter/material.dart';
import 'package:leare_fa/widgets/my_button.dart';
import 'package:leare_fa/widgets/my_textfield.dart';
import 'package:country_picker/country_picker.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  RegisterPageState createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  final firstnameController = TextEditingController();
  final lastnameController = TextEditingController();
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmController = TextEditingController();
  final countryController = TextEditingController();
  String country = '';
  
  void registerUser() {
    // Implement registration logic here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 47, 72, 88),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 25),

                // Logo
                const Image(
                  image: AssetImage('assets/leare.png'),
                  width: 110,
                ),

                const SizedBox(height: 50),

                MyTextField(
                  controller: firstnameController,
                  hintText: 'Nombre',
                  obscureText: false,
                  size: 10,
                ),

                const SizedBox(height: 10),
                
                MyTextField(
                  controller: lastnameController,
                  hintText: 'Apellido',
                  obscureText: false,
                  size: 10,
                ),

                const SizedBox(height: 10),

                MyTextField(
                  controller: usernameController,
                  hintText: 'Username',
                  obscureText: false,
                  size: 10,
                ),


                const SizedBox(height: 10),
                MyTextField(
                  controller: emailController,
                  hintText: 'Email',
                  obscureText: false,
                  size: 10,
                ),

                const SizedBox(height: 10),
                

                // Password textfield
                MyTextField(
                  controller: passwordController,
                  hintText: 'Contraseña',
                  obscureText: true,
                  size: 10,
                ),

                const SizedBox(height: 10),

                // Confirm Password textfield (if needed)
                MyTextField(
                  controller: confirmController,
                  hintText: 'Confirmar Contraseña',
                  obscureText: true,
                  size: 10,
                ),

                const SizedBox(height: 10),
                // Email textfield (if needed)

                GestureDetector(
                  onTap: () {
                    showCountryPicker(
                      context: context,
                      showPhoneCode: false,
                      onSelect: (Country country) {
                        setState(() {
                          countryController.text = country.name;
                          this.country = country.name;
                        });
                      },
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.symmetric(horizontal: 25),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Text(
                          country.isEmpty ? 'País' : country,
                          style: TextStyle(
                            color: country.isEmpty ? Colors.grey[500] : Colors.black,
                            fontSize: 16,
                          ),
                        ),
                        const Spacer(),
                        const Icon(Icons.arrow_drop_down),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Register Button
                MyButton(
                  text: 'Registrar',
                  onTap: registerUser,
                  size: 10,
                ),

                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Ya tiene una cuenta? ',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // Navigate to login page
                        Navigator.pushNamed(context, '/login');
                      },
                      child: const Text(
                        'Inicia sesión',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 16,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
