import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../Utils/Transition.dart';
import '../../Widgets/text.dart';
import '../ShopScreens/CreateOrder.dart';
import '../ShopScreens/EnterQuantitiesForSelectedProducts.dart';
import 'EnterQuantitiesForSelectedProductsForSHOP.dart';


class SingleShopAllOrders extends StatefulWidget {
  final String brandUid,clientUid,shopName;

  const SingleShopAllOrders({Key? key, required this.brandUid, required this.clientUid, required this.shopName}) : super(key: key);

  @override
  State<SingleShopAllOrders> createState() => _SingleShopAllOrdersState();
}

class _SingleShopAllOrdersState extends State<SingleShopAllOrders> {
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
          title: text(widget.shopName,Colors.white, FontWeight.bold, h*0.018)
      ),

      body: Stack(children:[ Align(
        alignment: Alignment.topCenter,
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection(widget.brandUid)
              .doc(widget.clientUid)
              .collection('Orders')
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
      Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding:  EdgeInsets.symmetric(horizontal: w*0.1),

          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  margin: EdgeInsets.only(bottom: h*0.02),
                  child:
                          OutlinedButton(
                            style: OutlinedButton.styleFrom(
                                side: BorderSide(color: Colors.green[800]!,width: 1.5),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20),),
                                minimumSize: Size(w*0.3,h*0.045),
                                backgroundColor: Colors.green[800]!
                            ),
                            onPressed: ()
                            {

                              navigateWithTransition(context, EnterQuantitiesForSelectedProductsForSHOP(list: products,clientUid:widget.clientUid,brandUid:widget.brandUid, shopName:  widget.shopName,), TransitionType.slideRightToLeft);
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Center(child: text('No product(s) selected!',Colors.red, FontWeight.w600, h*0.016)),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20),side: BorderSide(color: Colors.red,width: 1.2)),margin: EdgeInsets.symmetric(horizontal: w*0.05,vertical: h*0.01)
                                ,padding: EdgeInsets.all(h*0.005),
                                duration: const Duration(seconds: 5),
                                showCloseIcon: true,
                                closeIconColor: Colors.red,
                                behavior: SnackBarBehavior.floating,
                                dismissDirection: DismissDirection.vertical,
                                elevation: 4,
                                backgroundColor: Colors.white,));

                            }, child:text('Edit',Colors.white!, FontWeight.bold,h*0.017))
              ),

            ],
          ),

        ),
      ),

      ])
    );
  }

}
