import 'package:app2/Notification.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../Utils/Transition.dart';
import '../../Widgets/ZoomableImageScreen.dart';
import '../../Widgets/text.dart';
import '../BrandScreens/EnterQuantitiesForSelectedProductsForSHOP.dart';
import '../ShopScreens/CreateOrder.dart';
import '../ShopScreens/EnterQuantitiesForSelectedProducts.dart';


class AcceptableOfferMadeByBrand extends StatefulWidget {
  final String brandUid,clientUid,shopName,clientVat,brandCurrency,clientCurrency;
  final Map<String,dynamic> currencyRates;

  const AcceptableOfferMadeByBrand({Key? key, required this.brandUid, required this.clientUid, required this.shopName, required this.clientVat, required this.brandCurrency, required this.clientCurrency, required this.currencyRates}) : super(key: key);

  @override
  State<AcceptableOfferMadeByBrand> createState() => _AcceptableOfferMadeByBrandState();
}
// Drafts : waiting for the editted version!

class _AcceptableOfferMadeByBrandState extends State<AcceptableOfferMadeByBrand> {
  convert({required double amount}) {

    final double fromCurrencyRate =
    widget.currencyRates[widget.brandCurrency].toDouble();
    final double toCurrencyRate =
    widget.currencyRates[widget.clientCurrency].toDouble();
    final double convertedAmount =
        (amount / fromCurrencyRate) * toCurrencyRate;
    final String message =
        "${convertedAmount.toStringAsFixed(2)}" ;
    // +  widget.clientCurrency
    // ${amount.toStringAsFixed(2)} $brandCurrency =
    return message;
  }

