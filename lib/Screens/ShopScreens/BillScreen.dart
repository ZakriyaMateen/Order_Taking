import 'dart:convert';

import 'package:app2/Model/firebaseAuth.dart';
import 'package:app2/Screens/ShopScreens/ClientHomePage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import '../../Notification.dart';
import '../../Utils/Transition.dart';
import '../../Widgets/text.dart';
import 'CreateOrder.dart';
import 'EnterQuantitiesForSelectedProducts.dart';

class BillScreen extends StatefulWidget {
  final String shopName;
  final List<productDetails> list;
  final List<int> quantities;
  const BillScreen({Key? key, required this.list, required this.quantities, required this.shopName}) : super(key: key);

  @override
  State<BillScreen> createState() => _BillScreenState();
}

class _BillScreenState extends State<BillScreen> {
  String? mToken='';
  @override
  void initState() {
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values,);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarContrastEnforced: false,
      systemStatusBarContrastEnforced: false,
      systemNavigationBarDividerColor: Colors.transparent,
      statusBarBrightness: Brightness.light,
    ),);
    // TODO: implement initState
    super.initState();
    requestPermission(context: context);
    // getToken();
    // initInfo();
    // requestPermission(context: context);
    getToken();


  }


  // void getToken()async{
  //   await FirebaseMessaging.instance.getToken().then((token) async{
  //     setState(() {
  //       mToken=token;
  //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(mToken.toString()),duration: Duration(seconds: 100),));
  //     });
  //     saveToken(token!);
  //   });
  // }
  // void saveToken(String token)async{
  //   await FirebaseFirestore.instance.collection('Tokens').doc(FirebaseAuth.instance.currentUser!.uid).set(
  //       {'token':token});
  // // }
  // void requestPermission()async{
  //   FirebaseMessaging messaging=FirebaseMessaging.instance;
  //    NotificationSettings settings = await messaging.requestPermission(
  //      alert: true,
  //      announcement: true,
  //      badge: true,
  //      carPlay: false,
  //      criticalAlert: false,
  //      provisional: false,
  //      sound: true
  //    );
  //    if(settings.authorizationStatus==AuthorizationStatus.authorized){
  //     snackBar('permission granted', context, 1000, 500, Colors.green);
  //    }
  //   else if(settings.authorizationStatus==AuthorizationStatus.provisional){
  //     snackBar('Provisional permission', context, 1000, 500, Colors.green);
  //   }
  //     else{
  //     snackBar('permission denied', context, 1000, 500, Colors.green);
  //   }
  // }
  int total=0;
  bool isOrdering=false;
  @override
  Widget build(BuildContext context) {
    double w=MediaQuery.of(context).size.width;
    double h=MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: () async{ return false; },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar:AppBar(
            automaticallyImplyLeading: false,
            elevation: 0.0,
            backgroundColor: Colors.green[800],
            centerTitle: true,
            title: text('Order Form',Colors.white, FontWeight.bold, h*0.018)
        ),
        body:isOrdering?Center(child: CircularProgressIndicator(color: Colors.green,),): Padding(
          padding: EdgeInsets.symmetric(horizontal: w*0.02,vertical: h*0.005),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child:
                SingleChildScrollView(
                  child: Column(
                    children: [
                      Material(
                        color: Colors.white,
                        elevation: 5,
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                            padding: EdgeInsets.symmetric(horizontal: w*0.02,vertical: h*0.08),
                            width: w,
                            decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(20)),

                            child:tableRows(h: h, w: w)
                        ),
                      ),

                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding:  EdgeInsets.symmetric(horizontal: w*0.1),

                  child: Container(
                    margin: EdgeInsets.only(bottom: h*0.02),
                    child:
                    OutlinedButton(
                        style: OutlinedButton.styleFrom(
                            side: BorderSide(color: Colors.green[800]!,width: 1.5),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20),),
                            minimumSize: Size(w,h*0.045),
                            backgroundColor: Colors.green[800]!
                        ),
                        onPressed: ()async
                        {
                            //current :
                          // shopUid > add > product_Details
                          try{
                            setState(() {
                              isOrdering=true;
                            });
                            Map<String, dynamic> orderMap = {
                              "products": widget.list.asMap().map((i, e) => MapEntry(i.toString(), {
                                "productName": e.productName,
                                "productImageUrl": e.productImageUrl,
                                "productPrice": e.productPrice,
                                "productSku": e.productSku,
                                "productBarcode": e.productBarcode,
                                "productPackiging": e.productPackiging,
                                "productUnit": e.productUnit,
                                "brandUid": e.brandUid,
                                "quantity": widget.quantities[i], // add the quantity here
                              })),
                              "totalAmount": total,
                              "shopUid": FirebaseAuth.instance.currentUser!.uid,
                              // Add any other order details here
                            };


// Add the order map to the "Order" field
                            await FirebaseFirestore.instance.collection(widget.list[0].brandUid).doc(
                                FirebaseAuth.instance.currentUser!.uid
                            ).collection('Orders').doc(FirebaseAuth.instance.currentUser!.uid).set({
                              "Order": orderMap,
                              'Edittable':"yes",
                              'Confirmed':"no"
                            }).then((value)async{
                                await FirebaseFirestore.instance.collection(widget.list[0].brandUid).doc(FirebaseAuth.instance.currentUser!.uid).update(
                                    {
                                      "CurrentOrder":'yes',
                                      "Edittable":'yes',
                                      'Confirmed':"no"
                                    });
                              setState(() {
                                isOrdering=false;
                              });
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Center(child: text("ordered!",Colors.green, FontWeight.w600, h*0.016)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20),side: BorderSide(color: Colors.green,width: 1.2)),margin: EdgeInsets.symmetric(horizontal: w*0.05,vertical: h*0.01)
                        ,padding: EdgeInsets.all(h*0.005),
                        duration: const Duration(seconds: 5),
                        showCloseIcon: true,
                        closeIconColor: Colors.green,
                        behavior: SnackBarBehavior.floating,
                        dismissDirection: DismissDirection.vertical,
                        elevation: 4,
                        backgroundColor: Colors.white,));

                            }).then((value)async{

                                // sender device token
                                // reciever device token
                                // reciever device token saved on firestore : Tokens > BrandUid > token
                                // sender device token also saved on firestore : Tokens > clientUid > token
                                // sender creates an order, retrieve BrandUid > token and put the token as argument/ parameter


                                DocumentSnapshot snap=await FirebaseFirestore.instance.collection('Tokens').doc(widget.list[0].brandUid).get();
                                String token=snap['token'];

                                sendPushMessage(token, "New Order received","Order From : ${widget.shopName}",FirebaseAuth.instance.currentUser!.uid,widget.list[0].brandUid,widget.shopName );
                                navigateWithTransition(context, ClientHomePage(clientUid: FirebaseAuth.instance.currentUser!.uid), TransitionType.slideRightToLeft);


                            });
                          }
                          catch(e){

                            setState(() {
                              isOrdering=false;
                            });
                            print(e);
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Center(child: text("Error : "+e.toString(),Colors.red, FontWeight.w600, h*0.016)),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20),side: BorderSide(color: Colors.red,width: 1.2)),margin: EdgeInsets.symmetric(horizontal: w*0.05,vertical: h*0.01)
                              ,padding: EdgeInsets.all(h*0.005),
                              duration: const Duration(seconds: 5),
                              showCloseIcon: true,
                              closeIconColor: Colors.red,
                              behavior: SnackBarBehavior.floating,
                              dismissDirection: DismissDirection.vertical,
                              elevation: 4,
                              backgroundColor: Colors.white,));
                          }
                        }, child:text('Submit Order',Colors.white!, FontWeight.bold,h*0.017)),
                  ),

                ),
              ),
            ],
          )
        ),
      ),
    );
  }


  Table tableRows({required double h,required double w}){
    List<TableRow> rows = [];

    rows.add(    TableRow(
        children:[
          TableCell(child: Padding(padding: EdgeInsets.all(h*0.01),
            child: text('Item', Colors.green[900]!, FontWeight.bold,h*0.018),),verticalAlignment: TableCellVerticalAlignment.middle,)
          ,
          TableCell(child: Padding(padding: EdgeInsets.all(h*0.01),
            child: text('Price', Colors.green[900]!, FontWeight.bold,h*0.018),),verticalAlignment: TableCellVerticalAlignment.middle,),
          TableCell(child: Padding(padding: EdgeInsets.all(h*0.01),
            child: text('Qt', Colors.green[900]!, FontWeight.bold,h*0.018),),verticalAlignment: TableCellVerticalAlignment.middle,),
          TableCell(child: Padding(padding: EdgeInsets.all(h*0.01),
            child: text('Total', Colors.green[900]!, FontWeight.bold,h*0.018),),verticalAlignment: TableCellVerticalAlignment.middle,),
        ]
    ),
    );
    for (var i = 0; i < widget.list.length; i++) {
      var e = widget.list[i];
      total+=int.parse(e.productPrice.toString())*widget.quantities[i];
      rows.add(
        TableRow(
          children: [
            TableCell(
              child: Padding(
                padding: EdgeInsets.all(h*0.01),
                child: text(e.productName, Colors.green[700]!, FontWeight.normal,h*0.0165),
              ),
              verticalAlignment: TableCellVerticalAlignment.middle,
            ),
            TableCell(
              child: Padding(
                padding: EdgeInsets.all(h*0.01),
                child: text(e.productPrice.toString(), Colors.green[700]!, FontWeight.normal,h*0.0165),
              ),
              verticalAlignment: TableCellVerticalAlignment.middle,
            ),
            TableCell(
              child: Padding(
                padding: EdgeInsets.all(h*0.01),
                child: text(widget.quantities[i].toString(), Colors.green[700]!, FontWeight.normal,h*0.0165),
              ),
              verticalAlignment: TableCellVerticalAlignment.middle,
            ),
            TableCell(
              child: Padding(
                padding: EdgeInsets.all(h*0.01),
                child: text((int.parse(e.productPrice.toString())*widget.quantities[i]).toString(), Colors.green[700]!, FontWeight.normal,h*0.0165),
              ),
              verticalAlignment: TableCellVerticalAlignment.middle,
            ),
          ],
        ),
      );
    }

    rows.add(    TableRow(
        children:[
          TableCell(child: Padding(padding: EdgeInsets.all(h*0.01),
            child: text('', Colors.green[900]!, FontWeight.bold,h*0.018),),verticalAlignment: TableCellVerticalAlignment.middle,)
          , TableCell(child: Padding(padding: EdgeInsets.all(h*0.01),
            child: text('', Colors.green[900]!, FontWeight.bold,h*0.018),),verticalAlignment: TableCellVerticalAlignment.middle,),
          TableCell(child: Padding(padding: EdgeInsets.all(h*0.01),
            child: text('Total', Colors.green[900]!, FontWeight.bold,h*0.018),),verticalAlignment: TableCellVerticalAlignment.middle,),
          TableCell(child: Padding(padding: EdgeInsets.all(h*0.01),
            child: text(total.toString(), Colors.green[900]!, FontWeight.bold,h*0.018),),verticalAlignment: TableCellVerticalAlignment.middle,),
        ]
    ),
    );
    return Table(
      border: TableBorder.all(color: Colors.green[800]!,borderRadius: BorderRadius.circular(12),width: 1.1),
      children: rows,
    );

  }
}

