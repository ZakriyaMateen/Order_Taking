import 'package:app2/Providers/Userp.dart';
import 'package:app2/Screens/AdminScreens/AdminScreen.dart';
import 'package:app2/Screens/ShopScreens/ClientHomePage.dart';
import 'package:app2/Screens/CrendentialsScreen/LoginSignUp.dart';
import 'package:app2/Utils/Transition.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'Providers/RangeProviderForBrand.dart';
import 'Providers/productListProvider.dart';
import 'Screens/BrandScreens/BrandHomePage.dart';
import 'firebase_options.dart';
// <!DOCTYPE html>
// <html>
// <head>
// <meta charset="UTF-8">
// <meta content="IE=edge" http-equiv="X-UA-Compatible">
// <meta name="viewport" content="width=device-width, initial-scale=1.0">
// <title>My Flutter Web App</title>
// <!--    <script src="main.dart.js" type="application/javascript"></script>-->
// </head>
// <body>
// <script>
// // Call the main function from your Flutter app
// // This will start your Flutter web app
// // You may need to modify the app name to match your own app
// // If you used a different name, replace 'myapp' with your app name
// <!--      myapp.webOnlyMain();-->
// </script>
// </body>
// </html>

Future<void>_firebaseMessagingBackgroundHandler(RemoteMessage message)async{
  Fluttertoast.showToast(msg: message.messageId.toString());
}

  void main() async{
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values,);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarContrastEnforced: false,
      systemStatusBarContrastEnforced: false,
      systemNavigationBarDividerColor: Colors.transparent,
      statusBarBrightness: Brightness.light,
    ),);
    WidgetsFlutterBinding.ensureInitialized();

    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
   try{
     // await FirebaseMessaging.instance.getInitialMessage();
     // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
     // FirebaseMessaging messaging=FirebaseMessaging.instance;
     // NotificationSettings settings = await messaging.requestPermission(
     //     alert: true,
     //     announcement: true,
     //     badge: true,
     //     carPlay: false,
     //     criticalAlert: false,
     //     provisional: false,
     //     sound: true
     // );
   }
   catch(e){
     Fluttertoast.showToast(msg: e.toString(),toastLength: Toast.LENGTH_LONG);
   }

    runApp(const MyApp());
  }

  class MyApp extends StatefulWidget {

    const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {


    //shop1 brandUid = BD2lTtSxkwVywn0iSX1hPjKdFr72
  // shop1 clientUid = EXPWFWAXGNO7HbH8j4ksKHYYKB52
    @override
    Widget build(BuildContext context) {
      return MultiProvider(
          providers: [
            ChangeNotifierProvider<ProductList>(create: (_) => ProductList()),
            ChangeNotifierProvider<AuthProvider>(create: (_)=>AuthProvider()),
            ChangeNotifierProvider<MySliderModel>(create: (_)=>MySliderModel()),
          ],
          child: MaterialApp(
        debugShowMaterialGrid: false,
        debugShowCheckedModeBanner: false,
        title: 'ShopConnect',
            home:SplashScreen()
        )
      );
    }


}


 class SplashScreen extends StatefulWidget {
   const SplashScreen({Key? key}) : super(key: key);

   @override
   State<SplashScreen> createState() => _SplashScreenState();
 }

 class _SplashScreenState extends State<SplashScreen> {

  get()async {
    try {
      User? user =await FirebaseAuth.instance.currentUser;
      if(user!=null){
          if(await checkIfDocExists(user.uid, "Admin")){
            navigateWithTransition(context, AdminUSers(), TransitionType.scale);
          }
          else if(await checkIfDocExists(user.uid, "Brands")){
            navigateWithTransition(context, BrandHomePage(brandUid: FirebaseAuth.instance.currentUser!.uid), TransitionType.scale);
          }
          else{
            navigateWithTransition(context,ClientHomePage(clientUid: user.uid), TransitionType.scale);
          }
      }
      else{
        navigateWithTransition(context, LoginSignupScreen(), TransitionType.fade);
      }
    }
    catch(e){
      navigateWithTransition(context, LoginSignupScreen(), TransitionType.fade);
    }
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    get();
  }
   @override
   Widget build(BuildContext context) {
      double h=MediaQuery.of(context).size.height;
     return Scaffold(
       backgroundColor: Colors.white,
       body: Center(child:
         Icon(Icons.business_center,color: Colors.green[800]!,size: h*0.1,),),
     );
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
 }
