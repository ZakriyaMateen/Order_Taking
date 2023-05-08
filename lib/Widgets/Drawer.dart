import 'package:app2/Screens/BrandScreens/AllOrders.dart';
import 'package:app2/Screens/BrandScreens/OrderAllShops.dart';
import 'package:app2/Widgets/text.dart';
import 'package:flutter/material.dart';

import '../Screens/ShopScreens/EnterQuantitiesForSelectedProducts.dart';
import '../Utils/Transition.dart';

Widget drawer(double h,double w,BuildContext context,String brandUid){
  return Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: [
        Container(height: h*0.2,)
,        ListTile(
          leading: Icon(Icons.delivery_dining),
          title: text('Current Orders', Colors.grey[700]!, FontWeight.normal,h*0.016),
          onTap: () {                      navigateWithTransition(context, OrderAllShops(brandUid: brandUid), TransitionType.slideTopToBottom);


          },
        ),
        Divider(),

        ListTile(
          leading: Icon(Icons.account_circle),
            title: text('Confirmations', Colors.grey[700]!, FontWeight.normal,h*0.016),
          onTap: () {
            // Add navigation logic here
          },
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.settings),
          title: Text('Privacy Policy'),
          onTap: () {
            // Add navigation logic here
          },
        ),
        Divider(),

        ListTile(
          leading: Icon(Icons.help),
          title: Text('Help'),
          onTap: () {
            // Add navigation logic here
          },
        ),
      ],
    ),
  );

}