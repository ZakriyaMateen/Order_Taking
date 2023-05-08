
import 'dart:convert';

import 'package:app2/Screens/BrandScreens/OrderAllShops.dart';
import 'package:app2/Screens/BrandScreens/SingleShopAllOrders.dart';
import 'package:app2/Screens/ShopScreens/AcceptableOfferMadeByBrand.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'Model/firebaseAuth.dart';
import 'Screens/ShopScreens/ClientHomePage.dart';
import 'Utils/Transition.dart';

void sendPushMessageBrand(String token, String body, String title,String clientUid,String brandUid,String shopName)async{
  try{
    await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String,String>{
          'Content-Type': 'application/json',
          'Authorization': 'key=AAAAsW7H9V4:APA91bGb-7aQ0JVbpNr06ErJBcLfXsDEq9PXlZzNerutoThMJRaGkQwM9BQr5KyGpuUBVcT_hU0gZ66TGMQCgeRWIn6qFAdg0kWBQCgRZQ45e_U3rNBrDjCPYHfIu0_Xz2ii2ZSF5Af7'
        },
        body: jsonEncode(
            <String, dynamic>{
              'priority': 'high',
              'data': <String, dynamic>{
                'click_action': 'FLUTTER_NOTIFICATION_CLICK',
                'status': 'done',
                'title': title,
                'body': body,
                'data': {
              'brandUid': brandUid,
              'clientUid': clientUid,
              'shopName': shopName
            }
          },
              "notification": <String, dynamic>{
                "title": title,
                'body': body,
                "data":
                {
              "brandUid": brandUid,
              "clientUid": clientUid,
              "shopName": shopName
            },
                "android_channel_id": "order"
              },
              "to": token,
            }
        )
    );
  }
  catch(e){
    print(e.toString());
  }
}



void sendPushMessage(String token, String body, String title,String clientUid,String brandUid,String shopName)async{
  try{
    await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String,String>{
          'Content-Type': 'application/json',
          'Authorization': 'key=AAAAsW7H9V4:APA91bGb-7aQ0JVbpNr06ErJBcLfXsDEq9PXlZzNerutoThMJRaGkQwM9BQr5KyGpuUBVcT_hU0gZ66TGMQCgeRWIn6qFAdg0kWBQCgRZQ45e_U3rNBrDjCPYHfIu0_Xz2ii2ZSF5Af7'
        },
        body: jsonEncode(
            <String, dynamic>{
              'priority': 'high',
              'data': <String, dynamic>{
                'click_action': 'FLUTTER_NOTIFICATION_CLICK',
                'status': 'done',
                'title': title,
                'body': body,

                'data': {
              'brandUid': brandUid,
              'clientUid': clientUid,
              'shopName': shopName
            }
          },
              "notification": <String, dynamic>{
                "title": title,
                'body': body,

                "data": {
                  "brandUid": brandUid,
                  "clientUid": clientUid,
                  "shopName": shopName,},
                "android_channel_id": "order"
              },
              "to": token,
            }
        )
    );
  }
  catch(e){
    print(e.toString());
  }
}

late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin=FlutterLocalNotificationsPlugin();

void initInfoClient({required BuildContext context})async{
  var androidInitialize =  const AndroidInitializationSettings('@mipmap/ic_launcher');
  var iOSInitialize =const IOSInitializationSettings();
  var initializationSettings= InitializationSettings(android: androidInitialize,iOS: iOSInitialize);
  flutterLocalNotificationsPlugin.initialize(initializationSettings,onSelectNotification: (String? payload)async{
    try{
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(payload.toString())));

    if(payload!=null && payload.isNotEmpty){
        Map<String, dynamic> payloadData =await jsonDecode(payload);
        String brandUid = payloadData['brandUid'];
        String clientUid = payloadData['clientUid'];
        String shopName = payloadData['shopName'];
        navigateWithTransition(context, AcceptableOfferMadeByBrand(brandUid: brandUid, clientUid: clientUid, shopName:shopName ,), TransitionType.slideRightToLeft);
      }else{
      }
    }
    catch(e){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString()),duration: Duration(seconds: 100),));
    }
    return;
  });
  FirebaseMessaging.onMessage.listen((RemoteMessage message) async{
    // Fluttertoast.showToast(msg: message.notification!.title.toString()+"  "+message.notification!.body.toString());
    BigTextStyleInformation bigTextStyleInformation =BigTextStyleInformation(
        message.notification!.body.toString(),htmlFormatBigText: true,
        contentTitle:  message.notification!.title.toString(),htmlFormatContentTitle: true
    );
    AndroidNotificationDetails androidPlatformChannelSpecifics=AndroidNotificationDetails(
        'order','order',importance: Importance.high ,
        styleInformation: bigTextStyleInformation,playSound: true);
    NotificationDetails platformChannelSpecifics=NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: IOSNotificationDetails()
    );
    await flutterLocalNotificationsPlugin.show(0, message.notification!.title, message.notification!.body, platformChannelSpecifics,payload: message.data['data']);
  });


}
void initInfoBrand({required BuildContext context}) async {
  var androidInitialize = const AndroidInitializationSettings('@mipmap/ic_launcher');
  var iOSInitialize = const IOSInitializationSettings();
  var initializationSettings = InitializationSettings(android: androidInitialize, iOS: iOSInitialize);
  flutterLocalNotificationsPlugin.initialize(initializationSettings, onSelectNotification: (String? payload) async {
    try {
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(payload.toString())));
    // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(jsonDecode(payload!)['brandUid'].toString())));



    if (payload != null && payload.isNotEmpty) {
        Map<String, dynamic> payloadData =await jsonDecode(payload);
        String brandUid = payloadData['brandUid'];
        String clientUid = payloadData['clientUid'];
        String shopName = payloadData['shopName'];

        navigateWithTransition(
          context,
          SingleShopAllOrders(
            brandUid: brandUid,
            clientUid: clientUid,
            shopName: shopName,
          ),
          TransitionType.slideRightToLeft,
        );

      } else {

      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString()), duration: Duration(seconds: 100),));
    }
    return;
  });
  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    // Fluttertoast.showToast(msg: message.notification!.title.toString()+"  "+message.notification!.body.toString());
    BigTextStyleInformation bigTextStyleInformation =BigTextStyleInformation(
        message.notification!.body.toString(),htmlFormatBigText: true,
        contentTitle:  message.notification!.title.toString(),htmlFormatContentTitle: true
    );
    AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'order', 'order', importance: Importance.high,
        styleInformation: bigTextStyleInformation, playSound: true);
    NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: IOSNotificationDetails()
    );
    await flutterLocalNotificationsPlugin.show(0, message.notification!.title, message.notification!.body, platformChannelSpecifics, payload: message.data['data']);
  });
}

void getToken()async{
  await FirebaseMessaging.instance.getToken().then((token) async{
    // setState(() {
    //
    //   // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(token.toString()),duration: Duration(seconds: 100),));
    // });
    saveToken(token!);
  });
}
void saveToken(String token)async{
  await FirebaseFirestore.instance.collection('Tokens').doc(FirebaseAuth.instance.currentUser!.uid).set(
      {'token':token});
}
void requestPermission({required BuildContext context})async{
  FirebaseMessaging messaging=FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true
  );
  if(settings.authorizationStatus==AuthorizationStatus.authorized){
    snackBar('permission granted', context, 1000, 500, Colors.green);
  }
  else if(settings.authorizationStatus==AuthorizationStatus.provisional){
    snackBar('Provisional permission', context, 1000, 500, Colors.green);
  }
  else{
    snackBar('permission denied', context, 1000, 500, Colors.green);
  }
}