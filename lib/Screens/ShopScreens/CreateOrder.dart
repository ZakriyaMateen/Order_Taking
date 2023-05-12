import 'dart:convert';
import 'package:http/http.dart'as http;
import 'package:app2/Screens/ShopScreens/DisplaySingleProductInfo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Providers/productListProvider.dart';
import '../../Utils/Transition.dart';
import '../../Widgets/text.dart';
import 'EnterQuantitiesForSelectedProducts.dart';

class CreateOrder extends StatefulWidget {
  final String shopName;
  final String clientUid;
  final String clientVat;
  final Map<String, dynamic> currencyRates;
  final String brandCurrency;
  final String clientCurrency;

  const CreateOrder({Key? key, required this.clientUid, required this.shopName, required this.clientVat, required this.currencyRates, required this.brandCurrency, required this.clientCurrency}) : super(key: key);

  @override
  State<CreateOrder> createState() => _CreateOrderState();
}

class productDetails{
  final String productName,productImageUrl,productPrice,productSku,productBarcode,productPackiging,productUnit,brandUid;

  productDetails({
    // required this.clientUid,
    required this.productName,
    required this.productImageUrl,
    required this.productPrice,
    required this.productSku,
    required this.productBarcode,
    required this.productPackiging,
    required this.productUnit,
    required this.brandUid,

  });
}


class _CreateOrderState extends State<CreateOrder> {
  // Future<Map<String, dynamic>> getLiveCurrencyRates() async {
  //   final String url = "https://api.exchangerate-api.com/v4/latest/USD";
  //
  //   final response = await http.get(Uri.parse(url));
  //
  //   if (response.statusCode == 200) {
  //     return json.decode(response.body);
  //   } else {
  //     throw Exception("Failed to get live currency rates.");
  //   }
  // }
  //
  // late Map<String, dynamic> _currencyRates;
  // List<String> getCurrencyCodes() {
  //   if (_currencyRates != null) {
  //     return _currencyRates.keys.toList();
  //   } else {
  //     return [];
  //   }
  // }
  //
  //  String clientCurrency="AED";
  //   String brandCurrency="AED";
  //   bool isLoading=true;
  // getCurrencies()async{
  //   try{
  //     DocumentSnapshot snapshot=  await FirebaseFirestore.instance.collection('Clients').doc(widget.clientUid).get();
  //     clientCurrency=snapshot['ClientCurrency'];
  //     brandCurrency=snapshot['BrandCurrency'];
  //     setState(() {
  //       isLoading=false;
  //     });
  //
  //   }
  //   catch(e){
  //     setState(() {
  //       isLoading=false;
  //     });
  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
  //   }
  // }
convert({required double amount}) {

    final double fromCurrencyRate =
    widget.currencyRates[widget.brandCurrency].toDouble();
    final double toCurrencyRate =
    widget.currencyRates[widget.clientCurrency].toDouble();
    final double convertedAmount =
        (amount / fromCurrencyRate) * toCurrencyRate;
    final String message =
        "${convertedAmount.toStringAsFixed(2)} ";

    // ${amount.toStringAsFixed(2)} $brandCurrency =
    return message;
}


  List<productDetails> list=[];
  Set<int> selectedIndices = {}; // in
  List<productDetails> selectedProducts = [];
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
          title: text('Select Products',Colors.white, FontWeight.bold, h*0.018)
      ),

    body:  Stack(
      children: [
        Align(
          alignment: Alignment.topCenter,
            child: StreamBuilder<QuerySnapshot<Map<String,dynamic>>>(
              stream: FirebaseFirestore.instance.collection(widget.clientUid).snapshots(),
              builder: (context,snapshot){
              if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
              } else {
              final docs=snapshot.data!.docs;

           return Consumer<ProductList>(
           builder: (context, productList, _) {
                return ListView.builder(
                itemBuilder: (context,index) {
                final data = docs[index].data();
                return Padding(
                padding:  EdgeInsets.symmetric(horizontal:w*0.05,vertical: h*0.005),
                child: InkWell(
                onTap: (){
                productList.toggleSelection(index, data);
                },
                  child: Material(
                    elevation: 4,
                      color: selectedIndices.contains(index) ? Colors.green[100]! : Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    child: Container(

                      width: w,
                      height: h*0.1,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: productList.selectedIndices.contains(index) ? Colors.green[100]! : Colors.white




                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: w*0.05,vertical:h*0.014 ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                          Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  text("Name ", Colors.grey[800]!, FontWeight.bold, h*0.018),
                                  text("Price ", Colors.grey[800]!, FontWeight.normal, h*0.018),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  text(": "+data['productName'], Colors.grey[800]!, FontWeight.bold, h*0.0164),
                                  text(": "+convert(amount: double.parse(data['productPrice']))
                                      , Colors.grey[800]!, FontWeight.normal, h*0.0164),
                                ],
                              ),
                            ],
                          ),
                             InkWell(
                               onTap: (){
                                 navigateWithTransition(context, DisplaySingleProductInfo(clientUid: widget.clientUid, productName: data['productName'],
                                     productImageUrl: data['productImageUrl'], productPrice: data['productPrice'], productSku: data['productSku'],
                                     productBarcode: data['productBarcode'], productPackiging: data['productPackiging'], productUnit: data['productUnit'], brandUid: data['brandUid'],), TransitionType.scale);

                               },
                               child: Material(
                                 color: Colors.white,
                                   borderRadius: BorderRadius.circular(200),
                                   elevation: 5,
                                   child: Icon(Icons.info,color: Colors.green[400]!,size: h*0.03,)),
                             )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },itemCount: docs.length,);


    }
    );
              }
    }
    )
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding:  EdgeInsets.symmetric(horizontal: w*0.1),

            child: Container(
                margin: EdgeInsets.only(bottom: h*0.02),
                child:Consumer<ProductList>(
                    builder: (context, productList, _) {
                      return  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.green[800]!,width: 1.5),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20),),
                      minimumSize: Size(w,h*0.045),
                      backgroundColor: Colors.green[800]!
                    ),
                    onPressed: ()
                    {
                      productList.selectedIndices.length>0?

                      navigateWithTransition(context, EnterQuantitiesForSelectedProducts(clientVat: widget.clientVat,list: productList.list, shopName: widget.shopName, brandCurrency:widget. brandCurrency, clientCurrency:widget. clientCurrency, currencyRates: widget.currencyRates,), TransitionType.slideRightToLeft):
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

                    }, child:text('Proceed',Colors.white!, FontWeight.bold,h*0.017));})
    ),

          ),
        ),
      ],
    ),
    );
  }
}
