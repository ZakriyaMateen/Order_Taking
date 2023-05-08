import 'package:app2/Screens/AdminScreens/ViewBrand.dart';
import 'package:app2/Screens/BrandScreens/AddCustomer.dart';
import 'package:app2/Screens/BrandScreens/AllCustomers.dart';
import 'package:app2/Screens/BrandScreens/OrderAllShops.dart';
import 'package:app2/Screens/CrendentialsScreen/LoginSignUp.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../Notification.dart';
import '../../Utils/Transition.dart';
import '../../Widgets/ZoomableImageScreen.dart';
import '../../Widgets/text.dart';
import '../ShopScreens/CreateOrder.dart';
import 'ConfirmedOrderAllShops.dart';
import 'WaitingForConfirmation.dart';


class BrandHomePage extends StatefulWidget {
  final String brandUid;
  const BrandHomePage({Key? key, required this.brandUid}) : super(key: key);

  @override
  State<BrandHomePage> createState() => _BrandHomePageState();
}

class _BrandHomePageState extends State<BrandHomePage> {

  Future<bool> checkIfDocExists(String docId,String collectionName) async {
    try {
      // Get reference to Firestore collection
      var collectionRef =await  FirebaseFirestore.instance.collection(collectionName);

      var doc = await collectionRef.doc(docId).get();
      return doc.exists;
    } catch (e) {

      throw e;
    }
  }


  Future<void> initInfo()async{
    if (await checkIfDocExists(FirebaseAuth.instance.currentUser!.uid, "Admin")) {

    }
    else if(await checkIfDocExists(FirebaseAuth.instance.currentUser!.uid, "Brands")){
      initInfoBrand(context: context);

    }
    else{
      initInfoClient(context: context);
    }
  }
  String _imageUrl='';
  Future<void> getBrandInfo()async{
    if(widget.brandUid==null){
      print('null uid recieved');
    }
    else{
      print(widget.brandUid);
    }
    try {
      // get the document reference
      DocumentReference docRef =await FirebaseFirestore.instance.collection(widget.brandUid).doc(widget.brandUid).collection('BrandInfo').doc(widget.brandUid);
      // get the document snapshot
      DocumentSnapshot docSnap = await docRef.get();
      // get the email and password fields from the document

        setState(() {
          _imageUrl=docSnap.get('Logo');
        });

    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    requestPermission(context: context);
    getToken();
    initInfo();
  }
  @override
  Widget build(BuildContext context) {
    double w=MediaQuery.of(context).size.width;
    double h=MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: () async{return false;  },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar:AppBar(
          actions: [
            IconButton(onPressed:()async{try{await FirebaseAuth.instance.signOut().then((value) {Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginSignupScreen()));});} catch(e){Fluttertoast.showToast(msg: e.toString(),);}}, icon:Icon(Icons.logout,color: Colors.red[500],))
          ],
            elevation: 0.0,
            backgroundColor: Colors.green[800],
            centerTitle: false,
            automaticallyImplyLeading: false,
            title: text('Home',Colors.white, FontWeight.bold, h*0.018)
        ),

