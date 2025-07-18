import 'package:flutter/material.dart';
import 'common/common_text_field.dart';
import 'home_page.dart';
import 'package:google_fonts/google_fonts.dart';

// LogIn Page
class LogInPage extends StatefulWidget {
  const LogInPage({super.key}); // Constructor with key parameter

  // Creates state for Log in page
  @override
  State<LogInPage> createState() => _LogInPageState();
}

// State class
class _LogInPageState extends State<LogInPage> {
  // Loading status to show progress indicator while logging in
  bool isLoading = false;

  // LogInPage's UI
  @override
  Widget build(BuildContext context) {
    // Input field controllers
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController emailController = TextEditingController();

    return Scaffold(
      body: SingleChildScrollView(
        // Allow scrolling the page
        child: Container(
          padding: const EdgeInsets.all(15),
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Space before the logo
              const SizedBox(height: 100),

              // Displays logo
              Image.network(
                "https://upload.wikimedia.org/wikipedia/commons/thumb/d/dc/Google_DeepMind_logo.svg/1024px-Google_DeepMind_logo.svg.png?20231107121229",
                width: 300,
                height: 100,
              ),
              const SizedBox(height: 30), // Space after logo

              // Displays application name
              Text(
                "AlphaLife Edu",
                style: GoogleFonts.lato(
                  // Custom font
                  textStyle: TextStyle(
                    color: Colors.blueAccent
                        .withOpacity(1.0), // Color with opacity
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 80), // Space before input text fields

              // Email input field
              CommonTextField(
                controller: emailController, // Controller for the input
                hintText: 'Enter your email',
                labelText: 'Email',
                keyboardType: TextInputType.emailAddress,
                prefixIconData: Icons.email,
                textInputAction:
                    TextInputAction.next, // Action button for next input
              ),
              const SizedBox(height: 20), // Space before next input field

              // Password input field
              CommonTextField(
                controller: passwordController, // Controller for the input
                hintText: 'Enter your password',
                labelText: 'Password',
                prefixIconData: Icons.password,
                obscureText: true, // Enable user to hide the password
                textInputAction:
                    TextInputAction.next, // Action button for next input
              ),
              const SizedBox(height: 32), // Space before the log in button

              // Log in button with loading indicator
              SizedBox(
                width: double.infinity, // Full width
                height: 50,
                child: FilledButton(
                  onPressed: () {
                    // Check if email or pw is empty
                    if (emailController.text.isEmpty ||
                        passwordController.text.isEmpty) {
                      // Show snack bar to indicate user the fields are empty
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Please enter email and password'),
                      ));
                      return; // Do not proceed log in if the fields are empty
                    }

                    // Set loading status true
                    setState(() {
                      isLoading = true;
                    });

                    // Simulating a delay for login process
                    Future.delayed(const Duration(milliseconds: 1000), () {
                      // Navigate to HomePage after delay
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HomePage()));

                      // Reset loading status
                      setState(() {
                        isLoading = false;
                      });
                    });
                  },

                  // Display loading indicator or button text
                  child: isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 4,
                            color: Colors.white30,
                          ),
                        )
                      : const Text('LOG IN'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
