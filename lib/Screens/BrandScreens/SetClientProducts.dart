import 'dart:io';

import 'package:app2/Model/firebaseAuth.dart';
import 'package:app2/Screens/BrandScreens/SingleClientAllProducts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../../Widgets/text.dart';

class SetClientProducts extends StatefulWidget {
  final String clientId,brandUid;
  const SetClientProducts({Key? key, required this.clientId, required this.brandUid}) : super(key: key);

  @override
  State<SetClientProducts> createState() => _SetClientProductsState();
}

class _SetClientProductsState extends State<SetClientProducts> {
  TextEditingController skuController=TextEditingController();
  TextEditingController nameController=TextEditingController();
  TextEditingController barcodeController=TextEditingController();
  TextEditingController packagingController=TextEditingController();
  TextEditingController unitController=TextEditingController();
  TextEditingController priceController=TextEditingController();
  final _formKey=GlobalKey<FormState>();
  bool isLoading=false;

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
          title: text('Add Product',Colors.white, FontWeight.bold, h*0.018)
      ),
      body:isLoading?Center(child: CircularProgressIndicator(),): Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: w*0.05),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: h*0.04,),
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
                SizedBox(height: h*0.04,),
                TextFormField(
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(color: Colors.grey[800], letterSpacing: .5,fontWeight: FontWeight.normal,fontSize: h*0.017),
                  ),
                  controller: skuController,
                  decoration: InputDecoration(
                    label: text('Sku', Colors.grey[800]!,FontWeight.normal, h*0.017),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)
                    ),
                    enabledBorder:  OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green,width: 1),
                        borderRadius: BorderRadius.circular(20)),
                    focusedBorder:   OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green,width: 1.5),
                        borderRadius: BorderRadius.circular(20)),
                    prefixIcon: Icon(Icons.code,color: Colors.green,),
                  ),
                  // keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value!.length<2) {
                      return 'Please enter the sku';
                    }
                    return null;
                  },
                ),
                SizedBox(height: h*0.013),
                TextFormField(
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(color: Colors.grey[800], letterSpacing: .5,fontWeight: FontWeight.normal,fontSize: h*0.017),
                  ),
                  controller: nameController,
                  keyboardType: TextInputType.name,

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
                    prefixIcon: Icon(Icons.text_fields,color: Colors.green,),
                  ),
                  validator: (value) {
                    if (value!.length<2) {
                      return 'Please enter a name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: h*0.013),
                TextFormField(
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(color: Colors.grey[800], letterSpacing: .5,fontWeight: FontWeight.normal,fontSize: h*0.017),
                  ),
                  controller: barcodeController,
                  decoration: InputDecoration(
                    label: text('Barcode', Colors.grey[800]!,FontWeight.normal, h*0.017),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)
                    ),
                    enabledBorder:  OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green,width: 1),
                        borderRadius: BorderRadius.circular(20)),
                    focusedBorder:   OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green,width: 1.5),
                        borderRadius: BorderRadius.circular(20)),
                    prefixIcon: Icon(Icons.qr_code_2,color: Colors.green,),
                  ),
                  // keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value!.length<2) {
                      return 'Please give the barcode';
                    }
                    return null;
                  },
                ),


                SizedBox(height: h*0.013),
                TextFormField(
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(color: Colors.grey[800], letterSpacing: .5,fontWeight: FontWeight.normal,fontSize: h*0.017),
                  ),
                  // keyboardType: TextInputType.emailAddress,
                  controller: unitController,
                  decoration: InputDecoration(
                    label: text('Unit', Colors.grey[800]!,FontWeight.normal, h*0.017),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)
                    ),
                    enabledBorder:  OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green,width: 1),
                        borderRadius: BorderRadius.circular(20)),
                    focusedBorder:   OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green,width: 1.5),
                        borderRadius: BorderRadius.circular(20)),
                    prefixIcon: Icon(Icons.scale,color: Colors.green,),
                  ),
                  validator: (value) {
                    if (value!.length<2) {
                      return 'Please enter your vat';
                    }
                    return null;
                  },
                ),  SizedBox(height: h*0.013),
                TextFormField(
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(color: Colors.grey[800], letterSpacing: .5,fontWeight: FontWeight.normal,fontSize: h*0.017),
                  ),
                  controller: packagingController,
                  decoration: InputDecoration(
                    label: text('Packaging', Colors.grey[800]!,FontWeight.normal, h*0.017),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)
                    ),
                    enabledBorder:  OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green,width: 1),
                        borderRadius: BorderRadius.circular(20)),
                    focusedBorder:   OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green,width: 1.5),
                        borderRadius: BorderRadius.circular(20)),
                    prefixIcon: Icon(Icons.shopping_bag,color: Colors.green,),
                  ),
                  validator: (value) {
                    if (value!.length<2) {
                      return 'Invalid packaging';
                    }
                    return null;
                  },
                ),
                SizedBox(height: h*0.013),
                TextFormField(
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(color: Colors.grey[800], letterSpacing: .5,fontWeight: FontWeight.normal,fontSize: h*0.017),
                  ),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  controller: priceController,
                  decoration: InputDecoration(
                    label: text('Price', Colors.grey[800]!,FontWeight.normal, h*0.017),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)
                    ),
                    enabledBorder:  OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green,width: 1),
                        borderRadius: BorderRadius.circular(20)),
                    focusedBorder:   OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green,width: 1.5),
                        borderRadius: BorderRadius.circular(20)),
                    prefixIcon: Icon(Icons.attach_money,color: Colors.green,),
                  ),
                  validator: (value) {
                    if (value!.length<2) {
                      return 'Please enter the price';
                    }
                    return null;
                  },
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
                  child: text("Save", Colors.green, FontWeight.bold, h*0.018),

                  onPressed: isLoading?(){}:() async{
                    if (_formKey.currentState!.validate()) {

                      if(_imageFile!=null){
    setState(() {
    isLoading=true;
    });
                       if(await _uploadImage()){

                      //TODO: Implement authentication logic
                      String productSku=skuController.text.toString();
                      String productName=nameController.text.toString();
                      String productBarcode=barcodeController.text.toString();
                      String productUnit=unitController.text.toString();
                      String productPackiging=packagingController.text.toString();
                      String productPrice=priceController.text.toString();

                      try{setState(() {
                        isLoading=true;
                      });
                      CollectionReference collectionRef =    await FirebaseFirestore.instance.collection(widget.clientId);
                        DocumentReference ?docRef=await    collectionRef.add({
                            "productSku":productSku,
                            "productName":productName,
                            "productUnit":productUnit,
                            "productPackiging":productPackiging,
                            "productPrice":productPrice,
                            "productBarcode":productBarcode,
                            "productImageUrl":_imageUrl,
                            "brandUid":widget.brandUid
                          });
                          String docId = docRef.id;
                         await docRef.update({'DocId': docId});

                          setState(() {
                              isLoading=false;
                            });
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>SingleClientProducts(clientId:widget.clientId, brandUid: widget.brandUid,)));

                      }
                      catch(e){
                        setState(() {
                          isLoading=false;
                        });
                        print(e.toString());
                      }
                       }
                       else{
                         Fluttertoast.showToast(msg: " Please choose a logo!");
                       }
                    }}
                    else{
                      snackBar("Please select an image first!", context, h, w,Colors.red[800]!);
                    }
                  },
                ),
                //add logo
              ],
            ),
          ),
        ),
      ),
    );
  }
}
