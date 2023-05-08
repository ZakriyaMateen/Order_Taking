import 'package:app2/Screens/BrandScreens/AddCustomer.dart';
import 'package:app2/Screens/BrandScreens/SetClientProducts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../Utils/Transition.dart';
import '../../Widgets/ZoomableImageScreen.dart';
import '../../Widgets/text.dart';

class SingleClientProducts extends StatefulWidget {
  final String clientId;
  final String brandUid;
  const SingleClientProducts({Key? key, required this.clientId, required this.brandUid}) : super(key: key);

  @override
  State<SingleClientProducts> createState() => _SingleClientProductsState();
}

class _SingleClientProductsState extends State<SingleClientProducts> {
  bool isLongPressed=false;
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
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              text('All Products',Colors.white, FontWeight.bold, h*0.018),
              TextButton(
                  onPressed: (){
                    navigateWithTransition(context,SetClientProducts(clientId: widget.clientId, brandUid:widget. brandUid), TransitionType.slideRightToLeft);

                  },
                  child: text('Add',Colors.white, FontWeight.bold, h*0.015)),
            ],
          )
      ),
      body: StreamBuilder<QuerySnapshot<Map<String,dynamic>>>(
        stream: FirebaseFirestore.instance.collection(widget.clientId).snapshots(),
        builder: (context,snapshot){
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      } else if (snapshot.hasError) {
        return Text('Error: ${snapshot.error}');
      } else {
        final docs=snapshot.data!.docs;

        return
          ListView.builder(itemBuilder: (context,index){
          final data=docs[index].data();
            return Padding(
              padding: EdgeInsets.symmetric(vertical: h*0.006,horizontal: w*0.032),
              child: InkWell(
                onLongPress: (){
                  setState((){isLongPressed=true;});
                },
                onTap: () {
                  setState((){isLongPressed=false;});
                },
                child: Material(
                  elevation: 4,
                  borderRadius: BorderRadius.circular(10),
                  child: Container(

                    width: w,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                        padding: EdgeInsets.only(left: w*0.05,right: w*0.05,top: h*0.02,bottom: h*0.02),
                        child:   Column(
                          children: [
                            isLongPressed? Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(onPressed: ()async{
                                try{
                                  await FirebaseFirestore.instance.collection(widget.clientId).doc(data['DocId']).delete().then((val){
                                    print("deleted successfully");

                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: text('Product has been deleted!',Colors.red, FontWeight.w700,h*0.015),shape: 
                                      RoundedRectangleBorder(borderRadius: BorderRadius.circular(25),),showCloseIcon: true,elevation: 3,padding: EdgeInsets.all(8),),);
                                  });
                                }
                                catch(e){
                                  Fluttertoast.showToast(msg: e.toString());
                                  print(e.toString());
                                }


                                }, icon:Icon(Icons.delete_forever,color: Colors.red,))
                              ],
                            ):Container(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                InkWell(
                                  onTap:(){
                                    navigateWithTransition(context,ZoomableImageScreen(imageUrl: data['productImageUrl']), TransitionType.slideRightToLeft);

                                    // Navigator.push(context,MaterialPageRoute(builder: (context)=>ZoomableImageScreen(imageUrl:data['productImageUrl'])));
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(200),

                                        border: Border.all(
                                            color: Colors.green[800]!, width: 2)
                                    ),
                                    width: h * 0.08,
                                    height: h * 0.08,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(200),
                                      child: FancyShimmerImage(
                                        imageUrl: data['productImageUrl'],
                                        boxDecoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(200),
                                        ),
                                        errorWidget: Icon(
                                          Icons.error, color: Colors.grey[400],
                                          size: h * 0.06,),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: h*0.012,
                            ),
                            Table(

                                border: TableBorder.all(color: Colors.green[200]!,borderRadius: BorderRadius.circular(12)), // adds borders around the table and cells
                                children: [
                                  TableRow(
                                    children: [
                                      TableCell(
                                        child: Padding(
                                          padding:  EdgeInsets.all(w*0.03),
                                          child: text('Sku', Colors.green[800]!, FontWeight.bold, h*0.018),
                                        ),
                                      ),
                                      TableCell(
                                        child: Padding(
                                          padding:  EdgeInsets.all(w*0.03),
                                          child: text(data['productSku'], Colors.green, FontWeight.normal, h*0.017),
                                        ),

                                      ),

                                    ],
                                  ),
                                  TableRow(
                                    children: [
                                      TableCell(
                                        child: Padding(
                                          padding:  EdgeInsets.all(w*0.03),
                                          child: text('Name', Colors.green[800]!, FontWeight.bold, h*0.018),
                                        ),
                                      ),
                                      TableCell(
                                        child: Padding(
                                          padding:  EdgeInsets.all(w*0.03),
                                          child: text(data['productName'], Colors.green, FontWeight.normal, h*0.017),
                                        ),

                                      ),

                                    ],
                                  ),
                                  TableRow(
                                    children: [
                                      TableCell(
                                        child: Padding(
                                          padding:  EdgeInsets.all(w*0.03),
                                          child: text('Barcode', Colors.green[800]!, FontWeight.bold, h*0.018),
                                        ),
                                      ),
                                      TableCell(
                                        child: Padding(
                                          padding:  EdgeInsets.all(w*0.03),
                                          child: text(data['productBarcode'], Colors.green, FontWeight.normal, h*0.017),
                                        ),

                                      ),

                                    ],
                                  ),
                                  TableRow(
                                    children: [
                                      TableCell(
                                        child: Padding(
                                          padding:  EdgeInsets.all(w*0.03),
                                          child: text('Packaging', Colors.green[800]!, FontWeight.bold, h*0.018),
                                        ),
                                      ),
                                      TableCell(
                                        child: Padding(
                                          padding:  EdgeInsets.all(w*0.03),
                                          child: text(data['productPackiging'], Colors.green, FontWeight.normal, h*0.017),
                                        ),

                                      ),

                                    ],
                                  ),
                                  TableRow(
                                    children: [
                                      TableCell(
                                        child: Padding(
                                          padding:  EdgeInsets.all(w*0.03),
                                          child: text('Unit', Colors.green[800]!, FontWeight.bold, h*0.018),
                                        ),
                                      ),
                                      TableCell(
                                        child: Padding(
                                          padding:  EdgeInsets.all(w*0.03),
                                          child: text(data['productUnit'], Colors.green, FontWeight.normal, h*0.017),
                                        ),

                                      ),

                                    ],
                                  ),
                                  TableRow(
                                    children: [
                                      TableCell(
                                        child: Padding(
                                          padding:  EdgeInsets.all(w*0.03),
                                          child: text('Price', Colors.green[800]!, FontWeight.bold, h*0.018),
                                        ),
                                      ),
                                      TableCell(
                                        child: Padding(
                                          padding:  EdgeInsets.all(w*0.03),
                                          child: text(data['productPrice'], Colors.green, FontWeight.normal, h*0.017),
                                        ),

                                      ),

                                    ],
                                  ),

                                ]),
                          ],
                        )
                    ),
                  ),
                ),
              ),
            );
          },itemCount: docs!.length,);
      }
        },
      )
    );
  }
}