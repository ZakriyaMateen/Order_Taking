import 'package:app2/Screens/AdminScreens/AddBrand.dart';
import 'package:app2/Screens/AdminScreens/ViewBrand.dart';
import 'package:app2/Screens/BrandScreens/AllCustomers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../Utils/Transition.dart';
import '../../Widgets/ZoomableImageScreen.dart';
import '../../Widgets/text.dart';
import '../CrendentialsScreen/LoginSignUp.dart';

class AdminUSers extends StatefulWidget {
  const AdminUSers({Key? key}) : super(key: key);

  @override
  State<AdminUSers> createState() => _AdminUSersState();
}

class _AdminUSersState extends State<AdminUSers> {
  @override
  Widget build(BuildContext context) {
    double w=MediaQuery.of(context).size.width;
    double h=MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: ()async{
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar:AppBar(

          automaticallyImplyLeading: false,
            actions: [
              IconButton(onPressed:()async{try{await FirebaseAuth.instance.signOut().then((value) {Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginSignupScreen()));});} catch(e){Fluttertoast.showToast(msg: e.toString(),);}}, icon:Icon(Icons.logout,color: Colors.red[500],))
            ],
            elevation: 0.0,
          backgroundColor: Colors.green[800],
          centerTitle: false,
          title: text('Brands',Colors.white, FontWeight.bold, h*0.018)
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>AddBrand()));
          },
          child: Icon(Icons.add,color: Colors.white,),
          backgroundColor: Colors.green[800],
        ),
        body: StreamBuilder<QuerySnapshot<Map<String,dynamic>>>(
          stream: FirebaseFirestore.instance.collection('Admin').doc(FirebaseAuth.instance.currentUser!.uid).collection('Brands').snapshots(),
          builder: ( context,  snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              final docs=snapshot.data!.docs;


              return ListView.builder(itemBuilder: (context, index) {

                  final data=docs[index].data();
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: h * 0.0045),
                    child: InkWell(
                      onTap: () {

                        Navigator.push(context, MaterialPageRoute(
                            builder: (context) => ViewBrand(brandUid:data['BrandUid'])));
                      },
                      child: Material(
                        elevation: 4,
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          width: w,
                          height: h * 0.1,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: w * 0.05, right: w * 0.05),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                InkWell(
                                  onTap:(){
                                    Navigator.push(context,MaterialPageRoute(builder: (context)=>ZoomableImageScreen(imageUrl:data['Logo'])));
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(200),

                                        border: Border.all(
                                            color: Colors.green[800]!, width: 2)
                                    ),
                                    width: h * 0.08,
                                    height: h * 0.08,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(200),
                                      child: FancyShimmerImage(
                                        imageUrl: data['Logo'],
                                        boxDecoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(200),
                                        ),
                                        errorWidget: Icon(
                                          Icons.error, color: Colors.grey[400],
                                          size: h * 0.06,),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: w * 0.05,),
                                Flexible(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment
                                        .stretch,
                                    children: [
                                      text(data?['Name'], Colors.green[800]!,
                                          FontWeight.w600, h * 0.017)
                                    ],
                                  ),
                                ),
                                InkWell(
                                    onTap: ()async {
                                      Navigator.push(context, MaterialPageRoute(
                                          builder: (context) => AllCustomers(brandUid: data['BrandUid'],)));


                                    },
                                    child: Icon(Icons.info_outline,
                                      color: Colors.green[100], size: h * 0.024,))
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
                  itemCount: docs!.length,);
        }})),
    );
  }
}
