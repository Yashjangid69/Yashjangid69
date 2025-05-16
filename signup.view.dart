import 'dart:async';
import 'package:flutter/material.dart';
import 'package:quiz_app/core/notifier/authenticaation.notifier.dart';
import 'package:quiz_app/core/service/authentication.service.dart';
import 'package:quiz_app/meta/view/authentication/login.view.dart';
import 'package:supabase/supabase.dart';
import 'package:video_player/video_player.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  late VideoPlayerController controller;
  late Future<void> initializeVideoPlayerFuture;
  Timer? pauseTimer;
  bool isLoading = false;
  bool isOtpsent = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController =
      TextEditingController(); // Added password controller

  final formKEY = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose(); // Dispose password controller
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    controller = VideoPlayerController.networkUrl(
      Uri.parse(
        'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
      ),
    );

    initializeVideoPlayerFuture = controller.initialize().then((_) {
      if (mounted) {
        setState(() {
          controller.setLooping(false);
          controller.setVolume(10);
          controller.play();
        });

        pauseTimer = Timer(const Duration(seconds: 5), () {
          if (mounted && controller.value.isPlaying) {
            setState(() {
              controller.pause();
            });
          }
        });
      }
    });

    controller.addListener(() {
      if (mounted && controller.value.position == controller.value.duration) {
        setState(() {
          controller.pause();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    const boxWidth = 500.0;
    const boxHeight =
        400.0; // Increased height to accommodate the password field

    return Scaffold(
      backgroundColor: const Color(0xFF001B3A),
      body: Center(
        child: SizedBox(
          width: screenWidth,
          height: screenHeight,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                bottom: screenHeight - 400,
                child: FutureBuilder(
                  future: initializeVideoPlayerFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return AspectRatio(
                        aspectRatio: controller.value.aspectRatio,
                        child: VideoPlayer(controller),
                      );
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ),
              Positioned(
                bottom: 150,
                child: Container(
                  width: boxWidth,
                  height: boxHeight,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.all(Radius.circular(4)),
                    boxShadow: [
                      BoxShadow(
                        // ignore: deprecated_member_use
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(24.0),
                  child: Form(
                    key: formKEY,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.asset('assets/images/signup.png', height: 90),
                            const SizedBox(height: 12),
                            const Text(
                              'SIGN UP',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 15),
                            TextFormField(
                              controller: emailController,
                              validator: emailValidation,
                              decoration: const InputDecoration(
                                labelText: 'Email or Phone Number',
                                border: UnderlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: passwordController,
                              validator: emptyValidation,
                              obscureText: true, // Hide password input
                              decoration: const InputDecoration(
                                labelText: 'Create Password',
                                border: UnderlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: 10),
                            MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: InkWell(
                                child: const Text(
                                  "Need HELP? Contact us",
                                  style: TextStyle(color: Colors.blue),
                                ),
                                onTap: () {
                                  // Add your contact us navigation logic here
                                },
                              ),
                            ),
                            const SizedBox(height: 5),
                            MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: InkWell(
                                child: const Text(
                                  "Already have Account? Login",
                                  style: TextStyle(color: Colors.blue),
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const LoginView(),
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 6),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              onPressed: () async {
                                if (formKEY.currentState!.validate()) {
                                  AuthServices.client();

                                  final client = AuthServices.client();
                                  final AuthResponse res = await client.auth
                                      .signUp(
                                        email: emailController.text,
                                        password: passwordController.text,
                                      );

                                  if (res.user != null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Sign up successful!'),
                                      ),
                                    );
                                  }
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF001B3A),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(1),
                                ),
                              ),
                              child: const Text(
                                'Next',
                                style: TextStyle(color: Colors.white),
                              ),
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
        ),
      ),
    );
  }
}
