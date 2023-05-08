import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../../Widgets/text.dart';

class AddBrand extends StatefulWidget {
  const AddBrand({Key? key}) : super(key: key);

  @override
  State<AddBrand> createState() => _AddBrandState();
}

class _AddBrandState extends State<AddBrand> {
  TextEditingController nameController=TextEditingController();
  TextEditingController contactController=TextEditingController();
  TextEditingController addressController=TextEditingController();
  TextEditingController emailController=TextEditingController();
  TextEditingController passwordController=TextEditingController();
  TextEditingController vatController=TextEditingController();
  final _formKey=GlobalKey<FormState>();
  String adminEmail="";
  String adminPassword="";
  bool _passwordVisible = false;
  bool isLoading=false;
  bool isButtonPressed=false;
  void _togglePasswordVisibility() {
    setState(() {
      _passwordVisible = !_passwordVisible;
    });
  }
  File? _imageFile;
  final picker = ImagePicker();
  final _storage = FirebaseStorage.instance;

  Future<void> _selectAndDisplayImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile == null) return;
    setState(() {
      _imageFile = File(pickedFile.path);
    });
  }

   String _imageUrl='';
  bool isSelected=false;
  Future<bool> _uploadImage() async {
    if (_imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select an image first.'),
        ),
      );
      isSelected=false;
      return isSelected;
    }

    final fileName = _imageFile!.path.split('/').last;
    final ref = _storage.ref().child('images/$fileName');
    await ref.putFile(_imageFile!);
    final imageUrl = await ref.getDownloadURL();
    setState(() {
      _imageUrl=imageUrl;
    });
    setState(() {
      isSelected=true;
    });
    return isSelected;
  }

  @override
  Widget build(BuildContext context) {
    double w=MediaQuery.of(context).size.width;
    double h=MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar:AppBar(
          elevation: 0.0,
          backgroundColor: Colors.green[800],
          centerTitle: false,
          title: text('Add Brand',Colors.white, FontWeight.bold, h*0.018)
      ),
      body: isLoading?Center(child: CircularProgressIndicator(color: Colors.green,),):Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: w*0.05),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: h*0.067,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _imageFile != null
                        ?   Container(
                      width: w*0.85,
                      height: h*0.2,
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: Image.file(_imageFile!,fit: BoxFit.cover,)
                      ),
                    )
                        : IconButton(
                      icon: Icon(Icons.image,color: Colors.green,),
                      onPressed: _selectAndDisplayImage,
                    ),
                    SizedBox(height: 16),

                  ],
                ),
                SizedBox(height: h*0.07,),
                TextFormField(
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(color: Colors.grey[800], letterSpacing: .5,fontWeight: FontWeight.normal,fontSize: h*0.017),
                  ),
                  controller: nameController,
                  decoration: InputDecoration(
                    label: text('Name', Colors.grey[800]!,FontWeight.normal, h*0.017),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)
                    ),
                    enabledBorder:  OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green,width: 1),
                        borderRadius: BorderRadius.circular(20)),
                    focusedBorder:   OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green,width: 1.5),
                        borderRadius: BorderRadius.circular(20)),
                    prefixIcon: Icon(Icons.person,color: Colors.green,),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value!.length<2) {
                      return 'Please enter a name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: h*0.018),
                TextFormField(
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(color: Colors.grey[800], letterSpacing: .5,fontWeight: FontWeight.normal,fontSize: h*0.017),
                  ),
                  controller: contactController,
                  keyboardType: TextInputType.phone,

                  decoration: InputDecoration(
                    label: text('Contact', Colors.grey[800]!,FontWeight.normal, h*0.017),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)
                    ),
                    enabledBorder:  OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green,width: 1),
                        borderRadius: BorderRadius.circular(20)),
                    focusedBorder:   OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green,width: 1.5),
                        borderRadius: BorderRadius.circular(20)),
                    prefixIcon: Icon(Icons.phone,color: Colors.green,),
                  ),
                  validator: (value) {
                    if (value!.length<11) {
                      return 'Please enter a valid contact';
                    }
                    return null;
                  },
                ),
                SizedBox(height: h*0.018),
                TextFormField(
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(color: Colors.grey[800], letterSpacing: .5,fontWeight: FontWeight.normal,fontSize: h*0.017),
                  ),
                  controller: addressController,
                  decoration: InputDecoration(
                    label: text('Address', Colors.grey[800]!,FontWeight.normal, h*0.017),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)
                    ),
                    enabledBorder:  OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green,width: 1),
                        borderRadius: BorderRadius.circular(20)),
                    focusedBorder:   OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green,width: 1.5),
                        borderRadius: BorderRadius.circular(20)),
                    prefixIcon: Icon(Icons.location_on,color: Colors.green,),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value!.length<2) {
                      return 'Please give the location';
                    }
                    return null;
                  },
                ),
                SizedBox(height: h*0.018),
                TextFormField(
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(color: Colors.grey[800], letterSpacing: .5,fontWeight: FontWeight.normal,fontSize: h*0.017),
                  ),
                  controller: emailController,
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
                SizedBox(height: h*0.018),
                TextFormField( style: GoogleFonts.lato(
                  textStyle: TextStyle(color: Colors.grey[800], letterSpacing: .5,fontWeight: FontWeight.normal,fontSize: h*0.017),
                ),
                  controller: passwordController,
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
                    return null;
                  },
                ),
                SizedBox(height: h*0.018),
                TextFormField(
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(color: Colors.grey[800], letterSpacing: .5,fontWeight: FontWeight.normal,fontSize: h*0.017),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  controller: vatController,
                  decoration: InputDecoration(
                    label: text('Vat', Colors.grey[800]!,FontWeight.normal, h*0.017),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)
                    ),
                    enabledBorder:  OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green,width: 1),
                        borderRadius: BorderRadius.circular(20)),
                    focusedBorder:   OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green,width: 1.5),
                        borderRadius: BorderRadius.circular(20)),
                    prefixIcon: Icon(Icons.local_activity,color: Colors.green,),
                  ),
                  validator: (value) {
                    if (value!.length<2) {
                      return 'Please enter your vat';
                    }
                    return null;
                  },
                ),
                SizedBox(height: h*0.018),

                SizedBox(height: h*0.05),

                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                      minimumSize: Size(w,h*0.045),
                      side: BorderSide(color: Colors.green[800]!),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)
                      )
                  ),
                  child: text("Save", Colors.green, FontWeight.bold, h*0.018),

                  onPressed: isButtonPressed?(){}:()async {
                                    if (_formKey.currentState!.validate()) {
                                    _formKey.currentState!.save();
                        if(_imageFile!=null){
                          setState(() {
                            isLoading=true;
                            isButtonPressed=true;
                          });
                                  if(await _uploadImage()){
                                    setState(() {
                                      isLoading=true;
                                      isButtonPressed=true;
                                    });
                                  String email=emailController.text.toString();
                                  String password=passwordController.text.toString();
                                  String vat=vatController.text.toString();
                                  String address=addressController.text.toString();
                                  String name=nameController.text.toString();
                                  String contact=contactController.text.toString();
                                  try{
                                  //Admin Uid
                                  User? user=FirebaseAuth.instance.currentUser;
                                  String adminUid=user!.uid;
                                  String brandUid='';
                                  //Admin email, password
                                  await getAdminData(uid:adminUid);

                                  await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password).then((value) async{
                                  //Brand uid
                                  brandUid=FirebaseAuth.instance.currentUser!.uid;
                                  //Admin>BrandUid>Brands>BrandUid>fields
                                  //Admin>AdminUid>Brands>BrandUid>fields
                                  await FirebaseFirestore.instance.collection("Admin").doc(adminUid).collection('Brands').doc(brandUid).set({
                                  'Email':email,
                                  'Password':password,
                                  'Vat':vat,
                                  'Address':address,
                                  'Name':name,
                                  'Contact':contact,
                                  'BrandUid':brandUid,
                                  "Logo":_imageUrl
                                  });
                                  }).then((value)async {
                                  await FirebaseFirestore.instance.collection(brandUid).doc(brandUid).collection("BrandInfo").doc(brandUid).set({
                                  'Email':email,
                                  'Password':password,
                                  'Vat':vat,
                                  'Address':address,
                                  'Name':name,
                                  'Contact':contact,
                                  'BrandUid':brandUid,
                                  "Logo":_imageUrl
                                  }).then((value) async{

                                  await FirebaseFirestore.instance.collection('Brands').doc(brandUid).set(
                                  {'BrandUid':brandUid,
                                  'Email':email,
                                  'Password':password});
                                  await FirebaseAuth.instance.signInWithEmailAndPassword(email: adminEmail, password: adminPassword);
                                  }).then((value) {
                                  Navigator.of(context).pop();
                                  });
                                  });

                                  }
                                  catch(e){
                                  Fluttertoast.showToast(msg: e.toString());
                                  setState(() {
                                  isLoading=false;
                                  isButtonPressed=false;
                                  });
                                  }
                                  }
                                  else{
                                  Fluttertoast.showToast(msg: " Please choose a logo!");
                                  }

                                  }
                                  else{
                                  setState(() {
                                  isLoading=false;
                                  isButtonPressed=false;
                                  });
                                  }
    }
                  }
                ),
                //add logo
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> getAdminData({required String uid}) async {
    try {
      // get the document reference
      DocumentReference docRef = FirebaseFirestore.instance.collection('Admin').doc(uid);
      // get the document snapshot
      DocumentSnapshot docSnap = await docRef.get();
      // get the email and password fields from the document
       adminEmail = docSnap.get('Email');
      adminPassword = docSnap.get('Password');
      // do something with the email and password fields
      print('Email: $adminEmail, Password: $adminPassword');
    } catch (e) {
      print('Error: $e');
    }
  }
}