  double totalAmount=0;
  bool isConfirming=false;
  List<productDetails> products=[];
  List<productDetails> orders=[];
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
            title: text("Offer",Colors.white, FontWeight.bold, h*0.018)
        ),

        body: isConfirming?Center(child: CircularProgressIndicator(color: Colors.green,),):Stack(children:[ Align(
          alignment: Alignment.topCenter,
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection(widget.brandUid)
                .doc(widget.clientUid)
                .collection('Orders') .where('Edittable',isEqualTo:"no")
                .where('Confirmed',isEqualTo:'no')
                .snapshots(),
            builder: (BuildContext context,  snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
               orders = [];
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
                      child: text('Sku', Colors.green[900]!, FontWeight.bold,h*0.018),),verticalAlignment: TableCellVerticalAlignment.middle,)
                    ,
                    TableCell(child: Padding(padding: EdgeInsets.all(h*0.01),
                      child: text('Image', Colors.green[900]!, FontWeight.bold,h*0.018),),verticalAlignment: TableCellVerticalAlignment.middle,)
                    ,
                    TableCell(child: Padding(padding: EdgeInsets.all(h*0.01),
                      child: text('Item', Colors.green[900]!, FontWeight.bold,h*0.018),),verticalAlignment: TableCellVerticalAlignment.middle,)
                    ,
                    TableCell(child: Padding(padding: EdgeInsets.all(h*0.01),
                      child: text('Unit', Colors.green[900]!, FontWeight.bold,h*0.018),),verticalAlignment: TableCellVerticalAlignment.middle,)
                    ,
                    TableCell(verticalAlignment: TableCellVerticalAlignment.middle,child: Padding(padding: EdgeInsets.all(h*0.01),
                      child: text('Packaging', Colors.green[900]!, FontWeight.bold,h*0.018),),)
                    ,
                    TableCell(child: Padding(padding: EdgeInsets.all(h*0.01),
                      child: text('Qt', Colors.green[900]!, FontWeight.bold,h*0.018),),verticalAlignment: TableCellVerticalAlignment.middle,),
                    TableCell(child: Padding(padding: EdgeInsets.all(h*0.01),
                      child: text('Price', Colors.green[900]!, FontWeight.bold,h*0.018),),verticalAlignment: TableCellVerticalAlignment.middle,),

                    TableCell(child: Padding(padding: EdgeInsets.all(h*0.01),
                      child: text('Total', Colors.green[900]!, FontWeight.bold,h*0.018),),verticalAlignment: TableCellVerticalAlignment.middle,),
                    TableCell(child: Padding(padding: EdgeInsets.all(h*0.01),
                      child:Container(),),verticalAlignment: TableCellVerticalAlignment.middle,),
                  ]
              ),
              );

              double total=0;
              for (var i = 0; i < orders.length; i++) {
                var e = orders[i];
                int x = int.parse(orderMap["products"][i.toString()]["quantity"].toString());
                // total+=double.parse(e.productPrice.toString())*x;
                total +=(double.parse(convert(amount: double.parse(e.productPrice.toString()))) *x);
                rows.add(
                  TableRow(
                    children: [
                      TableCell(
                        child: Padding(
                          padding: EdgeInsets.all(h*0.01),
                          child: text(e.productSku, Colors.green[700]!, FontWeight.normal,h*0.015),
                        ),
                        verticalAlignment: TableCellVerticalAlignment.middle,
                      ),
                      TableCell(
                        verticalAlignment: TableCellVerticalAlignment.middle,
                        child: Padding(
                          padding: EdgeInsets.all(h*0.01),
                          child:    Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(200),
                                border: Border.all(color: Colors.green[800]!,width: 2)
                            ),
                            width: h*0.05,
                            height: h*0.05,
                            child: GestureDetector(
                              onTap: (){
                                navigateWithTransition(context,ZoomableImageScreen(imageUrl: e.productImageUrl),TransitionType.scale);
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(200),
                                child: FancyShimmerImage(

                                  imageUrl:e.productImageUrl!=""?e.productImageUrl: "https://media.istockphoto.com/id/1206800961/photo/online-shopping-and-payment-man-using-tablet-with-shopping-cart-icon-digital-marketing.jpg?b=1&s=170667a&w=0&k=20&c=RT5aV_p3DgMk16-QH26DmzNj_uHaq7hkKR0UapnHL2I=",
                                  boxDecoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(200),
                                  ),
                                  errorWidget: Icon(Icons.error,color: Colors.grey[400],size: h*0.06,),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
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
                          child: text(e.productUnit.toString(), Colors.green[700]!, FontWeight.normal,h*0.0165),
                        ),
                        verticalAlignment: TableCellVerticalAlignment.middle,
                      ),
                      TableCell(
                        child: Padding(
                          padding: EdgeInsets.all(h*0.01),
                          child: text(e.productPackiging.toString(), Colors.green[700]!, FontWeight.normal,h*0.0165),
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
                          child: text(convert(amount: double.parse(e.productPrice.toString())), Colors.green[700]!, FontWeight.normal,h*0.0165),
                        ),
                        verticalAlignment: TableCellVerticalAlignment.middle,
                      ),

                      TableCell(
                        child: Padding(
                          padding: EdgeInsets.all(h*0.01),
                          child: text((double.parse(convert(amount: double.parse(e.productPrice.toString()))) * x).toStringAsFixed(2), Colors.green[700]!, FontWeight.normal,h*0.0165),
                        ),
                        verticalAlignment: TableCellVerticalAlignment.middle,
                      ),
                      TableCell(
                        verticalAlignment: TableCellVerticalAlignment.middle,
                        child: Padding(
                          padding: EdgeInsets.all(h*0.01),
                          child: InkWell(onTap: (){
                            showModalBottomSheet(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft:Radius.circular(19),topRight: Radius.circular(19))),
                              context: context,
                              builder: (BuildContext context) {
                                return Container(
                                  padding: EdgeInsets.symmetric(horizontal: w*0.05,vertical: h*0.017),
                                  height: h*0.4,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20.0),
                                      topRight: Radius.circular(20.0),
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                          decoration:BoxDecoration(border: Border.all(color: Colors.grey[700]!,width: 1),borderRadius: BorderRadius.circular(200)),
                                          child: InkWell(onTap:(){
                                            navigateWithTransition(context, ZoomableImageScreen(imageUrl:products[i].productImageUrl ), TransitionType.fade);
                                          },child: ClipRRect(borderRadius: BorderRadius.circular(200),child: FancyShimmerImage(imageUrl: products[i].productImageUrl,height: h*0.08,width: h*0.08,)))),
                                      SizedBox(height: h*0.03,),
                                      Row(
                                        children: [
                                          text('Sku : ', Colors.green[900]!, FontWeight.bold,h*0.018),
                                          text(products[i].productSku, Colors.green[700]!, FontWeight.normal,h*0.0165),
                                        ],
                                      ),
                                      Divider(),
                                      Row(
                                        children: [
                                          text('Packaging : ', Colors.green[900]!, FontWeight.bold,h*0.018),
                                          text(products[i].productPackiging, Colors.green[700]!, FontWeight.normal,h*0.0165),
                                        ],
                                      ),

                                      Divider(),

                                      Row(
                                        children: [
                                          text('Barcode : ', Colors.green[900]!, FontWeight.bold,h*0.018),
                                          text(products[i].productBarcode, Colors.green[700]!, FontWeight.normal,h*0.0165),
                                        ],
                                      ),Divider(),

                                      Row(
                                        children: [
                                          text('Item : ', Colors.green[900]!, FontWeight.bold,h*0.018),
                                          text(products[i].productName, Colors.green[700]!, FontWeight.normal,h*0.0165),
                                        ],
                                      ),
                                      Divider(),

                                      Row(
                                        children: [
                                          text('Price : ', Colors.green[900]!, FontWeight.bold,h*0.018),
                                          text(convert(amount: double.parse(products[i].productPrice.toString())), Colors.green[700]!, FontWeight.normal,h*0.0165),
                                        ],
                                      ),
                                      Divider(),
                                      Row(
                                        children: [
                                          text('Unit : ', Colors.green[900]!, FontWeight.bold,h*0.018),
                                          text(products[i].productUnit, Colors.green[700]!, FontWeight.normal,h*0.0165),
                                        ],
                                      ),
                                      Divider(),


                                    ],
                                  ),
                                );
                              },
                            );
                          },child: Icon(Icons.visibility,color: Colors.green[800]!,size: h*0.027,),),
                        ),
                      ),
                    ],
                  ),
                );
              }
              double totalWithVat=0;
              double  clientVatPercentage=double.parse(widget.clientVat)/100;
              totalWithVat=total+total*clientVatPercentage;

              rows.add(    TableRow(
                  children:[
                    TableCell(child: Padding(padding: EdgeInsets.all(h*0.01),
                      child: text('', Colors.green[900]!, FontWeight.bold,h*0.018),),verticalAlignment: TableCellVerticalAlignment.middle,),
                    TableCell(child: Padding(padding: EdgeInsets.all(h*0.01),
                      child: text('', Colors.green[900]!, FontWeight.bold,h*0.018),),verticalAlignment: TableCellVerticalAlignment.middle,),
                    TableCell(child: Padding(padding: EdgeInsets.all(h*0.01),
                      child: text('', Colors.green[900]!, FontWeight.bold,h*0.018),),verticalAlignment: TableCellVerticalAlignment.middle,),
                    TableCell(child: Padding(padding: EdgeInsets.all(h*0.01),
                      child: text('', Colors.green[900]!, FontWeight.bold,h*0.018),),verticalAlignment: TableCellVerticalAlignment.middle,),
                    TableCell(child: Padding(padding: EdgeInsets.all(h*0.01),
                      child: text('Vat', Colors.green[900]!, FontWeight.bold,h*0.018),),verticalAlignment: TableCellVerticalAlignment.middle,)
                    , TableCell(child: Padding(padding: EdgeInsets.all(h*0.01),
                      child: text(widget.clientVat + " %", Colors.green[900]!, FontWeight.bold,h*0.018),),verticalAlignment: TableCellVerticalAlignment.middle,),
                    TableCell(child: Padding(padding: EdgeInsets.all(h*0.01),
                      child: text('Total', Colors.green[900]!, FontWeight.bold,h*0.018),),verticalAlignment: TableCellVerticalAlignment.middle,),
                    TableCell(child: Padding(padding: EdgeInsets.all(h*0.01),
                      child: text(totalWithVat.toStringAsFixed(2)+ widget.clientCurrency, Colors.green[900]!, FontWeight.bold,h*0.018),),verticalAlignment: TableCellVerticalAlignment.middle,),
                    TableCell(child: Padding(padding: EdgeInsets.all(h*0.01),
                      child: Container(),),verticalAlignment: TableCellVerticalAlignment.middle,),
                  ]
              ),
              );
              return orders.isEmpty?Center(child: text("No confirmation(s) yet!",Colors.grey[700]!,FontWeight.normal, h*0.0175),):Padding(
                padding:  EdgeInsets.symmetric(horizontal: w*0.012,vertical: 4),
                child: Container(
                  width: w,
                  height: h,
                  alignment: Alignment.center,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Table(
                        defaultColumnWidth: IntrinsicColumnWidth(),
                        border: TableBorder.all(color: Colors.green[800]!,borderRadius: BorderRadius.circular(12),width: 1.1),
                        children: rows,

                      ),
                    ),
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
                            onPressed: ()async{setState(() {

                            });
                              orders.isEmpty?printMessage(h,w):await update(h,w);
                            },


                         child:text('Confirm',Colors.white!, FontWeight.bold,h*0.017))
              ),

            ),
          ),
        ])
    );
  }
  update(double h,double w)async{
    try{
      setState(() {
        isConfirming=true;
      });

      await   FirebaseFirestore.instance
          .collection(widget.brandUid)
          .doc(widget.clientUid)
          .collection('Orders').doc(widget.clientUid).update(
          {
            "Confirmed":'yes'
          }) .then((value)async{
          await FirebaseFirestore.instance.collection(widget.brandUid).doc(widget.clientUid).update(   {
            "CurrentOrder":'yes',
            "Edittable":'yes',
            'Confirmed':"yes"
          });

        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Center(child: text(
                'Confirmed successfully!' , Colors.green,
                FontWeight.w600, h * 0.016)),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                      color: Colors.green, width: 1.2)),
              margin: EdgeInsets.symmetric(
                  horizontal: w * 0.05,
                  vertical: h * 0.01)
              ,
              padding: EdgeInsets.all(h * 0.005),
              duration: const Duration(seconds: 5),
              showCloseIcon: true,
              closeIconColor: Colors.red,
              behavior: SnackBarBehavior.floating,
              dismissDirection: DismissDirection.vertical,
              elevation: 4,
              backgroundColor: Colors.white,));
      });

      setState(() {
        isConfirming=false;
      });
    }
    catch(e) {

      setState(() {
        isConfirming=false;
      });
      // navigateWithTransition(context, EnterQuantitiesForSelectedProducts(list: productList.list,), TransitionType.slideRightToLeft);
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Center(child: text(
              'Error' + e.toString(), Colors.red,
              FontWeight.w600, h * 0.016)),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                    color: Colors.red, width: 1.2)),
            margin: EdgeInsets.symmetric(
                horizontal: w * 0.05,
                vertical: h * 0.01)
            ,
            padding: EdgeInsets.all(h * 0.005),
            duration: const Duration(seconds: 5),
            showCloseIcon: true,
            closeIconColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            dismissDirection: DismissDirection.vertical,
            elevation: 4,
            backgroundColor: Colors.white,));
    }
  }

printMessage(double h,double w){
  ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Center(child: text(
          'No Confirmations yet', Colors.red,
          FontWeight.w600, h * 0.016)),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(
                color: Colors.red, width: 1.2)),
        margin: EdgeInsets.symmetric(
            horizontal: w * 0.05,
            vertical: h * 0.01)
        ,
        padding: EdgeInsets.all(h * 0.005),
        duration: const Duration(seconds: 5),
        showCloseIcon: true,
        closeIconColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        dismissDirection: DismissDirection.vertical,
        elevation: 4,
        backgroundColor: Colors.white,));
}
}
