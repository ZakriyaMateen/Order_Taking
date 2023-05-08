import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../Providers/Userp.dart';
import '../../Widgets/text.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isHidden = true;

  void _toggleVisibility() {
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    double w = mediaQuery.size.width;
     double h = mediaQuery.size.height;
    return ChangeNotifierProvider(
      create: (context) => AuthProvider(),
      child: Scaffold(
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: w*0.05, vertical: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Email",
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                  focusedBorder:OutlineInputBorder(
                    borderRadius: BorderRadius.circular(28),
                    borderSide: BorderSide(color: Colors.green),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(28),
                    borderSide: BorderSide(color: Colors.green),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Consumer<AuthProvider>(
                builder: (context, value,_) {
                 return TextFormField(
                    obscureText: value.isObscure,
                    decoration: InputDecoration(
                        labelText: "Password",
                        labelStyle: GoogleFonts.lato(
                          textStyle: TextStyle(color: Colors.green, letterSpacing: .5,fontWeight: FontWeight.normal,fontSize: h*0.017),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(28),
                          borderSide: BorderSide(color: Colors.green),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(28),
                          borderSide: BorderSide(color: Colors.green),
                        ),
                        suffixIcon: IconButton(
                            icon: value .isObscure
                            ? Icon(Icons.visibility_off,color: Colors.green[800],)
                            : Icon(Icons.visibility,color: Colors.green[800]),
                    onPressed: (){
                      value.toggleObscure();
                    },
                  ),
                  ),
                  );
                },),
              SizedBox(height: 50),
              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(side: BorderSide(color: Colors.green,width: 1.1),shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18),),minimumSize: Size(w,h*0.045)),
                child:text('Login',Colors.green[800]!, FontWeight.bold, h*0.017)
                ),
            ],
          ),
        ),
      ),
    );
  }
}
