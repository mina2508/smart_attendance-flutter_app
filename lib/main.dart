
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_attendance_app/firstscreen.dart';

import 'APIS/NodeAPIS.dart';
import 'AllTabs.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:  FirstScreen(),
    );
  }
}

class LogIn extends StatefulWidget {
  const LogIn({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<LogIn> createState() => _MyLogInPageState();
}

class _MyLogInPageState extends State<LogIn> {
  TextEditingController? _emailController;
  TextEditingController? _passwordController;
  GlobalKey<FormState>? _formKey;
  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _formKey = GlobalKey();

  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Transparent Login App',
      home: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: SizedBox(
            width: double.infinity,
            child: Stack(
              children: [
                Positioned(
                  top: 200,
                  left: -100,
                  child: Container(
                    width: 300,
                    height: 300,
                    decoration: const BoxDecoration(
                      color: Color(0x304599ff),
                      borderRadius: BorderRadius.all(
                        Radius.circular(150),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 10,
                  right: -10,
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: const BoxDecoration(
                      color: Color(0x30cc33ff),
                      borderRadius: BorderRadius.all(
                        Radius.circular(100),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: 80,
                      sigmaY: 80,
                    ),
                    child: Container(),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child:
                        Form(
                            key: _formKey,
                            child: Column(
                     children: [
                        const SizedBox(
                          height: 50,
                        ),
                        _logo(),
                        const SizedBox(
                          height: 70,
                        ),
                        _loginLabel(),
                        const SizedBox(
                          height: 70,
                        ),
                        _labelTextInput("Email", "yourname@example.com", false,_emailController ),
                        const SizedBox(
                          height: 50,
                        ),
                        _labelTextInput("Password", "yourpassword", true,_passwordController),
                        const SizedBox(
                          height: 90,
                        ),
                       _loginBtn(_emailController, _passwordController, _formKey, context)
                     ],
                   )
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  @override
  void dispose() {
    // TODO: implement
    _emailController?.dispose();
    _passwordController?.dispose();
    super.dispose();
  }
}
void goToHome(BuildContext context,String Email,String Password) async{
  FocusManager.instance.primaryFocus?.unfocus();
bool registered=  await (APIHelper().authenticateAdmin(Email,Password));
if(registered){
  Navigator.pushAndRemoveUntil(context,
    MaterialPageRoute(
        builder: (context)=>  MyHome()
    ),(Route<dynamic> route) => false, );
}
else{
  showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Alert'),
        content: Text('Email or Password May Be Wrong'),
        actions: [

          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Ok')),
        ],
      ));
}
}


Widget _loginBtn(TextEditingController? _sentEmailController,TextEditingController? _sentPasswordController,GlobalKey<FormState>? _sentFormKey,BuildContext context) {
  String email;
  String password;
  return Container(
    width: double.infinity,
    height: 60,
    decoration: const BoxDecoration(
      color: Color(0xff008fff),
      borderRadius: BorderRadius.all(Radius.circular(10)),
    ),
    child: ElevatedButton(
      onPressed: () => {
      if (_sentFormKey!.currentState!.validate()) {
        goToHome(context,_sentEmailController!.value.text,_sentPasswordController!.value.text)
        //print(_sentEmailController!.value.text)
      }
      },
      child: Text(
        "Login",
        style: GoogleFonts.josefinSans(
          textStyle: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: 24,
          ),
        ),
      ),
    ),
  );
}

Widget _labelTextInput(String label, String hintText, bool isPassword,TextEditingController? inputController) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: GoogleFonts.josefinSans(
          textStyle: const TextStyle(
            color: Color(0xff8fa1b6),
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
      ),
      TextFormField(
        controller:inputController,
        validator: (value) {
          if(isPassword){
            if (value!.isEmpty) {

              return 'Password is required';

            }

            return null;
          }
          else{
            if (value!.isEmpty) {
              return 'Email is required';
            }

            return null;
          }
        }

       ,
        obscureText: isPassword,
        cursorColor: Colors.red,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: GoogleFonts.josefinSans(
            textStyle: const TextStyle(
              color: Color(0xffc5d2e1),
              fontWeight: FontWeight.w400,
              fontSize: 20,
            ),
          ),

          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xffdfe8f3)),
          ),
        ),
      ),
    ],
  );
}

Widget _loginLabel() {
  return Center(
    child: Text(
      "Login",
      style: GoogleFonts.josefinSans(
        textStyle: const TextStyle(
          color: Color(0xff164276),
          fontWeight: FontWeight.w900,
          fontSize: 34,
        ),
      ),
    ),
  );
}

Widget _logo() {
  return Center(
    child: SizedBox(
      child: Image.asset('assets/images/kyan.png'),
      height: 80,
    ),
  );

  }

