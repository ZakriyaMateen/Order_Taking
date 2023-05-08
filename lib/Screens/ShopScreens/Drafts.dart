import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../Utils/Transition.dart';
import '../../Widgets/text.dart';
import '../BrandScreens/EnterQuantitiesForSelectedProductsForSHOP.dart';
import '../ShopScreens/CreateOrder.dart';
import '../ShopScreens/EnterQuantitiesForSelectedProducts.dart';


class DraftsShop extends StatefulWidget {
  final String brandUid,clientUid,shopName;
  const DraftsShop({Key? key, required this.brandUid, required this.clientUid, required this.shopName}) : super(key: key);

  @override
  State<DraftsShop> createState() => _DraftsShopState();
}
// Drafts : waiting for the editted version!

class _DraftsShopState extends State<DraftsShop> {
  int totalAmount=0;
  List<productDetails> products=[];
  late Map<String, dynamic> orderMap;
  @override
  Widget build(BuildContext context) {
    double w=MediaQuery.of(context).size.width;
    double h=MediaQuery.of(context).size.height;
    return Scaffold(
      // drawer: drawer(h,w,context,widget.brandUid),
        backgroundColor: Colors.white,
        appBar:AppBar(
            elevation: 0.0,
            backgroundColor: Colors.green[800],
            centerTitle: false,
            title: text("Draft",Colors.white, FontWeight.bold, h*0.018)
        ),

        body: Stack(children:[ Align(
          alignment: Alignment.topCenter,
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection(widget.brandUid)
                .doc(widget.clientUid)
                .collection('Orders') .where('Edittable',isEqualTo:"yes")
                .snapshots(),
            builder: (BuildContext context,  snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              List<productDetails> orders = [];
              snapshot.data!.docs.forEach((document) {
                orderMap  = document.get("Order");
                Map<String, dynamic> productsMap = orderMap["products"];

                products = productsMap.values.map((productMap) {
                  return productDetails(
                    productName: productMap["productName"],
                    productImageUrl: productMap["productImageUrl"],
                    productPrice: productMap["productPrice"],
                    productSku: productMap["productSku"],
                    productBarcode: productMap["productBarcode"],
                    productPackiging: productMap["productPackiging"],
                    productUnit: productMap["productUnit"],
                    brandUid: productMap["brandUid"],
                  );
                }).toList();
                totalAmount = orderMap["totalAmount"];
                orders.addAll(products);
              });
              // list.add(productDetails(productName: productName, productImageUrl: productImageUrl, productPrice: productPrice, productSku: productSku, productBarcode: productBarcode, productPackiging: productPackiging, productUnit: productUnit, brandUid: brandUid))
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

              int total=0;
              for (var i = 0; i < orders.length; i++) {
                var e = orders[i];
                int x=orderMap["products"][i.toString()]["quantity"];
                total+=int.parse(e.productPrice.toString())*x;
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
                          child: text(x.toString(), Colors.green[700]!, FontWeight.normal,h*0.0165),
                        ),
                        verticalAlignment: TableCellVerticalAlignment.middle,
                      ),
                      TableCell(
                        child: Padding(
                          padding: EdgeInsets.all(h*0.01),
                          child: text((int.parse(e.productPrice.toString())*x).toString(), Colors.green[700]!, FontWeight.normal,h*0.0165),
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
              return Padding(
                padding:  EdgeInsets.symmetric(horizontal: w*0.012,vertical: 4),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Table(
                        border: TableBorder.all(color: Colors.green[800]!,borderRadius: BorderRadius.circular(12),width: 1.1),
                        children: rows,
                      ),
                    ],
                  ),
                ),
              );

            },
          ),
        ),


        ])
    );
  }

}
