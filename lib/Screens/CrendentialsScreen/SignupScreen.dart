import 'package:app2/Screens/CrendentialsScreen/LoginSignUp.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Widgets/text.dart';


class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool _isLoginForm = true;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController   _confirmPasswordController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _passwordVisible = false;
  bool isLoginButtonPressed=false;
  bool isLoading=false;
  void _toggleForm() {
    setState(() {
      _isLoginForm = !_isLoginForm;
    });
  }

  void _togglePasswordVisibility() {
    setState(() {
      _passwordVisible = !_passwordVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    double w=MediaQuery.of(context).size.width;
    double h=MediaQuery.of(context).size.height;
    return Scaffold(

      body:isLoading?Center(child: CircularProgressIndicator(color: Colors.green,),): SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(w*0.05),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(height: h*0.1),
                FancyShimmerImage(height: h*0.1,
                  width: w,
                  boxDecoration: BoxDecoration(borderRadius: BorderRadius.circular(100)),
                  imageUrl: 'https://media.istockphoto.com/id/1040867898/photo/man-hand-holding-phone-with-isolated-screen-on-background-city.jpg?b=1&s=170667a&w=0&k=20&c=ZHTHuxdvMFdlRbg6KlNTgB2s_UloiZUap-ziBXWRZik=',
                ),
                SizedBox(height: h*0.1),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      TextFormField(
                        style: GoogleFonts.lato(
                          textStyle: TextStyle(color: Colors.grey[800], letterSpacing: .5,fontWeight: FontWeight.normal,fontSize: h*0.017),
                        ),
                        controller: _emailController,
                        decoration: InputDecoration(
                          label: text('Email', Colors.grey[800]!,FontWeight.normal, h*0.017),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20)
                          ),
                          enabledBorder:  OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.green,width: 1),
                              borderRadius: BorderRadius.circular(20)),
                          focusedBorder:   OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.green,width: 1.5),
                              borderRadius: BorderRadius.circular(20)),
                          prefixIcon: Icon(Icons.email,color: Colors.green,),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (!EmailValidator.validate(value.toString())) {
                            return 'Invalid Email';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: h*0.02),
                      TextFormField( style: GoogleFonts.lato(
                        textStyle: TextStyle(color: Colors.grey[800], letterSpacing: .5,fontWeight: FontWeight.normal,fontSize: h*0.017),
                      ),
                        controller: _confirmPasswordController,
                        obscureText: !_passwordVisible,
                        decoration: InputDecoration(
                          label: text('Confirm Password', Colors.grey[800]!,FontWeight.normal, h*0.017),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.green),
                              borderRadius: BorderRadius.circular(20)),
                          enabledBorder:  OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.green,width: 1),
                              borderRadius: BorderRadius.circular(20)),
                          focusedBorder:   OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.green,width: 1.5),
                              borderRadius: BorderRadius.circular(20)),
                          prefixIcon: Icon(Icons.lock,color: Colors.green),
                          suffixIcon: IconButton(
                            icon: Icon(color: Colors.green,
                              _passwordVisible
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: _togglePasswordVisibility,
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter a password';
                          }
                          else if(value!.toString()!=_passwordController.text.toString()){
                            return "Passwords do not match";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: h*0.02),
                      TextFormField( style: GoogleFonts.lato(
                        textStyle: TextStyle(color: Colors.grey[800], letterSpacing: .5,fontWeight: FontWeight.normal,fontSize: h*0.017),
                      ),
                        controller: _passwordController,
                        obscureText: !_passwordVisible,
                        decoration: InputDecoration(
                          label: text('Password', Colors.grey[800]!,FontWeight.normal, h*0.017),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.green),
                              borderRadius: BorderRadius.circular(20)),
                          enabledBorder:  OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.green,width: 1),
                              borderRadius: BorderRadius.circular(20)),
                          focusedBorder:   OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.green,width: 1.5),
                              borderRadius: BorderRadius.circular(20)),
                          prefixIcon: Icon(Icons.lock,color: Colors.green),


                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter a password';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: h*0.04),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                      minimumSize: Size(w,h*0.045),
                      side: BorderSide(color: Colors.green[800]!),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)
                      )
                  ),
                  child: text('Sign up', Colors.green, FontWeight.bold, h*0.018),

                  onPressed:isLoginButtonPressed?(){} :()async {
                    if (_formKey.currentState!.validate()) {
                      String email = _emailController.text;
                      String password = _passwordController.text;
                      //TODO: Implement authentication logic
                      setState(() {
                        isLoading=true;
                        isLoginButtonPressed=true;
                      });
                      try{

                        await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password).then((value)async {
                          try{
                            User? user=FirebaseAuth.instance.currentUser;
                            FirebaseFirestore.instance.collection('Admin').doc(user!.uid).set({
                              "Email": email,
                              "Password": password,
                              "Uid":user!.uid
                            }).then((value) {
                              Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>LoginSignupScreen()));
                            });
                          }
                          catch(e){
                            Fluttertoast.showToast(msg: e.toString());
                            setState(() {
                              isLoading=false;
                              isLoginButtonPressed=false;
                            });
                          }
                        });

                      }
                      catch(e){
                        Fluttertoast.showToast(msg: e.toString());
                      }
                    }
                    else{
                      setState(() {
                        isLoading=false;
                        isLoginButtonPressed=false;
                      });
                    }
                  },
                ),
                SizedBox(height: h*0.026),
                TextButton(
                  child: text("Already have an account? Sign in", Colors.grey[600]!, FontWeight.normal, h*0.016),

                  onPressed:(){ Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>LoginSignupScreen()));}
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }}