        body: Container(

          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.green[100]!,
                Colors.green[200]!,
                Colors.green[300]!,
                Colors.green[400]!,
                Colors.green[300]!,
                Colors.green[100]!,
                Colors.green[200]!,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Padding(
            padding:  EdgeInsets.symmetric(horizontal: w*0.05),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,

              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(200),
                          border: Border.all(color: Colors.green[800]!,width: 2)
                      ),
                      width: h*0.08,
                      height: h*0.08,
                      child: GestureDetector(
                        onTap: (){
                          navigateWithTransition(context,ZoomableImageScreen(imageUrl: _imageUrl),TransitionType.scale);
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(200),
                          child: FancyShimmerImage(

                            imageUrl:_imageUrl!=""?_imageUrl: "https://media.istockphoto.com/id/1206800961/photo/online-shopping-and-payment-man-using-tablet-with-shopping-cart-icon-digital-marketing.jpg?b=1&s=170667a&w=0&k=20&c=RT5aV_p3DgMk16-QH26DmzNj_uHaq7hkKR0UapnHL2I=",
                            boxDecoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(200),
                            ),
                            errorWidget: Icon(Icons.error,color: Colors.grey[400],size: h*0.06,),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: h*0.02,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Material(
                      elevation: 6  ,
                      borderRadius: BorderRadius.circular(20),
                      shadowColor: Colors.red[800],
                      child: Container(
                        width: w*0.36,
                        height: w*0.36,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            gradient: LinearGradient(
                              colors: [
                                Colors.red[300]!,
                                Colors.red[400]!,
                                Colors.red[500]!,
                                Colors.red[500]!,
                                Colors.red[600]!,
                                Colors.red[700]!,
                                Colors.red[800]!,
                                Colors.red[700]!,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            )
                        ),
                        alignment: Alignment.center,
                        child: TextButton(
                          onPressed: (){
                            navigateWithTransition(context, AllCustomers(brandUid: widget.brandUid), TransitionType.slideLeftToRight);
                          },
                          child: text('All Shops',Colors.white, FontWeight.bold,h*0.018),
                        ),
                      ),
                    ),
                    Material(
                      elevation: 6  ,
                      borderRadius: BorderRadius.circular(20),
                      shadowColor: Colors.red[800],
                      child: Container(
                        width: w*0.36,
                        height: w*0.36,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: LinearGradient(
                            colors: [
                              Colors.blue[300]!,
                              Colors.blue[400]!,
                              Colors.blue[500]!,
                              Colors.blue[500]!,
                              Colors.blue[600]!,
                              Colors.blue[700]!,
                              Colors.blue[800]!,
                              Colors.blue[700]!,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: TextButton(
                          onPressed: ()async{
                            // try{
                            //   await  FirebaseFirestore.instance
                            //       .collection(widget.clientUid)
                            //       .limit(1)
                            //       .get()
                            //       .then((QuerySnapshot snapshot) {
                            //     if (snapshot.docs.isNotEmpty) {
                            //       var  brandUid = snapshot.docs.first.get('brandUid');
                            //       navigateWithTransition(context, DraftsShop(clientUid: widget.clientUid, brandUid: brandUid, shopName: "",), TransitionType.slideBottomToTop);
                            //
                            //     } else {
                            //       print('No documents in the collection');
                            //     }
                            //   })
                            //       .catchError((error) => print('Error getting documents: $error'));
                            // }
                            // catch(e){
                            //   print (e.toString());
                            // }
                            navigateWithTransition(context,AddCustomer( brandUid:widget. brandUid), TransitionType.slideBottomToTop);

                          },
                          child: text('Create Shop',Colors.white, FontWeight.bold,h*0.018),
                        ),
                      ),
                    ),


                  ],
                ),
                SizedBox(height: h*0.015,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Material(
                      elevation: 6  ,
                      borderRadius: BorderRadius.circular(20),
                      shadowColor: Colors.red[800],
                      child: Container(
                        width: w*0.36,
                        height: w*0.36,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            gradient: LinearGradient(
                              colors: [
                                Colors.purple[300]!,
                                Colors.purple[400]!,
                                Colors.purple[500]!,
                                Colors.purple[500]!,
                                Colors.purple[600]!,
                                Colors.purple[700]!,
                                Colors.purple[800]!,
                                Colors.purple[700]!,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            )
                        ),
                        alignment: Alignment.center,
                        child: TextButton(
                          onPressed: ()async{

                            navigateWithTransition(context,OrderAllShops(brandUid: widget.brandUid), TransitionType.slideRightToLeft);

                          },
                          child: text('Orders',Colors.white, FontWeight.bold,h*0.018),
                        ),
                      ),
                    ),
                    Material(
                      elevation: 6  ,
                      borderRadius: BorderRadius.circular(20),
                      shadowColor: Colors.red[800],
                      child: Container(
                        width: w*0.36,
                        height: w*0.36,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            gradient: LinearGradient(
                              colors: [
                                Colors.orange[300]!,
                                Colors.orange[400]!,
                                Colors.orange[500]!,
                                Colors.orange[500]!,
                                Colors.orange[600]!,
                                Colors.orange[700]!,
                                Colors.orange[800]!,
                                Colors.orange[700]!,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            )
                        ),
                        alignment: Alignment.center,
                        child: TextButton(
                          onPressed: (){
                            navigateWithTransition(context,ConfirmedOrderAllShops(brandUid: widget.brandUid), TransitionType.slideRightToLeft);
                          },
                          child: text('Confirmed',Colors.white, FontWeight.bold,h*0.018),
                        ),
                      ),
                    ),


                  ],
                ),
                SizedBox(height: h*0.015,),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Material(
                      elevation: 6  ,
                      borderRadius: BorderRadius.circular(20),
                      shadowColor: Colors.red[800],
                      child: Container(
                        width: w*0.36,
                        height: w*0.36,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            gradient: LinearGradient(
                              colors: [
                                Colors.teal[300]!,
                                Colors.teal[400]!,
                                Colors.teal[500]!,
                                Colors.teal[500]!,
                                Colors.teal[600]!,
                                Colors.teal[700]!,
                                Colors.teal[800]!,
                                Colors.teal[700]!,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            )
                        ),
                        alignment: Alignment.center,
                        child: TextButton(
                          onPressed: (){
                            navigateWithTransition(context,ViewBrand(brandUid: widget.brandUid), TransitionType.slideRightToLeft);

                          },
                          child: text('Brand Details',Colors.white, FontWeight.bold,h*0.018),
                        ),
                      ),
                    ),
                    Material(
                      elevation: 6  ,
                      borderRadius: BorderRadius.circular(20),
                      shadowColor: Colors.red[800],
                      child: Container(
                        width: w*0.36,
                        height: w*0.36,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            gradient: LinearGradient(
                              colors: [
                                Colors.green[300]!,
                                Colors.green[400]!,
                                Colors.green[500]!,
                                Colors.green[500]!,
                                Colors.green[600]!,
                                Colors.green[700]!,
                                Colors.green[800]!,
                                Colors.green[700]!,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            )
                        ),
                        alignment: Alignment.center,
                        child: TextButton(
                          onPressed: (){
                            navigateWithTransition(context, WaitingForConfirmation(brandUid: widget.brandUid,), TransitionType.slideRightToLeft);
                          },
                          child: text('Waiting for',Colors.white, FontWeight.bold,h*0.018),
                        ),
                      ),
                    ),


                  ],
                )
              ],

            ),
          ),
        ),

      ),
    );
  }
}