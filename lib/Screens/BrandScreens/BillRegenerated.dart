import 'package:app2/Model/firebaseAuth.dart';
import 'package:app2/Notification.dart';
import 'package:app2/Screens/BrandScreens/AllOrders.dart';
import 'package:app2/Screens/BrandScreens/BrandHomePage.dart';
import 'package:app2/Screens/BrandScreens/OrderAllShops.dart';
import 'package:app2/Screens/BrandScreens/SingleShopAllOrders.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pdfLib;

import '../../Utils/Transition.dart';
import '../../Widgets/text.dart';
import '../ShopScreens/CreateOrder.dart';

class BillRegenerated extends StatefulWidget {
  final String brandUid,clientUid;
  final List<productDetails> list;
  final List<int> quantities;
  final String shopName;
  const BillRegenerated({Key? key, required this.brandUid, required this.clientUid, required this.list, required this.quantities, required this.shopName}) : super(key: key);

  @override
  State<BillRegenerated> createState() => _BillRegeneratedState();
}


class _BillRegeneratedState extends State<BillRegenerated> {
  double ClientVat=0.0;

  double total=0;
  bool isOrdering=true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getClientVat();
  }
  Future<void> generatePdf(Table table) async {
    final pdf = pdfLib.Document();

    try{
      pdf.addPage(
        pdfLib.MultiPage(
          pageFormat: PdfPageFormat.a4,
          build: (context) {
            return <pdfLib.Widget>[
              pdfLib.Header(level: 0, child: pdfLib.Text('Table PDF')),
              pdfLib.Table.fromTextArray(context: context, data: tableToText(table)),
            ];
          },
        ),
      );

      final String dir = (await getApplicationDocumentsDirectory()).path;
      final String path = '$dir/table.pdf';
      final File file = File(path);
      await file.writeAsBytes(await pdf.save());
    }
    catch(e){
      print(e.toString());
    }
  }

  List<List<String>> tableToText(Table table) {
    final List<List<String>> data = <List<String>>[];

    table.children.forEach((row) {
      final List<String> rowData = <String>[];
      row.children!.forEach((cell) {
        rowData.add(cell.toString());
      });
      data.add(rowData);
    });

    return data;
  }
  @override
  Widget build(BuildContext context) {
    double w=MediaQuery.of(context).size.width;
    double h=MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: () async{ return false; },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar:AppBar(
          actions: [IconButton(icon: Icon(Icons.picture_as_pdf,color: Colors.deepOrange,),onPressed: ()async{
            generatePdf(tableRows(h:h, w:w));
          },)],
            automaticallyImplyLeading: false,
            elevation: 0.0,
            backgroundColor: Colors.green[800],
            centerTitle: true,
            title: text('Order Form',Colors.white, FontWeight.bold, h*0.018)
        ),
        body:isOrdering?Center(child: CircularProgressIndicator(color: Colors.green,),): Padding(
            padding: EdgeInsets.symmetric(horizontal: w*0.02,vertical: h*0.005),
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child:
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        Material(
                          color: Colors.white,
                          elevation: 5,
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                              padding: EdgeInsets.symmetric(horizontal: w*0.02,vertical: h*0.08),
                              width: w,
                              decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(20)),

                              child:tableRows(h: h, w: w)
                          ),
                        ),

                      ],
                    ),
                  ),
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
                          onPressed: ()async
                          {
                            //current :
                            // shopUid > add > product_Details
                            setState(() {
                              isOrdering=true;
                            });
                            print(widget.brandUid);
                            print(widget.clientUid);
                            try{

                              Map<String, dynamic> orderMap = {
                                "products": widget.list.asMap().map((i, e) => MapEntry(i.toString(), {
                                  "productName": e.productName,
                                  "productImageUrl": e.productImageUrl,
                                  "productPrice": e.productPrice,
                                  "productSku": e.productSku,
                                  "productBarcode": e.productBarcode,
                                  "productPackiging": e.productPackiging,
                                  "productUnit": e.productUnit,
                                  "brandUid": e.brandUid,
                                  "quantity": widget.quantities[i], // add the quantity here
                                })),
                                "totalAmount": total,
                                "shopUid": widget.clientUid,
                                'Edittable':'no',
                                'Confirmed':'no'
                                // Add any other order details here
                              };

                            print(total);
// Add the order map to the "Order" field
                              await FirebaseFirestore.instance.collection(widget.brandUid).doc(
                                  widget.clientUid
                              ).collection('Orders').doc(widget.clientUid).set({
                                "Order": orderMap,
                                "CurrentOrder":'yes',
                                "Edittable":'no',
                                "Confirmed":'no'
                              }).then((value)async{
                                await FirebaseFirestore.instance.collection(widget.brandUid).doc(widget.clientUid).update(
                                    {
                                      "CurrentOrder":'yes',
                                      "Edittable":'no',
                                      "Confirmed":'no'
                                    });
                                setState(() {
                                  isOrdering=false;
                                });
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Center(child: text("Resent Successfully!",Colors.green, FontWeight.w600, h*0.016)),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20),side: BorderSide(color: Colors.green,width: 1.2)),margin: EdgeInsets.symmetric(horizontal: w*0.05,vertical: h*0.01)
                                  ,padding: EdgeInsets.all(h*0.005),
                                  duration: const Duration(seconds: 5),
                                  showCloseIcon: true,
                                  closeIconColor: Colors.green,
                                  behavior: SnackBarBehavior.floating,
                                  dismissDirection: DismissDirection.vertical,
                                  elevation: 4,
                                  backgroundColor: Colors.white,));

                              }).then((value)async{
                                DocumentSnapshot snap=await FirebaseFirestore.instance.collection('Tokens').doc(widget.clientUid).get();
                                String token=snap['token'];

                                sendPushMessageBrand(token, "Order to be confirmed", "Confirmation",widget.clientUid,widget.brandUid, widget.shopName).then((value){
                                  navigateWithTransition(context, BrandHomePage(brandUid: widget.brandUid,), TransitionType.slideRightToLeft);
                                });


                              });
                            }
                            catch(e){

                              setState(() {
                                isOrdering=false;
                              });
                              print(e);
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Center(child: text("Error : "+e.toString(),Colors.red, FontWeight.w600, h*0.016)),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20),side: BorderSide(color: Colors.red,width: 1.2)),margin: EdgeInsets.symmetric(horizontal: w*0.05,vertical: h*0.01)
                                ,padding: EdgeInsets.all(h*0.005),
                                duration: const Duration(seconds: 5),
                                showCloseIcon: true,
                                closeIconColor: Colors.red,
                                behavior: SnackBarBehavior.floating,
                                dismissDirection: DismissDirection.vertical,
                                elevation: 4,
                                backgroundColor: Colors.white,));
                            }
                          }, child:text('Resend',Colors.white!, FontWeight.bold,h*0.017)),
                    ),

                  ),
                ),
              ],
            )
        ),
      ),
    );
  }

  Table tableRows({required double h,required double w}){
    List<TableRow> rows = [];

    rows.add(    TableRow(
        children:[
          TableCell(child: Padding(padding: EdgeInsets.all(h*0.01),
            child: text('Item', Colors.green[900]!, FontWeight.bold,h*0.018),),verticalAlignment: TableCellVerticalAlignment.middle,)
          ,
          TableCell(child: Padding(padding: EdgeInsets.all(h*0.01),
            child: text('Price', Colors.green[900]!, FontWeight.bold,h*0.018),),verticalAlignment: TableCellVerticalAlignment.middle,),
          TableCell(child: Padding(padding: EdgeInsets.all(h*0.01),
            child: text('Qt', Colors.green[900]!, FontWeight.bold,h*0.018),),verticalAlignment: TableCellVerticalAlignment.middle,),
          TableCell(child: Padding(padding: EdgeInsets.all(h*0.01),
            child: text('Total', Colors.green[900]!, FontWeight.bold,h*0.018),),verticalAlignment: TableCellVerticalAlignment.middle,),
        ]
    ),
    );
    for (var i = 0; i < widget.list.length; i++) {
      var e = widget.list[i];
      total+=double.parse(e.productPrice.toString())*widget.quantities[i];
      rows.add(
        TableRow(
          children: [
            TableCell(
              child: Padding(
                padding: EdgeInsets.all(h*0.01),
                child: text(e.productName, Colors.green[700]!, FontWeight.normal,h*0.0165),
              ),
              verticalAlignment: TableCellVerticalAlignment.middle,
            ),
            TableCell(
              child: Padding(
                padding: EdgeInsets.all(h*0.01),
                child: text(e.productPrice.toString(), Colors.green[700]!, FontWeight.normal,h*0.0165),
              ),
              verticalAlignment: TableCellVerticalAlignment.middle,
            ),
            TableCell(
              child: Padding(
                padding: EdgeInsets.all(h*0.01),
                child: text(widget.quantities[i].toString(), Colors.green[700]!, FontWeight.normal,h*0.0165),
              ),
              verticalAlignment: TableCellVerticalAlignment.middle,
            ),
            TableCell(
              child: Padding(
                padding: EdgeInsets.all(h*0.01),
                child: text((double.parse(e.productPrice.toString())*widget.quantities[i]).toStringAsFixed(2), Colors.green[700]!, FontWeight.normal,h*0.0165),
              ),
              verticalAlignment: TableCellVerticalAlignment.middle,
            ),
          ],
        ),
      );
    }
    double totalWithVat=0;
    double  clientVatPercentage=ClientVat/100;
    totalWithVat=total+total*clientVatPercentage;
    rows.add(    TableRow(
        children:[
          TableCell(child: Padding(padding: EdgeInsets.all(h*0.01),
            child: text('Vat', Colors.green[900]!, FontWeight.bold,h*0.018),),verticalAlignment: TableCellVerticalAlignment.middle,)
          , TableCell(child: Padding(padding: EdgeInsets.all(h*0.01),
            child: text(ClientVat.toString() + " %", Colors.green[900]!, FontWeight.bold,h*0.018),),verticalAlignment: TableCellVerticalAlignment.middle,),
          TableCell(child: Padding(padding: EdgeInsets.all(h*0.01),
            child: text('Total', Colors.green[900]!, FontWeight.bold,h*0.018),),verticalAlignment: TableCellVerticalAlignment.middle,),
          TableCell(child: Padding(padding: EdgeInsets.all(h*0.01),
            child: text(totalWithVat.toStringAsFixed(2), Colors.green[900]!, FontWeight.bold,h*0.018),),verticalAlignment: TableCellVerticalAlignment.middle,),
        ]
    ),
    );
    return Table(
      border: TableBorder.all(color: Colors.green[800]!,borderRadius: BorderRadius.circular(12),width: 1.1),
      children: rows,
    );

  }
  getClientVat()async{
    try{

      DocumentSnapshot snap= await FirebaseFirestore.instance.collection('Clients').doc(widget.clientUid).get();
      ClientVat=double.parse(snap["Vat"]);
      setState(() {
        isOrdering=false;
      });

    }
    catch(e){
      setState(() {
        isOrdering=false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("No shop found !")));
    }
  }
}
