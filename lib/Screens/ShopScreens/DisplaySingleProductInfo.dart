import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';

import '../../Utils/Transition.dart';
import '../../Widgets/ZoomableImageScreen.dart';
import '../../Widgets/text.dart';

class DisplaySingleProductInfo extends StatefulWidget {
  final String clientUid,productName,productImageUrl,productPrice,productSku,productBarcode,productPackiging,productUnit,brandUid;
  const DisplaySingleProductInfo({Key? key, required this.clientUid, required this.productName, required this.productImageUrl, required this.productPrice, required this.productSku, required this.productBarcode, required this.productPackiging, required this.productUnit, required this.brandUid}) : super(key: key);

  @override
  State<DisplaySingleProductInfo> createState() => _DisplaySingleProductInfoState();
}

class _DisplaySingleProductInfoState extends State<DisplaySingleProductInfo> {
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
          title: text('Product Details',Colors.white, FontWeight.bold, h*0.018)
      ),
      body: Center(
        child: Padding(
          padding:  EdgeInsets.symmetric(horizontal: w*0.05),
          child: Material(
            elevation: 5,
            color: Colors.white,
            borderRadius: BorderRadius.circular(19),
            child: Container(
              padding:  EdgeInsets.all(w*0.03),
                width: w,
              height: h*0.7,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(19)
              ),
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(200),
                            border: Border.all(color: Colors.green[800]!,width: 2)
                        ),
                        width: h*0.08,
                        height: h*0.08,
                        child: GestureDetector(
                          onTap: (){
                            navigateWithTransition(context,ZoomableImageScreen(imageUrl: widget.productImageUrl),TransitionType.scale);
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(200),
                            child: FancyShimmerImage(

                              imageUrl: widget.productImageUrl!=""? widget.productImageUrl: "https://media.istockphoto.com/id/1206800961/photo/online-shopping-and-payment-man-using-tablet-with-shopping-cart-icon-digital-marketing.jpg?b=1&s=170667a&w=0&k=20&c=RT5aV_p3DgMk16-QH26DmzNj_uHaq7hkKR0UapnHL2I=",
                              boxDecoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(200),
                              ),
                              errorWidget: Icon(Icons.error,color: Colors.grey[400],size: h*0.06,),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: h*0.03,),
                  Row(mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    text('-- Details --',Colors.green[800]!, FontWeight.bold,h*0.02)
                  ],),
                  SizedBox(height: h*0.04 ,),
                  Table(
                    border: TableBorder.all( borderRadius: BorderRadius.circular(12),color: Colors.green[800]!,width: 1.4),
                    children: [

                      TableRow(
                          children: [
                            TableCell(
                              child: Padding(
                                padding:  EdgeInsets.all(w*0.03),
                                child: text('Name',Colors.green, FontWeight.bold, h*0.017),
                              ),
                            ),
                            TableCell(
                              child: Padding(
                                padding:  EdgeInsets.all(w*0.03),
                                child: text(widget.productName,Colors.green, FontWeight.normal, h*0.017),
                              ),
                            ),
                          ]
                      ),
                      TableRow(
                          children: [
                            TableCell(
                              child: Padding(
                                padding:  EdgeInsets.all(w*0.03),
                                child: text('Price',Colors.green, FontWeight.bold, h*0.017),
                              ),
                            ),
                            TableCell(
                              child: Padding(
                                padding:  EdgeInsets.all(w*0.03),
                                child: text(widget.productPrice,Colors.green, FontWeight.normal, h*0.017),
                              ),
                            ),
                          ]
                      ),
                      TableRow(
                          children: [
                            TableCell(
                              child: Padding(
                                padding:  EdgeInsets.all(w*0.03),
                                child: text('Sku',Colors.green, FontWeight.bold, h*0.017),
                              ),
                            ),
                            TableCell(
                              child: Padding(
                                padding:  EdgeInsets.all(w*0.03),
                                child: text(widget.productSku,Colors.green, FontWeight.normal, h*0.017),
                              ),
                            ),
                          ]
                      ),
                      TableRow(
                          children: [
                            TableCell(
                              child: Padding(
                                padding:  EdgeInsets.all(w*0.03),
                                child: text('Barcode',Colors.green, FontWeight.bold, h*0.017),
                              ),
                            ),
                            TableCell(
                              child: Padding(
                                padding:  EdgeInsets.all(w*0.03),
                                child: text(widget.productBarcode,Colors.green, FontWeight.normal, h*0.017),
                              ),
                            ),
                          ]
                      ),
                      TableRow(
                          children: [
                            TableCell(
                              child: Padding(
                                padding:  EdgeInsets.all(w*0.03),
                                child: text('Unit',Colors.green, FontWeight.bold, h*0.017),
                              ),
                            ),
                            TableCell(
                              child: Padding(
                                padding:  EdgeInsets.all(w*0.03),
                                child: text(widget.productUnit,Colors.green, FontWeight.normal, h*0.017),
                              ),
                            ),
                          ]
                      ),

                      TableRow(
                          children: [
                            TableCell(
                              child: Padding(
                                padding:  EdgeInsets.all(w*0.03),
                                child: text('Packaging',Colors.green, FontWeight.bold, h*0.017),
                              ),
                            ),
                            TableCell(
                              child: Padding(
                                padding:  EdgeInsets.all(w*0.03),
                                child: text(widget.productPackiging,Colors.green, FontWeight.normal, h*0.017),
                              ),
                            ),
                          ]
                      ),



                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),

    );
  }
}
