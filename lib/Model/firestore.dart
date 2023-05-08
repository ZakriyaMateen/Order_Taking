import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class firestore{

Stream<QuerySnapshot<Map<String, dynamic>>> firstCollection({required String brandUid,}){
  return  FirebaseFirestore.instance.collection(brandUid).snapshots();
}

Future<QuerySnapshot<Map<String, dynamic>>> snapQuery({required String brandUid,})async{
  return await FirebaseFirestore.instance
      .collection(brandUid)
      .where('CurrentOrder', isEqualTo: "yes").where('Edittable',isEqualTo: 'yes').where("Confirmed",isEqualTo: "no")
      .get();
}
}