import 'package:app2/Utils/Transition.dart';
import 'package:app2/Widgets/ZoomableImageScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';

import '../../Widgets/text.dart';
import 'EditBrand.dart';


class ViewBrand extends StatefulWidget {
  final String brandUid;
  const ViewBrand({Key? key, required this.brandUid}) : super(key: key);

  @override
  State<ViewBrand> createState() => _ViewBrandState();
}

class _ViewBrandState extends State<ViewBrand> {
  String Name='';
  String Email='';
  String Contact='';
  String Vat='';
  String Address='';
  bool isLoading =true;
  bool errorOccurred=false;
  String _imageUrl='';
  Future<void> getBrandInfo()async{
    if(widget.brandUid==null){
      print('null uid recieved');
    }
    else{
      print(widget.brandUid);
    }
    try {
      // get the document reference
      DocumentReference docRef =await FirebaseFirestore.instance.collection(widget.brandUid).doc(widget.brandUid).collection('BrandInfo').doc(widget.brandUid);
      // get the document snapshot
      DocumentSnapshot docSnap = await docRef.get();
      // get the email and password fields from the document
      Name = docSnap.get('Name');
      Email = docSnap.get('Email');
      Address = docSnap.get('Address');
      Contact = docSnap.get('Contact');
      Vat = docSnap.get('Vat');
      _imageUrl=docSnap.get('Logo');

      setState(() {
        isLoading=false;
      });
    } catch (e) {
      print('Error: $e');
      setState(() {
        errorOccurred=true;
      });

    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getBrandInfo();
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
          title: text('Details',Colors.white, FontWeight.bold, h*0.018)
      ),
      body:isLoading?Center(child: CircularProgressIndicator(color: Colors.green,),):errorOccurred?Center(child: text('Please try again later!', Colors.grey[700]!, FontWeight.normal, h*0.015),) :
      SingleChildScrollView(
        child: Padding(
          padding:  EdgeInsets.symmetric(horizontal: w*0.05),
          child: Column(
            children: [
              SizedBox(height: h*0.067,),
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
                        navigateWithTransition(context,ZoomableImageScreen(imageUrl: _imageUrl),TransitionType.scale);
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(200),
                        child: FancyShimmerImage(

                          imageUrl:_imageUrl!=""?_imageUrl: "https://media.istockphoto.com/id/1206800961/photo/online-shopping-and-payment-man-using-tablet-with-shopping-cart-icon-digital-marketing.jpg?b=1&s=170667a&w=0&k=20&c=RT5aV_p3DgMk16-QH26DmzNj_uHaq7hkKR0UapnHL2I=",
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
              SizedBox(height: h*0.07,),



              Table(

                border: TableBorder.all(color: Colors.green[200]!,borderRadius: BorderRadius.circular(12)), // adds borders around the table and cells
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
                  navigateWithTransition(context, EditBrand(brandUid: widget.brandUid),TransitionType.slideTopToBottom);
                  // Navigator.push(context, MaterialPageRoute(builder: (context)=>EditBrand(brandUid: widget.brandUid,)));

                },
              ),





            ],
          ),
        ),
      ),
    );
  }
}
