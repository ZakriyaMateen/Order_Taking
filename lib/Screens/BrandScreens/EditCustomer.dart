import 'package:app2/Screens/BrandScreens/ViewCustomer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../Widgets/text.dart';
class EditCustomer extends StatefulWidget {
  final String clientUid;
  final String brandUid;
  const EditCustomer({Key? key, required this.clientUid, required this.brandUid}) : super(key: key);
  @override
  State<EditCustomer> createState() => _EditCustomerState();
}
class _EditCustomerState extends State<EditCustomer> {
  TextEditingController nameController=TextEditingController();
  TextEditingController contactController=TextEditingController();
  TextEditingController addressController=TextEditingController();
  TextEditingController emailController=TextEditingController();
  TextEditingController vatController=TextEditingController();
  TextEditingController passwordController=TextEditingController();
  bool isLoading=true;
  final _formKey=GlobalKey<FormState>();
  String brandUid='';
  Future<void> getClientData()async{
    try{
      print(widget.clientUid);
      setState(() {
        isLoading=true;
      });
      DocumentSnapshot snapshot=await FirebaseFirestore.instance.collection("Clients").doc(widget.clientUid).get();
      if(snapshot.exists){
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
          title: text('Edit Client',Colors.white, FontWeight.bold, h*0.018)
      ),
      body:isLoading?Center(child:CircularProgressIndicator (),): Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: w*0.05),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: h*0.067,),
                Align(alignment:Alignment.center,child: text('Editing Client', Colors.green[600]!, FontWeight.bold, h*0.02)),
                SizedBox(height: h*0.07,),
                TextFormField(
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(color: Colors.grey[800], letterSpacing: .5,fontWeight: FontWeight.normal,fontSize: h*0.017),
                  ),
                  controller: nameController,
                  decoration: InputDecoration(
                    label: text('Name', Colors.grey[800]!,FontWeight.normal, h*0.017),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)
                    ),
                    enabledBorder:  OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green,width: 1),
                        borderRadius: BorderRadius.circular(20)),
                    focusedBorder:   OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green,width: 1.5),
                        borderRadius: BorderRadius.circular(20)),
                    prefixIcon: Icon(Icons.person,color: Colors.green,),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value!.length<2) {
                      return 'Please enter a name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: h*0.018),
                TextFormField(
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(color: Colors.grey[800], letterSpacing: .5,fontWeight: FontWeight.normal,fontSize: h*0.017),
                  ),
                  controller: contactController,
                  keyboardType: TextInputType.phone,

                  decoration: InputDecoration(
                    label: text('Contact', Colors.grey[800]!,FontWeight.normal, h*0.017),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)
                    ),
                    enabledBorder:  OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green,width: 1),
                        borderRadius: BorderRadius.circular(20)),
                    focusedBorder:   OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green,width: 1.5),
                        borderRadius: BorderRadius.circular(20)),
                    prefixIcon: Icon(Icons.phone,color: Colors.green,),
                  ),
                  validator: (value) {
                    if (value!.length!=11) {
                      return 'Please enter a valid contact';
                    }
                    return null;
                  },
                ),
                SizedBox(height: h*0.018),
                TextFormField(
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(color: Colors.grey[800], letterSpacing: .5,fontWeight: FontWeight.normal,fontSize: h*0.017),
                  ),
                  controller: addressController,
                  decoration: InputDecoration(
                    label: text('Address', Colors.grey[800]!,FontWeight.normal, h*0.017),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)
                    ),
                    enabledBorder:  OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green,width: 1),
                        borderRadius: BorderRadius.circular(20)),
                    focusedBorder:   OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green,width: 1.5),
                        borderRadius: BorderRadius.circular(20)),
                    prefixIcon: Icon(Icons.location_on,color: Colors.green,),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value!.length<2) {
                      return 'Please give the location';
                    }
                    return null;
                  },
                ),
                SizedBox(height: h*0.018),
                TextFormField(
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(color: Colors.grey[800], letterSpacing: .5,fontWeight: FontWeight.normal,fontSize: h*0.017),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  controller: vatController,
                  decoration: InputDecoration(
                    label: text('Vat', Colors.grey[800]!,FontWeight.normal, h*0.017),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)
                    ),
                    enabledBorder:  OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green,width: 1),
                        borderRadius: BorderRadius.circular(20)),
                    focusedBorder:   OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green,width: 1.5),
                        borderRadius: BorderRadius.circular(20)),
                    prefixIcon: Icon(Icons.local_activity,color: Colors.green,),
                  ),
                  validator: (value) {
                    if (value!.length<2) {
                      return 'Please enter your vat';
                    }
                    return null;
                  },
                ),
                SizedBox(height: h*0.018),
                SizedBox(height: h*0.05),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                      minimumSize: Size(w,h*0.045),
                      side: BorderSide(color: Colors.green[800]!),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)
                      )
                  ),
                  child: text("Save", Colors.green, FontWeight.bold, h*0.018),

                  onPressed: () async{
                    if (_formKey.currentState!.validate()) {
                      //TODO: Implement authentication logic
                        setState(() {
                          isLoading=true;
                        });
                      String clientName=nameController.text.toString();
                      String clientAddress=addressController.text.toString();
                      String clientVat=vatController.text.toString();
                      String clientContact=contactController.text.toString();
                      try{
                        await FirebaseFirestore.instance.collection(brandUid).doc(widget.clientUid).update({
                          "Name":clientName,
                        }).then((value)async {
                          await FirebaseFirestore.instance.collection(widget.brandUid).doc(widget.clientUid).update({
    "Name":clientName,
    "BrandUid":widget.brandUid,
    "ClientUid":widget.clientUid
    });
    });
    await FirebaseFirestore.instance.collection('Clients').doc(widget.clientUid).update(
    {"ClientUid":widget.clientUid,
    "Name":clientName,
    "Address":clientAddress,
    "Vat":clientVat,
    "Contact":clientContact,
    "BrandUid":widget.brandUid,
    });
                          Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>ViewCustomer(clientUid: widget.clientUid)));
                        setState(() {isLoading=false;});} catch(e){setState(() {isLoading=false;});print (e.toString());
                      }
                    }
                  },
                ),
                //add logo
              ],
            ),
          ),
        ),
      ),
    );
  }
}
