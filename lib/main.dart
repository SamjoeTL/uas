import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter_pagination/HomePage.dart';
import 'auth_service.dart';
import 'package:flutter_pagination/dto/users.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Pagination',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(),
        '/home': (context) => HomePage(
          token: ModalRoute.of(context)!.settings.arguments as String,
        ),
      },
    );
  }
}


class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _isLoading = false;

  void _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      try {
        UserDTO user = await _authService.login(
          _emailController.text,
          _passwordController.text,
        );
        // Handle successful login
        print('Login successful: ${user.token}');
        // Navigate to homepage and pass the token
        Navigator.pushReplacementNamed(context, '/home', arguments: user.token);
      } catch (e) {
        // Handle login failure
        print('Login failed: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login failed: $e')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios, size: 20, color: Colors.black,),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      FadeInUp(duration: Duration(milliseconds: 1000), child: Text("Login", style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold
                      ),)),
                      SizedBox(height: 20,),
                      FadeInUp(duration: Duration(milliseconds: 1200), child: Text("Login to your account", style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey[700]
                      ),)),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          FadeInUp(duration: Duration(milliseconds: 1200), child: makeInput(label: "Email", controller: _emailController)),
                          FadeInUp(duration: Duration(milliseconds: 1300), child: makeInput(label: "Password", obscureText: true, controller: _passwordController)),
                        ],
                      ),
                    ),
                  ),
                  FadeInUp(duration: Duration(milliseconds: 1400), child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    child: Container(
                      padding: EdgeInsets.only(top: 3, left: 3),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        border: Border(
                          bottom: BorderSide(color: Colors.black),
                          top: BorderSide(color: Colors.black),
                          left: BorderSide(color: Colors.black),
                          right: BorderSide(color: Colors.black),
                        )
                      ),
                      child: MaterialButton(
                        minWidth: double.infinity,
                        height: 60,
                        onPressed: _login,
                        color: Colors.greenAccent,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)
                        ),
                        child: _isLoading 
                            ? CircularProgressIndicator(color: Colors.white)
                            : Text("Login", style: TextStyle(
                                fontWeight: FontWeight.w600, 
                                fontSize: 18
                              ),),
                      ),
                    ),
                  )),
                   FadeInUp(duration: Duration(milliseconds: 1500), child: Row(
                     mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("Don't have an account?"),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/signup');
                        },
                        child: Text(
                          " Sign up",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  )),
                ],
              ),
            ),
            FadeInUp(
              duration: Duration(milliseconds: 1600),
              child: Container(
                height: MediaQuery.of(context).size.height / 3,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/background.png"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget makeInput({label, obscureText = false, required TextEditingController controller}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: Colors.black87,
          ),
        ),
        SizedBox(
          height: 5,
        ),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter $label';
            }
            return null;
          },
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade400),
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade400),
            ),
          ),
        ),
        SizedBox(
          height: 30,
        ),
      ],
    );
  }
}