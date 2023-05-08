import 'package:app2/Screens/BrandScreens/AddCustomer.dart';
import 'package:app2/Screens/BrandScreens/SingleClientAllProducts.dart';
import 'package:app2/Utils/Transition.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../Model/firestore.dart';
import '../../Widgets/Drawer.dart';
import '../../Widgets/text.dart';
import 'ViewCustomer.dart';

class AllCustomers extends StatefulWidget {
  final String brandUid;

  const AllCustomers({Key? key, required this.brandUid}) : super(key: key);

  @override
  _AllCustomersState createState() => _AllCustomersState();
}

class _AllCustomersState extends State<AllCustomers> {
  @override
  Widget build(BuildContext context) {
    final double w = MediaQuery.of(context).size.width;
    final double h = MediaQuery.of(context).size.height;

    return Scaffold(
        // drawer: drawer(h, w, context, widget.brandUid),
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.green[800],
          centerTitle: false,
          title: text('All Clients', Colors.white, FontWeight.bold, h * 0.018),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {

            navigateWithTransition(context, AddCustomer(brandUid: widget.brandUid), TransitionType.scale);

          },
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
          backgroundColor: Colors.green[800],
        ),
        body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: firestore().firstCollection(brandUid:widget.brandUid),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                final docs = snapshot.data!.docs;

                return ListView.builder(
                  itemBuilder: (context, index) {
                    final data = docs[index].data();
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: h * 0.0045),
                      child: InkWell(
                        onTap: () {
                          navigateWithTransition(context,SingleClientProducts(clientId:data['ClientUid'], brandUid: widget.brandUid), TransitionType.slideRightToLeft);


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
                              padding: EdgeInsets.only(left: w * 0.05, right: w * 0.05),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  SizedBox(
                                    width: w * 0.05,
                                  ),
                                  Flexible(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      children: [
                                        text(data['Name'], Colors.green[800]!, FontWeight.w600, h * 0.02),
                                      ],
                                    ),
                                  ),
                                  InkWell(
                                      onTap: () {
                                        navigateWithTransition(context, ViewCustomer(clientUid: data['ClientUid']), TransitionType.fade);


                                      },
                                      child: Icon(
                                        Icons.info_outline,

                                        color: Colors.green[100],size: h*0.024,))
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
                itemCount: docs!.length,);

          }})
            );
  }
}
