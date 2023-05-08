import 'package:app2/Utils/Transition.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';

import '../../Widgets/text.dart';
import '../BrandScreens/EditCustomer.dart';
import 'EditCustomerForCustomer.dart';
class DirectViewCustomerShop extends StatefulWidget {
 final  String shopName;
 final  String address;
 final  String contact;
 final  String email;
 final  String password;
 final  String vat;
 final String brandUid,clientUid;
  const DirectViewCustomerShop({Key? key, required this.shopName, required this.address, required this.contact, required this.email, required this.password, required this.vat, required this.brandUid, required this.clientUid}) : super(key: key);

  @override
  State<DirectViewCustomerShop> createState() => _DirectViewCustomerShopState();
}

class _DirectViewCustomerShopState extends State<DirectViewCustomerShop> {


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
        title:
        text(widget.shopName,Colors.white, FontWeight.bold, h*0.018),



      ),
      body: SingleChildScrollView(
        child: Padding(
          padding:  EdgeInsets.symmetric(horizontal: w*0.05),
          child: Column(
            children: [
              SizedBox(height: h*0.067,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Container(
                  //   decoration: BoxDecoration(
                  //       borderRadius: BorderRadius.circular(200),
                  //       border: Border.all(color: Colors.green[800]!,width: 2)
                  //   ),
                  //   width: h*0.08,
                  //   height: h*0.08,
                  //   child: ClipRRect(
                  //     borderRadius: BorderRadius.circular(200),
                  //     child: FancyShimmerImage(imageUrl: "https://media.istockphoto.com/id/1206800961/photo/online-shopping-and-payment-man-using-tablet-with-shopping-cart-icon-digital-marketing.jpg?b=1&s=170667a&w=0&k=20&c=RT5aV_p3DgMk16-QH26DmzNj_uHaq7hkKR0UapnHL2I=",
                  //       boxDecoration: BoxDecoration(
                  //         borderRadius: BorderRadius.circular(200),
                  //       ),
                  //       errorWidget: Icon(Icons.error,color: Colors.grey[400],size: h*0.06,),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
              SizedBox(height: h*0.07,),



              Table(

                border: TableBorder.all(color: Colors.green[200]!,borderRadius: BorderRadius.circular(10)), // adds borders around the table and cells
                children: [
                  TableRow(
                    children: [
                      TableCell(
                        child: Padding(
                          padding:  EdgeInsets.all(w*0.03),
                          child: text('Name      ', Colors.green[800]!, FontWeight.bold, h*0.018),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding:  EdgeInsets.all(w*0.03),
                          child: text(widget.shopName, Colors.green, FontWeight.normal, h*0.017),
                        ),

                      ),

                    ],
                  ),
                  TableRow(
                    children: [
                      TableCell(
                        child: Padding(
                          padding:  EdgeInsets.all(w*0.03),
                          child: text('Contact      ', Colors.green[800]!, FontWeight.bold, h*0.018),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding:  EdgeInsets.all(w*0.03),
                          child: text(widget.contact, Colors.green, FontWeight.normal, h*0.017),
                        ),

                      ),

                    ],
                  ),   TableRow(
                    children: [
                      TableCell(
                        child: Padding(
                          padding:  EdgeInsets.all(w*0.03),
                          child: text('Address      ', Colors.green[800]!, FontWeight.bold, h*0.018),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding:  EdgeInsets.all(w*0.03),
                          child: text(widget.address, Colors.green, FontWeight.normal, h*0.017),
                        ),

                      ),

                    ],
                  ),   TableRow(
                    children: [
                      TableCell(
                        child: Padding(
                          padding:  EdgeInsets.all(w*0.03),
                          child: text('Email      ', Colors.green[800]!, FontWeight.bold, h*0.018),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding:  EdgeInsets.all(w*0.03),
                          child: text(widget.email, Colors.green, FontWeight.normal, h*0.017),
                        ),

                      ),

                    ],
                  ),      TableRow(
                    children: [
                      TableCell(
                        child: Padding(
                          padding:  EdgeInsets.all(w*0.03),
                          child: text('Password      ', Colors.green[800]!, FontWeight.bold, h*0.018),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding:  EdgeInsets.all(w*0.03),
                          child: text(widget.password, Colors.green, FontWeight.normal, h*0.017),
                        ),

                      ),

                    ],
                  ),TableRow(
                    children: [
                      TableCell(
                        child: Padding(
                          padding:  EdgeInsets.all(w*0.03),
                          child: text('Vat      ', Colors.green[800]!, FontWeight.bold, h*0.018),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding:  EdgeInsets.all(w*0.03),
                          child: text(widget.vat, Colors.green, FontWeight.normal, h*0.017),
                        ),

                      ),

                    ],
                  ),
                ],
              ),

              SizedBox(height: h*0.08,),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                    minimumSize: Size(w,h*0.045),
                    side: BorderSide(color: Colors.green[800]!),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)
                    )
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    text("Edit", Colors.green, FontWeight.bold, h*0.018),
                    SizedBox(width: w*0.02,),
                    Icon(Icons.edit,color: Colors.green[800],)
                  ],
                ),

                onPressed: () {
                        navigateWithTransition(context, EditCustomerForCustomer(clientUid:widget.clientUid, brandUid:widget.brandUid,), TransitionType.slideRightToLeft);
                },
              ),





            ],
          ),
        ),
      ),
    );
  }
}
