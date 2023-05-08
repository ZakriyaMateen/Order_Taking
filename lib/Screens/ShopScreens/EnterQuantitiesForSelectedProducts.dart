import 'package:app2/Screens/ShopScreens/BillScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../Utils/Transition.dart';
import '../../Widgets/text.dart';
import 'CreateOrder.dart';
import 'DisplaySingleProductInfo.dart';


class EnterQuantitiesForSelectedProducts extends StatefulWidget {
  final String shopName;
  final List<productDetails> list;
  const EnterQuantitiesForSelectedProducts({Key? key, required this.list, required this.shopName}) : super(key: key);

  @override
  State<EnterQuantitiesForSelectedProducts> createState() => _EnterQuantitiesForSelectedProductsState();
}

class _EnterQuantitiesForSelectedProductsState extends State<EnterQuantitiesForSelectedProducts> {
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
            l.add(TextEditingController(text: '1'));
            return Padding(
              padding:  EdgeInsets.symmetric(horizontal:w*0.05,vertical: h*0.005),

              child: Material(
                elevation: 4,
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                child: Container(

                  width: w,
                  height: h*0.1,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color:  Colors.white
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
                                text(": "+widget.list[index].productName, Colors.grey[800]!, FontWeight.bold, h*0.018),
                                text(": "+widget.list[index].productPrice, Colors.grey[800]!, FontWeight.normal, h*0.018),
                              ],
                            ),
                          ],
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
                            }, icon:Icon(Icons.add,color: Colors.red,)),

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

                               navigateWithTransition(context, BillScreen(list:widget.list, quantities: quantities, shopName: widget.shopName, ), TransitionType.slideRightToLeft);

                          }, child:text('Generate Bill',Colors.white!, FontWeight.bold,h*0.017)),
            ),

          ),
        ),
      ],)
    );
  }
}
