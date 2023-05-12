import 'package:app2/Utils/Transition.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../Widgets/Drawer.dart';
import '../../Widgets/text.dart';
import 'SingleShopAllOrders.dart';
import 'SingleShopConfirmedOrders.dart';

class WaitingForConfirmation extends StatefulWidget {
  final String brandUid;

  const WaitingForConfirmation({Key? key, required this.brandUid}) : super(key: key);

  @override
  State<WaitingForConfirmation> createState() => _WaitingForConfirmationState();
}

class _WaitingForConfirmationState extends State<WaitingForConfirmation> {
  List<String> brandUids = [];
  List<String> clientUids = [];
  List<String> shopsNames = [];

  @override
  void initState() {
    super.initState();
    _getShopsWithPendingOrders();
  }

  Future<void> _getShopsWithPendingOrders() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection(widget.brandUid)
          .where('CurrentOrder', isEqualTo: "yes").where('Edittable',isEqualTo: 'no').where('Confirmed',isEqualTo:'no')
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        final docs = querySnapshot.docs;
        for (final doc in docs) {
          final data = doc.data();
          brandUids.add(data['BrandUid']);
          clientUids.add(data['ClientUid']);
          shopsNames.add(data['Name']);
        }
        setState(() {}); // rebuild the widget tree with updated data
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final double screenWidth = mediaQuery.size.width;
    final double screenHeight = mediaQuery.size.height;

    return Scaffold(
      // drawer: drawer(screenHeight, screenWidth, context, widget.brandUid),
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.green[800]!,
          centerTitle: false,
          title: text(
            'Waiting for',
            Colors.white,
            FontWeight.bold,
            screenHeight * 0.018,
          ),
        ),
        body: brandUids.isEmpty
            ?  Center(child: text('No Current Order(s)',Colors.grey[700]!, FontWeight.normal,screenHeight*0.017),)
            : GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
          itemCount: brandUids.length,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: EdgeInsets.all(screenWidth * 0.03),
              child: Material(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  elevation: 5,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(15),
                    onTap: () {
                      navigateWithTransition(
                        context,
                        SingleShopConfirmedOrders(
                          shopName: shopsNames[index],
                          brandUid: brandUids[index],
                          clientUid: clientUids[index],
                        ),
                        TransitionType.scale,
                      );
                    },
                    child: Container(
                      height: screenHeight * 0.05,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.store_mall_directory_sharp,
                            color: Colors.green[800]!,
                            size: screenHeight * 0.04,
                          ),
                          SizedBox(height: screenHeight * 0.008),
                          text(
                            shopsNames[index],
                            Colors.green[800]!,
                            FontWeight.bold,
                            screenHeight * 0.021,
                          ),
                        ],
                      ),
                    ),
                  )),
            );
          },
        ));
  }
}

