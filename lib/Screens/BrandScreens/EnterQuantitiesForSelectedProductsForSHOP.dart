import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../Utils/Transition.dart';
import '../../Widgets/text.dart';
import '../ShopScreens/BillScreen.dart';
import '../ShopScreens/CreateOrder.dart';
import 'BillRegenerated.dart';

class EnterQuantitiesForSelectedProductsForSHOP extends StatefulWidget {
  final String brandUid,clientUid;
  final List<productDetails> list;
  final List<String> quantities;
  final String shopName;
  const EnterQuantitiesForSelectedProductsForSHOP({Key? key, required this.brandUid, required this.clientUid, required this.list, required this.shopName, required this.quantities}) : super(key: key);

  @override
  State<EnterQuantitiesForSelectedProductsForSHOP> createState() => _EnterQuantitiesForSelectedProductsForSHOPState();
}

class _EnterQuantitiesForSelectedProductsForSHOPState extends State<EnterQuantitiesForSelectedProductsForSHOP> {
  List<TextEditingController> l=[];

  List<int> quantities=[];
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
            title: text('Enter Quantities',Colors.white, FontWeight.bold, h*0.018)
        ),

        body: Stack(children: [
          Align(
            alignment: Alignment.topCenter,
            child: ListView.builder(itemBuilder: (context,index){
              l.add(TextEditingController(text: widget.quantities[index]));
              return Padding(
                padding:  EdgeInsets.symmetric(horizontal:w*0.05,vertical: h*0.005),

                child: Material(
                  elevation: 4,
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  child: Container(

                    width: w,
                    padding: EdgeInsets.symmetric(vertical: h*0.005),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color:  Colors.white
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: w*0.05,vertical:h*0.014 ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: w*0.46,
                            child: Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Container(
                                      width: w * 0.46 - (h * 0.0165) * 2 - 16, // subtract the space for the colon, padding and the size of the quantity row
                                      child:      RichText(
                                        text: TextSpan(
                                          text: "Name : ",
                                          style: TextStyle(
                                              color: Colors.grey[800]!,
                                              fontWeight: FontWeight.bold,
                                              fontSize: h*0.0165
                                          ),
                                          children: [
                                            TextSpan(
                                              text: widget.list[index].productName,
                                              style: TextStyle(
                                                color: Colors.grey[800]!,
                                                fontWeight: FontWeight.normal,
                                                fontSize: h*0.0165,
                                              ),
                                            ),
                                          ],
                                        ),
                                        overflow: TextOverflow.clip,
                                        maxLines: 3,
                                      ),
                                    ),
                                    RichText(
                                      text: TextSpan(
                                        text: "Price : ",
                                        style: TextStyle(
                                          color: Colors.grey[800]!,
                                          fontWeight: FontWeight.bold,
                                          fontSize: h * 0.0165,
                                        ),
                                        children: [
                                          TextSpan(
                                            text: widget.list[index].productPrice,
                                            style: TextStyle(
                                              color: Colors.grey[800]!,
                                              fontWeight: FontWeight.normal,
                                              fontSize: h * 0.0165,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),                                ],
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              IconButton(onPressed: (){


                                if(int.parse(l[index].text)!=1){
                                  l[index].text=(int.parse(l[index].text)-1).toString();}
                              }, icon:Icon(Icons.remove,color: Colors.red,)),
                              Container(
                                width: w*0.07,
                                child: TextFormField(
                                  keyboardType:TextInputType.number,
                                  controller: l[index],
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(RegExp(r'[1-9][0-9]*')),
                                  ],
                                ),
                              ),
                              IconButton(onPressed: (){
                                l[index].text=(int.parse(l[index].text)+1).toString();
                              }, icon:Icon(Icons.add,color: Colors.green,)),

                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },itemCount: widget.list.length),
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
                    onPressed: ()
                    {
                      for(var i in l){
                        quantities.add(int.parse(i.text.toString()));
                      }

                      navigateWithTransition(context, BillRegenerated(list:widget.list, quantities: quantities,brandUid:widget.brandUid,clientUid:widget.clientUid, shopName:  widget.shopName,), TransitionType.slideRightToLeft);

                    }, child:text('Generate Bill',Colors.white!, FontWeight.bold,h*0.017)),
              ),

            ),
          ),
        ],)
    );
  }
}
