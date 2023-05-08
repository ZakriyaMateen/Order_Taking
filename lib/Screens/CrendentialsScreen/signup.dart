// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:email_validator/email_validator.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebaseproject/signup.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:google_fonts/google_fonts.dart';
// class login extends StatefulWidget {
//   const login({Key? key}) : super(key: key);
//
//   @override
//   State<login> createState() => loginState();
// }
//
// class loginState extends State<login> {
//   bool isLoading = false;
//
//   @override
//   Widget build(BuildContext context) {
//     final _formkey = GlobalKey<FormState>();
//     TextEditingController email = TextEditingController();
//     TextEditingController password = TextEditingController();
//     double w = MediaQuery.of(context).size.width;
//     double h = MediaQuery.of(context).size.height;
//
//     return Scaffold(
//
//       body:isLoading ? Center(
//         child: CircularProgressIndicator(),
//       ) :
//       Container(
//         decoration: BoxDecoration(
//             gradient: LinearGradient(
//                 colors: [Colors.black, Colors.blue[900]!,],
//                 begin: Alignment.topCenter,
//                 end: Alignment.bottomCenter
//             )
//         ),
//         child: Padding(
//
//           padding: EdgeInsets.symmetric(horizontal: w*0.05),
//           child: Form(
//             key: _formkey,
//             child: Column(
//               children: [
//                 SizedBox(height: h*0.06),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Container(
//                       padding: EdgeInsets.all(5),
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(100),
//                         color: Colors.white,
//
//                       ),
//                       child: CircleAvatar(
//                         radius: h*0.05,
//                         backgroundImage: NetworkImage('https://images.unsplash.com/photo-1681489194036-8d0c672ef89a?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHwyOHx8fGVufDB8fHx8&auto=format&fit=crop&w=500&q=60'),
//                       ),
//                     ),
//                     SizedBox(width: w*0.07,),
//                   ],
//                 ),
//                 SizedBox(height: h*0.09,),
//                 Row(
//                   children: [
//                     Text(
//                       'SIGN UP',
//                       style: GoogleFonts.aboreto(
//                         textStyle:  TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: h*0.034),
//                       ),
//                     ),                ],
//                 ),
//                 Row(
//                   children: [
//                     Text(
//                       'Please Register',
//                       style: GoogleFonts.aboreto(
//                         textStyle:  TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: h*0.024),
//                       ),
//                     ),                ],
//                 ),
//                 SizedBox(height: h*0.09,),
//                 TextFormField(
//                   controller: email,
//                   validator: (value)
//                   {
//                     if (EmailValidator.validate(value.toString())){
//                       return null;
//                     }
//                     else{
//                       return "Invalid Email";
//                     }
//                   },
//                   style:  GoogleFonts.aboreto(
//                     textStyle:  TextStyle(color: Colors.yellow[800]!, fontWeight: FontWeight.normal,),
//                   ),
//                   decoration: InputDecoration(
//                     enabledBorder:OutlineInputBorder(
//                       borderSide: BorderSide(color: Colors.white,width: 2),
//                       borderRadius: BorderRadius.circular(50),
//                     ) ,
//                     focusedBorder: OutlineInputBorder(
//                       borderSide: BorderSide(color: Colors.yellow[800]!,width: 2),
//                       borderRadius: BorderRadius.circular(50),
//                     ) ,
//                     suffixIcon: Icon(Icons.person, color: Colors.yellow[800],),
//                     hintText: 'Email',
//
//                     hintStyle:   GoogleFonts.aboreto(
//                       textStyle:  TextStyle(color: Colors.yellow[800]!, fontWeight: FontWeight.normal,),
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: h*0.04,),
//                 TextFormField(
//                   controller: password,
//                   validator: (val){
//                     return val!.length < 1? 'please enter your password' : null;
//                   },
//                   style:  GoogleFonts.aboreto(
//                     textStyle:  TextStyle(color: Colors.yellow[800]!, fontWeight: FontWeight.normal,),
//                   ),
//                   decoration: InputDecoration(
//                     enabledBorder:OutlineInputBorder(
//                       borderSide: BorderSide(color: Colors.white,width: 2),
//                       borderRadius: BorderRadius.circular(50),
//                     ) ,
//                     focusedBorder: OutlineInputBorder(
//                       borderSide: BorderSide(color: Colors.yellow[800]!,width: 2),
//                       borderRadius: BorderRadius.circular(50),
//                     ) ,
//                     suffixIcon: Icon(Icons.key, color: Colors.yellow[800],),
//                     hintText: 'Password',
//
//                     hintStyle:   GoogleFonts.aboreto(
//                       textStyle:  TextStyle(color: Colors.yellow[800]!, fontWeight: FontWeight.normal,),
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: h*0.025,),
//
//                 SizedBox(height: h*0.07,),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     TextButton(onPressed: () {
//                       Navigator.of(context).push(MaterialPageRoute(builder:(context)=>homePage()));
//                     }, child: Text(
//                       'Login',
//                       style: GoogleFonts.aboreto(
//                         textStyle:  TextStyle(color: Colors.yellow[800], fontWeight: FontWeight.bold, fontSize: h*0.02,decoration: TextDecoration.underline),
//                       ),
//                     ),),
//                     InkWell(
//                       onTap: () async {
//                         if (_formkey.currentState!.validate()) {
//                           _formkey.currentState!.save();
//                           setState(() {
//                             isLoading = true;
//                           });
//                           try {await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email.text.toString(), password: password.text.toString()).then((value)async{
//
//                             String Email=email.text.toString();
//                             String Password=password.text.toString();
//
//                             User? user = FirebaseAuth.instance.currentUser;
//                             await FirebaseFirestore.instance.collection('Admin').doc(user!.uid).set(
//                                 {
//                                   "Email":Email,
//                                   "Password":Password
//                                 }
//                             ).then((value) {
//                               Navigator.of(context).push(MaterialPageRoute(builder:(context)=>homePage()));
//
//                             });
//
//
//                           });
//
//                           }
//                           catch(e) {
//                             Fluttertoast.showToast(msg: e.toString());
//                             print(e.toString());
//                             setState(() {
//                               isLoading = false;
//                             });
//                           }
//                         }
//                       },
//                       child: Container(
//
//                         width: w*0.35,
//                         height: h*0.05,
//                         decoration: BoxDecoration(
//                             color: Colors.yellow[800],
//                             borderRadius: BorderRadius.circular(30)
//                         ),
//                         child: Icon(Icons.arrow_right_alt, color: Colors.white, size: h*0.035,),
//                       ),
//                     )
//                   ],
//                 )
//
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
