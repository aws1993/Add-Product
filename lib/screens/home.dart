import 'package:addproduct/provider/auth.dart';
import 'package:addproduct/provider/products.dart';
import 'package:addproduct/screens/add_product.dart';
import 'package:addproduct/screens/product_details.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';



class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _isLoading =true ;
  @override
  void initState() {
    // TODO: implement initState
    Provider.of<Products>(context ,listen: false).fetchData().then((_) => _isLoading=false);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    List prodList = Provider.of<Products>(context, listen: true).productList;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text("products" ,style: TextStyle(color: Colors.black),),
        actions: [
          TextButton(onPressed: ()=>Provider.of<Auth>(context,listen: false).logout(), child: Text('Logout')),
        ],
      ),
      body:_isLoading?Center(child: CircularProgressIndicator(),) :(prodList.isEmpty
          ? Center(
        child: Text(
          'No Product',
          style: TextStyle(fontSize: 20),
        ),
      )
          : RefreshIndicator(
        onRefresh:()=> Provider.of<Products>(context ,listen: false).fetchData(),
            child: ListView(
        children: prodList
              .map((item) => Builder(
              builder: (ctx) => detailCard(item.id, item.title,item.description,
                  item.price, item.image, ctx)))
              .toList(),
      ),
          )),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.amber,
        ),
        width: 180,
        child: FlatButton.icon(
            onPressed: () => Navigator.push(
                context, MaterialPageRoute(builder: (context) => AddProduct())),
            icon: Icon(Icons.add),
            label: Text('add Product')),
      ),
    );
  }

  Widget detailCard(id, title,desc ,price, image, ctx) {
    return FlatButton(
      onPressed: () => Navigator.push(
          ctx, MaterialPageRoute(builder: (_) => ProductDetail(id))),
      child: Column(
        children: [
          SizedBox(
            height: 5,
          ),
          Card(
            color: Colors.black12,
            elevation: 10,
            child: Row(
              children: [
                Expanded(
                    flex: 3,
                    child: Container(
                      width: 150,
                      padding: EdgeInsets.only(right: 10),
                      child: Hero(
                        tag: id,
                        child: Image.network(
                          image,
                          fit: BoxFit.fill,
                        ),
                      ),
                    )),
                Expanded(
                    flex: 3,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          title,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                        Divider(
                          color: Colors.white,
                        ),
                        Container(
                          width: 200,
                          child: Text(
                            desc,style: TextStyle(color: Colors.white,fontSize: 14),
                            softWrap: true,
                            maxLines: 3,
                            textAlign: TextAlign.justify,
                            overflow: TextOverflow.fade,
                          ),
                        ),
                        Divider(color: Colors.white,),
                        Text("\$ $price" ,style: TextStyle(color: Colors.white,fontSize: 18),),
                        SizedBox(height: 13,)
                      ],
                    )),
                Expanded(
                    flex: 1,
                    child: Icon(Icons.arrow_forward_ios)),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget buildPostion(title, description, price) {
    var desc = description.length > 20
        ? description.replaceRange(20, description.length, "....")
        : description;
    return Positioned(
        bottom: 10,
        right: 10,
        child: Container(
          color: Colors.black54,
          margin: EdgeInsets.only(top: 20, left: 100),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Text(
            '$title \n$desc\n\$$price',
            style: TextStyle(fontSize: 22, color: Colors.white),
            overflow: TextOverflow.fade,
            maxLines: 4,
            softWrap: true,
          ),
        ));
  }
}