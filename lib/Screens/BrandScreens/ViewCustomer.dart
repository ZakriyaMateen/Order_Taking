import 'package:app2/Screens/BrandScreens/EditCustomer.dart';
import 'package:app2/Screens/BrandScreens/SetClientProducts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../Widgets/text.dart';


class ViewCustomer extends StatefulWidget {
  final String clientUid;
  const ViewCustomer({Key? key, required this.clientUid}) : super(key: key);

  @override
  State<ViewCustomer> createState() => _ViewCustomerState();
}

class _ViewCustomerState extends State<ViewCustomer> {
  bool isLoading=true;
  String Name="";
  String Contact="";
  String Address="";
  String Email="";
  String Vat="";
  String brandUid='';

  Future<void> getClientData()async{

    try{
      print(widget.clientUid);
      setState(() {
        isLoading=true;
      });
      DocumentSnapshot snapshot=await FirebaseFirestore.instance.collection("Clients").doc(widget.clientUid).get();
      if(snapshot.exists){
        Name=snapshot.get('Name');
        Contact=snapshot.get('Contact');
        Address=snapshot.get('Address');
        Vat=snapshot.get("Vat");
        Email=snapshot.get("Email");
        brandUid=snapshot.get('BrandUid');
        setState(() {
          isLoading=false;
        });
      }
      else{
        setState(() {
          isLoading=false;
        });
      }

    }catch(e){

      setState(() {
        isLoading=false;
      });
      Fluttertoast.showToast(msg: e.toString());
      print(e.toString());
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getClientData();
  }

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
                text('Client Name',Colors.white, FontWeight.bold, h*0.018),



      ),
      body: isLoading?Center(child:CircularProgressIndicator()):SingleChildScrollView(
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
                          child: text(Name, Colors.green, FontWeight.normal, h*0.017),
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
                          child: text(Contact, Colors.green, FontWeight.normal, h*0.017),
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
                          child: text(Address, Colors.green, FontWeight.normal, h*0.017),
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
                          child: text(Email, Colors.green, FontWeight.normal, h*0.017),
                        ),

                      ),

                    ],
                  ),   TableRow(
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
                          child: text(Vat, Colors.green, FontWeight.normal, h*0.017),
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
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>EditCustomer(clientUid:widget.clientUid, brandUid:brandUid,)));
                },
              ),





            ],
          ),
        ),
      ),
    );
  }
}
