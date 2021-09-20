import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';

class Product {
  final String id;
  final String title;
  final String description;
  final double price;
  final String image;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.image,
  });
}

class Products with ChangeNotifier {
  List<Product> productList = [];
  String authToken;

  getData(List<Product> prodList ,String authToke){
   productList =prodList;
   authToken =authToke ;
   notifyListeners();
  }// File image;
  Future<void> updateData(String id) async {
    final Uri url = Uri.parse("https://addproduct-486f9-default-rtdb.asia-southeast1.firebasedatabase.app/product/$id.json?auth=$authToken");
    print(id);
    var indexProd = productList.indexWhere( (element) => element.id == id );
    if (indexProd >= 0) {
       await http.patch( url,
          body: json.encode( [
            {
              "id": id,
              "title": 'new title',
              "description": 'new description',
              "price": 12,
              "image": "https://i.pinimg.com/originals/89/86/d6/8986d6bfbb13ab11f47d68e273c9714e.jpg",
            }
          ] ) );
      productList[indexProd] = Product( id: id,
        title: 'new title',
        description: 'new description',
        price: 12,
        image: "https://i.pinimg.com/originals/89/86/d6/8986d6bfbb13ab11f47d68e273c9714e.jpg", );
      notifyListeners();
    }else{
      print('not Found');
    }
  }

  Future<void> fetchData() async {
    try {
      final Uri url = Uri.parse("https://addproduct-486f9-default-rtdb.asia-southeast1.firebasedatabase.app/product.json?auth=$authToken" );
      var res = await http.get( url );

      var resbody = json.decode( res.body ) as Map<String, dynamic>;
      if (resbody == null) {
        productList.isEmpty;
        notifyListeners( );
      }
      else {
        resbody.forEach( (prodId, prodData) {
          var indexProd = productList.indexWhere( (element) => element.id == prodId );
          if(indexProd>=0){
            productList[indexProd] = Product( id: prodId,
              title: 'new title',
              description: 'new description',
              price: 12,
              image: "https://i.pinimg.com/originals/89/86/d6/8986d6bfbb13ab11f47d68e273c9714e.jpg", );

          }
          else {
            productList.add( Product(
                id: prodId,
                title: prodData[0]['title'],
                description: prodData[0]['description'],
                price: prodData[0]['price'],
                image: prodData[0]['image'] ) );

          }
        } );

      }
      notifyListeners( );
    } catch (ee) {
      throw ee;
    }
  }

  Future<void> addProduct({String title, String decs, double price, String image}) async {
    try {
      final Uri url = Uri.parse(
          "https://addproduct-486f9-default-rtdb.asia-southeast1.firebasedatabase.app/product.json?auth=$authToken" );
      var res = await http.post( url,
          body: json.encode( [
            {
              "title": title,
              "description": decs,
              "price": price,
              "image": image,
            }
          ] ) );
      productList.add( Product(
        id: json.decode( res.body )["name"],
        title: title,
        description: decs,
        price: price,
        image: image,
      ) );
      notifyListeners( );
    } catch (ee) {
      throw ee;
    }
  }

  Future<void> delete(String id) async{
    final Uri url = Uri.parse("https://addproduct-486f9-default-rtdb.asia-southeast1.firebasedatabase.app/product/$id.json?auth=$authToken" );
    var prodIndex =productList.indexWhere((element) => element.id==id);
    var prodItem =productList[prodIndex];
    productList.removeAt(prodIndex);
    notifyListeners( );
    var res =await http.delete(url);
    if(res.statusCode >= 400){
      productList.insert(prodIndex, prodItem);
      notifyListeners();
      print('could not delete');
    }else{
      prodItem = null;
      print(' delete');

    }
  }

//  void deleteImage(){
//    image = null ;
// }

// Future getImage(ImageSource src) async{
//   final pickedFile = await ImagePicker().getImage(source: src);
//   if(pickedFile != null){
//     image =File(pickedFile.path);
//     notifyListeners();
//     print('ok image');
//   }else{
//     print('image is null');
//   }
// }
}
