import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/core/notifier/authenticaation.notifier.dart';
import 'package:quiz_app/meta/view/authentication/signup.view.dart';
import 'package:video_player/video_player.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController =
      TextEditingController(); // Added password controller
  TextEditingController otpController =
      TextEditingController(); // Added OTP controller
  late VideoPlayerController controller;
  late Future<void> initializeVideoPlayerFuture;
  Timer? timer;
  Timer? pauseTimer;
  bool isLoading = false;
  bool isOtpsent = false;

  @override
  void initState() {
    super.initState();
    controller = VideoPlayerController.networkUrl(
      Uri.parse(
        'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
      ),
    );

    initializeVideoPlayerFuture = controller.initialize().then((_) {
      controller.setLooping(false);
      controller.setVolume(10);
      controller.play();

      // Pause the video after 5 seconds
      pauseTimer = Timer(const Duration(seconds: 5), () {
        if (mounted && controller.value.isPlaying) {
          setState(() {
            controller.pause();
          });
        }
      });

      setState(() {});
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
  void dispose() {
    emailController.dispose();
    otpController.dispose();
    passwordController.dispose(); // Dispose password controller
    controller.dispose();
    pauseTimer?.cancel(); // Cancel the timer to avoid memory leaks
    super.dispose();
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
                        color: Colors.grey.withAlpha((0.5 * 255).toInt()),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset('assets/images/keylogo.png', height: 65),
                          const SizedBox(height: 12),
                          const Text(
                            'LOGIN',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 15),
                          TextFormField(
                            controller: emailController,
                            decoration: const InputDecoration(
                              labelText: 'Email or Phone Number',
                              border: UnderlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: passwordController,
                            obscureText: true, // Hide password input
                            decoration: const InputDecoration(
                              labelText: 'Password',
                              border: UnderlineInputBorder(),
                            ),
                          ),
                          if (isOtpsent) ...[
                            const SizedBox(height: 20),
                            TextField(
                              controller: otpController,
                              decoration: const InputDecoration(
                                labelText: 'OTP',
                                labelStyle: TextStyle(color: Colors.white),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.blue),
                                ),
                              ),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ],
                          const SizedBox(height: 10),
                          MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: InkWell(
                              child: const Text(
                                "Forgot Password?",
                                style: TextStyle(color: Colors.blue),
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) =>
                                            const ForgotPasswordScreen(),
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 5),
                          MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: InkWell(
                              child: const Text(
                                "Need HELP? Contact us",
                                style: TextStyle(color: Colors.blue),
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => const ContactUsScreen(),
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 5),
                          MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: InkWell(
                              child: const Text(
                                "Create Account? Signup",
                                style: TextStyle(color: Colors.blue),
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const SignUpScreen(),
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
                              String email = emailController.text;
                              String password = passwordController.text;

                              if (email.isNotEmpty && password.isNotEmpty) {
                                await authenticationNotifier.signup(
                                  email: email,
                                  password: password,
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Please fill in all fields'),
                                  ),
                                );
                              }
                              // Add your desired navigation or functionality here
                              ('Next button pressed');
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
            ],
          ),
        ),
      ),
    );
  }
}

class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Contact Us')),
      body: const Center(child: Text('Contact Us Screen')),
    );
  }
}

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Forgot Password')),
      body: const Center(child: Text('Forgot Password Screen')),
    );
  }
}
