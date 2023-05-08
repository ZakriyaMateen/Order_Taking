import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Widgets/text.dart';


class firebaseAuth{

  Future<bool> login({required String email,required String password,required BuildContext context,required double h,required  double w,})async{
    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);

      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        snackBar('No user found for that email.', context, h, w, Colors.red);
        return false;
      } else if (e.code == 'wrong-password') {
        snackBar('Wrong password provided for that user.', context, h, w, Colors.red);
        return false;
        print('Wrong password provided for that user.');
      } else if (e.code == 'invalid-email') {
        snackBar('Invalid email format.', context, h, w, Colors.red);
        return false;

        print('Invalid email format.');
      } else {
        print(e.message);

        return false;      }
    } catch (e) {return false;
      print(e);
    }
  }
  Future<bool> signup({required String email,required String password})async{
    try{
      await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
      return true;
    }
    catch(e){
      return false;
    }
  }

}

snackBar(String string,BuildContext context,double h,double w,Color color){
  return    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Center(child: text(string,color, FontWeight.w600, h*0.016)),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20),side: BorderSide(color: Colors.green,width: 1.2)),margin: EdgeInsets.symmetric(horizontal: w*0.05,vertical: h*0.01)
    ,padding: EdgeInsets.all(h*0.005),
    duration: const Duration(seconds: 5),
    showCloseIcon: true,
    closeIconColor: Colors.green,
    behavior: SnackBarBehavior.floating,
    dismissDirection: DismissDirection.vertical,
    elevation: 4,
    backgroundColor: Colors.white,));

}