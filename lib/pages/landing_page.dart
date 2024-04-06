import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  LandingPageState createState() => LandingPageState();
}

class LandingPageState extends State<LandingPage> {
  late VideoPlayerController _controller;
  
  @override
  void initState(){
    super.initState();
    _controller = VideoPlayerController.asset('assets/landing.mp4')
      ..initialize().then((_) {
        setState(() {
          _controller.play();
          _controller.setLooping(true);
        });
      });
    // Check if user is already logged in
    // If user is logged in, navigate to home page
    // else, stay on landing page
    // if (userIsLoggedIn) {
    //   Navigator.pushNamed(context, '/home');
    //}
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image
          FittedBox(
            fit: BoxFit.cover,
            child: SizedBox(
              width: _controller.value.size.width,
              height: _controller.value.size.height,
              child: VideoPlayer(_controller),
            ),
          ),
          Container(
            color: Colors.black.withOpacity(0.5),
          ),
          
          const Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 50),
              Image(
                image: AssetImage('assets/leare.png'),
                width: 150,
              ),
              SizedBox(height: 50),
              Text(
                'Bienvenido a Leare',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'El mejor lugar para aprender y crecer',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Spacer(),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/login');
                },
                child: const Text('Iniciar Sesión', style: TextStyle(color: Color.fromARGB(255, 0, 145, 255)),),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Aún no tienes cuenta?", style: TextStyle(color: Colors.white),),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/register');
                    },
                    child: const Text('Regístrate', style: TextStyle(color: Color.fromARGB(255, 0, 145, 255)),
                  ),
              )],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ],
      ),
    );
  }
}
