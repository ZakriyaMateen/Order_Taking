import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../Widgets/text.dart';
import '../ShopScreens/CreateOrder.dart';

class BrandOrders extends StatefulWidget {
  final String brandUid;
  const BrandOrders({Key? key, required this.brandUid}) : super(key: key);

  @override
  State<BrandOrders> createState() => _BrandOrdersState();
}

class _BrandOrdersState extends State<BrandOrders> {
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
          title: text('All Orders',Colors.white, FontWeight.bold, h*0.018)
      ),
      body: StreamBuilder<QuerySnapshot<Map<String,dynamic>>>(
        stream: FirebaseFirestore.instance.collection(widget.brandUid).doc("kMHKdcq0jPYWl1oHdBi06aNeyXT2").collection('Orders').snapshots(),
        builder: (context,AsyncSnapshot<QuerySnapshot> snapshot){
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      } else if (snapshot.hasError) {
        return Text('Error: ${snapshot.error}');
      } else {
        List<productDetails> orders = [];
        snapshot.data!.docs.forEach((document) {
          final orderMap = document["Order"];
          final productList = orderMap["products"] as Map<String, dynamic>;

          final products = productList.values.map((value) => productDetails(
            productName: value["productName"],
            productImageUrl: value["productImageUrl"],
            productPrice: value["productPrice"],
            productSku: value["productSku"],
            productBarcode: value["productBarcode"],
            productPackiging: value["productPackiging"],
            productUnit: value["productUnit"],
            brandUid: value["brandUid"],

          )).toList();

          orders.addAll(products);
        });

        return ListView.builder(
          itemCount: orders.length,
          itemBuilder: (BuildContext context, int index) {
            // return ListTile(
            //   title: Text(orders[index].productName),
            //   subtitle: Text(orders[index].productPrice),
            //
            // );
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: w*0.05,vertical: h*0.006),
              child: Material(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                elevation: 5,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  width: w,
                  height: h*0.1,
                  padding: EdgeInsets.symmetric(horizontal: w*0.05,vertical: h*0.01),
                  child:  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          text("Item : ", Colors.grey[800]!, FontWeight.bold,h*0.017),

                          text(orders[index].productName, Colors.green[800]!, FontWeight.bold,h*0.017),
                        ],
                      ),
                      Row(
                        children: [
                          text("Price : ", Colors.grey[800]!, FontWeight.bold,h*0.017),

                          text(orders[index].productPrice, Colors.green[800]!, FontWeight.bold,h*0.017),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );

          },
        );
    }})
    );
  }
}

