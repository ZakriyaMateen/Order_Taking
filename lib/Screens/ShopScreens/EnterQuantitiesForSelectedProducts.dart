import 'dart:convert';

import 'package:app2/Screens/ShopScreens/BillScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart'as http;
import '../../Utils/Transition.dart';
import '../../Widgets/text.dart';
import 'CreateOrder.dart';
import 'DisplaySingleProductInfo.dart';


class EnterQuantitiesForSelectedProducts extends StatefulWidget {
  final String shopName;
  final List<productDetails> list;
  final String clientVat;
  final String brandCurrency;
  final String clientCurrency;
  final Map<String, dynamic> currencyRates;
  const EnterQuantitiesForSelectedProducts({Key? key, required this.list, required this.shopName, required this.clientVat, required this.brandCurrency, required this.clientCurrency, required this.currencyRates}) : super(key: key);

  @override
  State<EnterQuantitiesForSelectedProducts> createState() => _EnterQuantitiesForSelectedProductsState();
}

class _EnterQuantitiesForSelectedProductsState extends State<EnterQuantitiesForSelectedProducts> {
    List<TextEditingController> l=[];
    List<int> quantities=[];
    



    bool isLoading=true;
    convert({required double amount}) {

      final double fromCurrencyRate =
      widget.currencyRates[widget.brandCurrency].toDouble();
      final double toCurrencyRate =
      widget.currencyRates[widget.clientCurrency].toDouble();
      final double convertedAmount =
          (amount / fromCurrencyRate) * toCurrencyRate;
      final String message =
          "${convertedAmount.toStringAsFixed(2)}" + " "+ widget.clientCurrency;
      // ${amount.toStringAsFixed(2)} $brandCurrency =
      return message;
    }
    // @override
    // void initState() {
    //
    //   // TODO: implement initState
    //   super.initState();
    //
    //   print(convert(amount: 21));
    // }

    //to here
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
            l.add(TextEditingController(text: '1'));
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
                                      width: w * 0.46 - (h * 0.0165) * 2 - 16, 
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
                                          text: convert(amount: double.parse(widget.list[index].productPrice)),
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

                               navigateWithTransition(context, BillScreen(clientVat:widget.clientVat,list:widget.list, quantities: quantities, shopName: widget.shopName, currencyRates: widget.currencyRates, brandCurrency: widget.brandCurrency, clientCurrency: widget.clientCurrency, ), TransitionType.slideRightToLeft);

                          }, child:text('Generate Bill',Colors.white!, FontWeight.bold,h*0.017)),
            ),

          ),
        ),
      ],)
    );
  }
}
