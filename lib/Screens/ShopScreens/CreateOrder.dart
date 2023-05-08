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
  const CreateOrder({Key? key, required this.clientUid, required this.shopName}) : super(key: key);

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
  List<productDetails> list=[];
  Set<int> selectedIndices = {}; // in
  List<productDetails> selectedProducts = [];

// itially no items are selected

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

    body: Stack(
      children: [
        Align(
          alignment: Alignment.topCenter,
            child:

          StreamBuilder<QuerySnapshot<Map<String,dynamic>>>(
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
                                  text(": "+data['productName'], Colors.grey[800]!, FontWeight.bold, h*0.018),
                                  text(": "+data['productPrice'], Colors.grey[800]!, FontWeight.normal, h*0.018),
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

                      navigateWithTransition(context, EnterQuantitiesForSelectedProducts(list: productList.list, shopName: widget.shopName,), TransitionType.slideRightToLeft):
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
