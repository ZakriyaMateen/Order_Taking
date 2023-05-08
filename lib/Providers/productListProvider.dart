import 'package:flutter/foundation.dart';

import '../Screens/ShopScreens/CreateOrder.dart';

class ProductList with ChangeNotifier {
  List<productDetails> _list = [];
  Set<int> _selectedIndices = {}; // initially no items are selected

  List<productDetails> get list => _list;
  Set<int> get selectedIndices => _selectedIndices;

  void toggleSelection(int index, Map<String,dynamic> data) {
      try{
        if (_selectedIndices.contains(index)) {
          _selectedIndices.remove(index);
          _list.removeWhere((p) => p.productName == data['productName']);
        } else {
          _selectedIndices.add(index);
          _list.add(productDetails(
              productName: data['productName'],
              productImageUrl: data['productImageUrl'],
              productPrice: data['productPrice'],
              productSku: data['productSku'],
              productBarcode: data['productBarcode'],
              productPackiging: data['productPackiging'],
              productUnit: data['productUnit'],
              brandUid: data['brandUid'],

          ));
        }
      }
      catch(e){
        print (e.toString());
      }
    notifyListeners();
  }
}
