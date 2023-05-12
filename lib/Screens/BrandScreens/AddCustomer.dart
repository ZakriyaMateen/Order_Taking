import 'dart:convert';
import 'package:app2/Providers/RangeProviderForBrand.dart';
import 'package:app2/Screens/BrandScreens/SetClientProducts.dart';
import 'package:app2/Screens/CrendentialsScreen/LoginSignUp.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../Utils/Transition.dart';
import '../../Widgets/text.dart';

class AddCustomer extends StatefulWidget {
  final String brandUid;

  const AddCustomer({Key? key, required this.brandUid}) : super(key: key);

  @override
  State<AddCustomer> createState() => _AddCustomerState();
}

class _AddCustomerState extends State<AddCustomer> {

  TextEditingController _searchController = TextEditingController();
  final List<String> _currencies = [
    'USD',
    'EUR',
    'GBP',
    'JPY',
    'CHF',
    'AUD',
    'CAD',
    'CNY',
    'HKD',
    'INR',
    'SGD',
    'ZAR',
    'AED',
    'NZD',
    'THB',
    'SEK',
    'NOK',
    'MXN',
    'DKK',
    'MYR',
    'PHP',
    'PLN',
    'BRL',
    'HUF',
    'IDR',
    'ILS',
    'KRW',
    'RON',
    'RUB',
    'TRY',
    'ARS',
    'CLP',
    'COP',
    'HRK',
    'ISK',
    'MAD',
    'PEN',
    'SAR',
    'VND',
    'EGP',
    'KWD',
    'QAR',
    'BGN',
    'RON',
    'UAH',
    'PKR'
  ];
  bool isSaving=false;
  TextEditingController nameController=TextEditingController();
  TextEditingController contactController=TextEditingController();
  TextEditingController addressController=TextEditingController();
  TextEditingController emailController=TextEditingController();
  // TextEditingController vatController=TextEditingController();
  TextEditingController passwordController=TextEditingController();

