import 'package:app2/Providers/clientHomePageProvider.dart';
import 'package:app2/Screens/BrandScreens/ViewCustomer.dart';
import 'package:app2/Screens/ShopScreens/AcceptableOfferMadeByBrand.dart';
import 'package:app2/Screens/ShopScreens/CreateOrder.dart';
import 'package:app2/Screens/ShopScreens/DirectViewCustomerShop.dart';
import 'package:app2/Screens/ShopScreens/Drafts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../../Notification.dart';
import '../../Utils/Transition.dart';
import '../../Widgets/text.dart';
import '../AdminScreens/AdminScreen.dart';
import '../CrendentialsScreen/LoginSignUp.dart';
import 'Confirmed.dart';


class ClientHomePage extends StatefulWidget {
  final String clientUid;
  const ClientHomePage({Key? key, required this.clientUid}) : super(key: key);

  @override
  State<ClientHomePage> createState() => _ClientHomePageState();
}

class _ClientHomePageState extends State<ClientHomePage> {

bool isLoading=true;
bool hasError=false;
String brandUid='';
  String shopName='unknown';
  String address='unknown';
  String contact='unknown';
  String email='unknown';
  String password='unknown';
  String vat='unknown';

  getShopDetails()async{
    try{
      try{
        FirebaseFirestore.instance
            .collection(widget.clientUid)
            .limit(1)
            .get()
            .then((QuerySnapshot snapshot) {
          if (snapshot.docs.isNotEmpty) {
               brandUid = snapshot.docs.first.get('brandUid');

          } else {
            print('No documents in the collection');
          }
        })
            .catchError((error) => print('Error getting documents: $error'));
      }
      catch(e){
        print (e.toString());
      }
  var ref  =  await FirebaseFirestore.instance.collection('Clients').doc(widget.clientUid).get();
  shopName=ref.get('Name');
  address=ref.get('Address');
  contact=ref.get('Contact');
  email=ref.get('Email');
  vat=ref.get('Vat');
  password=ref.get('Password');
  print(shopName);
  setState(() {
    isLoading=false;
  });
    }
    catch(e){
      setState(() {
        isLoading=false;
        hasError=true;
      });
      print(e);
    }
  }
  get()async{

    await getShopDetails();
  }

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
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    requestPermission(context: context);
    getToken();
    initInfo();
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values,);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarContrastEnforced: false,
      systemStatusBarContrastEnforced: false,
      systemNavigationBarDividerColor: Colors.transparent,
      statusBarBrightness: Brightness.light,
    ),);
    get();
  }
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
            actions: [
              IconButton(onPressed:()async{try{await FirebaseAuth.instance.signOut().then((value) {Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginSignupScreen()));});} catch(e){Fluttertoast.showToast(msg: e.toString(),);}}, icon:Icon(Icons.logout,color: Colors.red[500],))
            ],
            automaticallyImplyLeading: false,
            elevation: 0.0,
            backgroundColor: Colors.green[800],
            centerTitle: false,
            title: text('Home',Colors.white, FontWeight.bold, h*0.018)
        ),

        body:     isLoading?Center(child: CircularProgressIndicator(color: Colors.green[800]!,),):hasError?Center(child: text('An error occurred, Please try again later!', Colors.grey[700]!,FontWeight.normal,w*0.034),):Container(

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
            Container(
            alignment: Alignment.topCenter,
            height: h*0.1,
            child: Row(
            mainAxisAlignment: MainAxisAlignment.center,

            children: [

            text(shopName,Colors.green[900]!, FontWeight.bold,h*0.021),],
            ),
            ),
            SizedBox(height: h*0.05,),
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
            onPressed: ()async{

            navigateWithTransition(context, CreateOrder(clientUid: widget.clientUid, shopName: shopName,), TransitionType.slideBottomToTop);
            },
            child: text('Create Order',Colors.white, FontWeight.bold,h*0.018),
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
            try{
            await  FirebaseFirestore.instance
                .collection(widget.clientUid)
                .limit(1)
                .get()
                .then((QuerySnapshot snapshot) {
            if (snapshot.docs.isNotEmpty) {
            var  brandUid = snapshot.docs.first.get('brandUid');
            navigateWithTransition(context, DraftsShop(clientUid: widget.clientUid, brandUid: brandUid, shopName: "",), TransitionType.slideBottomToTop);

            } else {
            print('No documents in the collection');
            }
            })
                .catchError((error) => print('Error getting documents: $error'));
            }
            catch(e){
            print (e.toString());
            }

            },
            child: text('Drafts',Colors.white, FontWeight.bold,h*0.018),
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
            try{

            navigateWithTransition(context, AcceptableOfferMadeByBrand(clientUid: widget.clientUid, brandUid: brandUid, shopName: "",), TransitionType.slideBottomToTop);

            }
            catch(e){
            print (e.toString());
            }
            },
            child: text('Confirmations',Colors.white, FontWeight.bold,h*0.018),
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
    onPressed: ()async{
    try{

    navigateWithTransition(context, Confirmed(clientUid: widget.clientUid, brandUid: brandUid, shopName: "",), TransitionType.slideBottomToTop);
    }
    catch(e){
    print (e.toString());
    }

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
    ), alignment: Alignment.center, child: TextButton(onPressed: (){navigateWithTransition(context,DirectViewCustomerShop(shopName: shopName, address: address, contact: contact, email: email, password: password, vat: vat, brandUid: brandUid, clientUid: widget.clientUid), TransitionType.slideBottomToTop);},
    child: text('Shop Details',Colors.white, FontWeight.bold,h*0.018),),),),],)],),),),)
    ,
 );

}}
