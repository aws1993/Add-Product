import 'dart:io';

import 'package:addproduct/provider/products.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class ProductDetail extends StatefulWidget {
  String id;

  ProductDetail(this.id);

  @override
  _ProductDetailState createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  @override
  Widget build(BuildContext context) {
    var prodList =Provider.of<Products>(context,listen: true).productList;
    var filterItem = prodList.firstWhere((element) => element.id == widget.id ,orElse: ()=> null);
    return Scaffold(
      appBar: AppBar(
        title: filterItem == null ? null :Text(filterItem.title ,style: TextStyle(color: Colors.black),),
        backgroundColor: Colors.amber,
        actions: [
          TextButton(onPressed: ()=> Provider.of<Products>(context,listen: false).updateData(widget.id) , child: Text('update data'))
        ],
      ),
      body: filterItem == null ? null : ListView(
        children: [
          SizedBox(height: 10,),
          buildContainer(filterItem.image , filterItem.id),
          SizedBox(height: 10,),
          buildCard(filterItem.title ,filterItem.description ,filterItem.price)
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.amber,
        onPressed: (){
          Provider.of<Products>(context,listen: false).delete(filterItem.id);
          Navigator.pop(context);
        },
        child: Icon(
          Icons.delete ,color: Colors.black,
        ),
      ),
    );
  }


  buildContainer(String image, String id) {
    return Container(
      width: double.infinity,
      child: Center(
        child: Hero(
          tag:id ,
          child: Image.network(image ,fit: BoxFit.cover,),
        ),
      ),
    );
  }
  buildCard(String title, String description, double price) {
    return Card(
      margin: EdgeInsets.all(7),
     elevation: 10,
      child:Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title , style: TextStyle(fontSize: 18 ,fontWeight: FontWeight.bold),),
            Divider(color: Colors.black54,),
            Text(description , style: TextStyle(fontSize: 15),textAlign: TextAlign.justify,),
            Divider(color: Colors.black54,),
            Text('\$$price' ,style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),)
          ],
        ),
      ) ,
    );
  }




}