  final _formKey=GlobalKey<FormState>();
  bool _passwordVisible = false;
  bool isLoading=false;
  bool isButtonPressed=false;
  String brandEmail="";
  String brandPassword="";
  String newClientUid="";
  double vatValue=0.0;
  String clientCurrency="AED";
  String brandCurrency="AED";
  void _togglePasswordVisibility() {
    setState(() {
      _passwordVisible = !_passwordVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    double w=MediaQuery.of(context).size.width;
    double h=MediaQuery.of(context).size.height;

    return ChangeNotifierProvider(
      create: (BuildContext context) =>MySliderModel(),

      child: Scaffold(
        backgroundColor: Colors.white,
        appBar:AppBar(
            elevation: 0.0,
            backgroundColor: Colors.green[800],
            centerTitle: false,
            title: text('Add Client',Colors.white, FontWeight.bold, h*0.018)
        ),
        body: isSaving?Center(child: CircularProgressIndicator(color: Colors.green,),):Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: w*0.05),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: h*0.067,),
                  Align(alignment:Alignment.center,child: text('Adding New Client', Colors.green[600]!, FontWeight.bold, h*0.02)),
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
                      if (value!.length!=11) {
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
                      if (value!.length<6) {
                        return 'Please enter a password';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: h*0.018),


                  Row(
                    children: [
                      text('VAT', Colors.green, FontWeight.normal, h*0.016),
                      SizedBox(width: w*0.03,),
                      Consumer<MySliderModel>(
                        builder: (context, model, child) => Expanded(
                          child: Slider(
                            value: model.value,
                            min: 0,
                            max: 100,
                            divisions: 100,
                            label: model.value.round().toString(),
                            onChanged: (value) {

                              model.updateValue(value);
                              vatValue=model.value;
                            },


                            activeColor: Colors.green,
                            secondaryActiveColor: Colors.green[700]!,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: h*0.012),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          text('Your Currency',Colors.green[800]!,FontWeight.bold, h*0.015),
                          SizedBox(height: h*0.01,),
                          DropdownMenu(
                            initialSelection: 'AED',

                            enabled: true,
                            enableFilter: true,
                            enableSearch: true,
                            onSelected: (value){
                              brandCurrency=value.toString();
                            },
                            dropdownMenuEntries: List.generate(_currencies.length, (index) => DropdownMenuEntry(
                              value: _currencies[index],
                              label: _currencies[index],
                              enabled: true,
                              leadingIcon: Icon(Icons.format_textdirection_l_to_r),
                            )),

                          ),
                        ],
                      ),
                      Column(
                        children: [
                          text("Client's Currency",Colors.green[800]!,FontWeight.bold, h*0.015),
                          SizedBox(height: h*0.01,),
                          DropdownMenu(
                            initialSelection: 'AED',
                            enabled: true,
                            enableFilter: true,
                            enableSearch: true,
                            onSelected: (value){
                              clientCurrency=value.toString();
                              print(clientCurrency);
                              },
                            dropdownMenuEntries: List.generate(_currencies.length, (index) => DropdownMenuEntry(
                                value: _currencies[index],
                              label: _currencies[index],
                              enabled: true,
                              leadingIcon: Icon(Icons.format_textdirection_l_to_r),
                            )),

                          ),
                        ],
                      )
                    ],
                  ),

                  SizedBox(height: h*0.05),


                       OutlinedButton(
                        style: OutlinedButton.styleFrom(
                            minimumSize: Size(w,h*0.045),
                            side: BorderSide(color: Colors.green[800]!),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)
                            )
                        ),
                        child: text("Add", Colors.green, FontWeight.bold, h*0.018),
                        onPressed: isSaving ? () {} : () async {
                          if (_formKey.currentState!.validate()) {
                            print(vatValue);
                            String clientName=nameController.text.toString();
                            String clientAddress=addressController.text.toString();
                            String clientContact=contactController.text.toString();
                            String clientEmail=emailController.text.toString();
                            String clientPassword=passwordController.text.toString();
                            String vat=vatValue.toString();
                            setState(() {
                              isSaving=true;
                            });

                            try {
                              await FirebaseAuth.instance.createUserWithEmailAndPassword(email: clientEmail, password:clientPassword).then((value) async{
                                newClientUid= FirebaseAuth.instance.currentUser!.uid;
                                await getBrandData(uid: widget.brandUid);
                                await FirebaseAuth.instance.signInWithEmailAndPassword(email: brandEmail, password:brandPassword).then((value)async {

                                  await FirebaseFirestore.instance.collection(widget.brandUid).doc(newClientUid).set({
                                    "Name":clientName,
                                    "BrandUid":widget.brandUid,
                                    "ClientUid":newClientUid,
                                    "BrandCurrency":brandCurrency,
                                    "ClientCurrency":clientCurrency
                                  });
                                }).then((value)async{
                                  await FirebaseFirestore.instance.collection('Clients').doc(newClientUid).set(
                                      {"ClientUid":newClientUid,
                                        "Name":clientName,
                                        "Address":clientAddress,
                                        "Vat":vat ,
                                        "Email":clientEmail,
                                        "Password":clientPassword,
                                        "Contact":clientContact,
                                        "BrandUid":widget.brandUid,
                                        "BrandCurrency":brandCurrency,
                                        "ClientCurrency":clientCurrency
                                      }).then((value){
                                    navigateWithTransition(context,SetClientProducts(clientId: newClientUid, brandUid:widget.brandUid), TransitionType.slideRightToLeft);
                                  });
                                });


                              });
                            } catch(e) {
                              print(e.toString());
                            }

                            setState(() {
                              isSaving=false;
                            });
                          }
                        },
                  ),

                  //add logo
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> getBrandData({required String uid}) async {
    try {
      // get the document reference
      DocumentReference docRef = FirebaseFirestore.instance.collection('Brands').doc(uid);
      // get the document snapshot
      DocumentSnapshot docSnap = await docRef.get();
      // get the email and password fields from the document
      brandEmail = docSnap.get('Email');
      brandPassword = docSnap.get('Password');
      // do something with the email and password fields
      print('Email: $brandEmail, Password: $brandPassword');
    } catch (e) {
      print('Error: $e');
    }
  }
}


