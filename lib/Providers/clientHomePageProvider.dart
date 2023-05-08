
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class ShopDetails {
  String brandUid = '';
  String shopName = 'unknown';
  String address = 'unknown';
  String contact = 'unknown';
  String email = 'unknown';
  String password = 'unknown';
  String vat = 'unknown';
}

class ShopProvider with ChangeNotifier {
  ShopDetails _shopDetails = ShopDetails();
  bool _isLoading = true;
  bool _hasError = false;

  ShopDetails get shopDetails => _shopDetails;
  bool get isLoading => _isLoading;
  bool get hasError => _hasError;

  Future<void> getShopDetails(String clientUid) async {
    try {
      try {
        FirebaseFirestore.instance
            .collection(clientUid)
            .limit(1)
            .get()
            .then((QuerySnapshot snapshot) {
          if (snapshot.docs.isNotEmpty) {
            _shopDetails.brandUid = snapshot.docs.first.get('brandUid');
          } else {
            print('No documents in the collection');
          }
        }).catchError((error) => print('Error getting documents: $error'));
      } catch (e) {
        print(e.toString());
      }
      var ref =
      await FirebaseFirestore.instance.collection('Clients').doc(clientUid).get();
      _shopDetails.shopName = ref.get('Name');
      _shopDetails.address = ref.get('Address');
      _shopDetails.contact = ref.get('Contact');
      _shopDetails.email = ref.get('Email');
      _shopDetails.vat = ref.get('Vat');
      _shopDetails.password = ref.get('Password');
      print(_shopDetails.shopName);
      _isLoading = false;
    } catch (e) {
      _isLoading = false;
      _hasError = true;
      print(e);
    }
    notifyListeners();
  }
}