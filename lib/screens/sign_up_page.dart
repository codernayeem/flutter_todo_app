import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_todo_app/services/auth_services.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwdController = TextEditingController();

  final TextEditingController _nameController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  AuthClass authClass = AuthClass();
  var loading = false;

  @override
  void initState() {
    super.initState();
    _auth.authStateChanges().listen((user) {
      if (user != null) {
        Navigator.of(context).pop();
      }
    });
  }

  void emailSignUp() async {
    if (loading) return;
    String email = _emailController.text.trim();
    String password = _pwdController.text.trim();
    String name = _nameController.text.trim();

    if (email.isEmpty) {
      showSnackBar("Email can't be empty");
      return;
    } else if (password.isEmpty) {
      showSnackBar("Password can't be empty");
      return;
    } else if (name.isEmpty) {
      showSnackBar("Name can't be empty");
      return;
    } else if (name.length <= 2) {
      showSnackBar("Name should be consists of two or more letters");
      return;
    }

    setState(() {
      loading = true;
    });

    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await userCredential.user?.updateDisplayName(name);
    } catch (e) {
      showSnackBar(e.toString());
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  void emailSignIn() async {
    if (loading) return;
    String email = _emailController.text.trim();
    String password = _pwdController.text.trim();

    if (email.isEmpty) {
      showSnackBar("Email can't be empty");
      return;
    } else if (password.isEmpty) {
      showSnackBar("Password can't be empty");
      return;
    }

    setState(() {
      loading = true;
    });

    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      showSnackBar(e.toString());
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  void mobileSignIn() {
    Navigator.pushNamed(context, 'phoneAuth');
  }

  void googleSignIn() {
    authClass.handleGoogleSignIn();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(
            Icons.arrow_back,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              const Text(
                "Sign In",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              ),
              const SizedBox(height: 16),
              customButton(
                context,
                "Continue with Google",
                SvgPicture.asset(
                  "assets/google.svg",
                  height: 30,
                  width: 30,
                ),
                googleSignIn,
                false,
              ),
              const SizedBox(height: 16),
              customButton(
                context,
                "Continue with phone",
                SvgPicture.asset(
                  "assets/phone.svg",
                  height: 30,
                  width: 30,
                ),
                mobileSignIn,
                false,
              ),
              const SizedBox(height: 18),
              const Text(
                "or",
                style: TextStyle(fontSize: 16),
              ),
              DefaultTabController(
                length: 2,
                child: Column(
                  children: [
                    const TabBar(
                      tabs: [
                        Tab(text: 'Sign In'),
                        Tab(text: 'Sign Up'),
                      ],
                    ),
                    SizedBox(
                      height: 400,
                      child: TabBarView(
                        children: [
                          signInPageUI(context),
                          signUpPageUI(context),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Column signInPageUI(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        textFormFeild(context, "Email", Icons.email, false, _emailController),
        const SizedBox(height: 16),
        textFormFeild(context, "Password", Icons.lock, true, _pwdController),
        const SizedBox(height: 24),
        customButton(
            context, "Sign In", const Icon(Icons.login), emailSignIn, loading),
        const SizedBox(height: 10),
      ],
    );
  }

  Column signUpPageUI(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        textFormFeild(context, "Email", Icons.email, false, _emailController),
        const SizedBox(height: 16),
        textFormFeild(context, "Password", Icons.lock, true, _pwdController),
        const SizedBox(height: 16),
        textFormFeild(context, "Name", Icons.person, false, _nameController),
        const SizedBox(height: 24),
        customButton(
            context, "Sign Up", const Icon(Icons.login), emailSignUp, loading),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget customButton(
    BuildContext context,
    String text,
    Widget icon,
    void Function() onPress,
    bool pogressBar,
  ) {
    return SizedBox(
      width: MediaQuery.of(context).size.width - 60,
      height: 60,
      child: OutlinedButton(
        onPressed: onPress,
        child: pogressBar
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  icon,
                  const SizedBox(width: 10),
                  Text(
                    text,
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
      ),
    );
  }

  Widget textFormFeild(
    BuildContext context,
    String hint,
    IconData icon,
    bool obscureText,
    TextEditingController _controller,
  ) {
    return SizedBox(
      width: MediaQuery.of(context).size.width - 60,
      height: 55,
      child: TextFormField(
        controller: _controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          label: Text(
            hint,
            style: const TextStyle(fontSize: 17),
          ),
          border: const OutlineInputBorder(),
          icon: Icon(
            icon,
          ),
        ),
      ),
    );
  }

  void showSnackBar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      duration: const Duration(seconds: 2),
      action: SnackBarAction(
        label: 'Close',
        onPressed: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
      ),
    ));
  }
}
