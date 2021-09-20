import 'package:addproduct/provider/products.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';


class AddProduct extends StatefulWidget {
  @override
  _AddProductState createState() => _AddProductState( );
}

class _AddProductState extends State<AddProduct> {
  TextEditingController _titleController = TextEditingController( )
    ..text;
  TextEditingController _decsController = TextEditingController( )
    ..text;
  TextEditingController _priceController = TextEditingController( )
    ..text;
  TextEditingController _imageController = TextEditingController( )
    ..text;
  double _price;
  bool isLoading  =false;



  @override
  Widget build(BuildContext context) {
    //var _image = Provider.of<Products>(context).image;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text( 'add product', style: TextStyle( color: Colors.black ), ),
      ),
      body: isLoading ? Center(child: CircularProgressIndicator(),) : Container(
        padding: EdgeInsets.symmetric( horizontal: 20 ),
        child: ListView(
          children: [
            TextField(
              controller: _titleController,
              decoration:
              InputDecoration( hintText: 'title', labelText: 'Title' ),
            ),
            TextField(
              controller: _decsController,
              decoration: InputDecoration(
                  hintText: 'Description', labelText: 'Description' ),
            ),
            TextField(
              controller: _priceController,
              decoration:
              InputDecoration( hintText: 'Price', labelText: 'price' ),
            ),
            TextField(
              controller: _imageController,
              decoration:
              InputDecoration( hintText: 'image url', labelText: 'imageUrl' ),
            ),
            SizedBox(
              height: 10,
            ),
            // Container(
            //   width: double.infinity,
            //   child: RaisedButton(
            //     color: Colors.blue,
            //     child: Text(
            //       'Choose Image',
            //       style: TextStyle(color: Colors.white),
            //     ),
            //     onPressed: () {
            //       var ad = AlertDialog(
            //         title: Text('choose Image'),
            //         content: Container(
            //           height: 150,
            //           child: Column(
            //             children: [
            //               Divider(
            //                 color: Colors.black,
            //               ),
            //               buildItemDialog(context,'from gallery' ,Icons.image ,ImageSource.gallery),
            //
            //               SizedBox(
            //                 height: 10,
            //               ),
            //               buildItemDialog(context,'from camera' ,Icons.camera_alt,ImageSource.camera),
            //
            //             ],
            //           ),
            //         ),
            //       );
            //       showDialog(context: context, child: ad);
            //     },
            //   ),
            // ),
            SizedBox(
              height: 50,
            ),
            Consumer<Products>(
              builder: (context, value, child) =>
                  ElevatedButton(

                      child: Text( 'add product' ),
                      onPressed: ()  {
                        if (_titleController.text == null ||
                            _decsController.text == null ||
                            _imageController.text == null ||
                            _priceController.text == null) {
                           Toast.show('enter all fialed', context);
                        }
                        else {
                          try {
                           setState(() {
                             _price = double.parse(_priceController.text);
                           });
                           setState(() {
                             isLoading =true;
                           });
                             value.addProduct(
                                title: _titleController.text,
                                decs: _decsController.text,
                                price: _price,
                                image: _imageController.text ).catchError((error){
                                return showDialog<Null>(
                                  context: context, builder: (innercontext) => AlertDialog(
                                  title: Text(error),
                                  content: Text('something not true'),
                                  actions: [
                                    TextButton(onPressed: (){Navigator.pop(innercontext);}, child: Text('ok'))
                                  ],
                                ),
                               );
                            } ).then((_) {
                              setState(() {
                                isLoading =false;
                              });

                            });
                          } catch (e) {
                              Toast.show("enter number of price", context,duration: Toast.LENGTH_LONG);
                          }
                        }
                        // else if (_image == null) {
                        //   Toast.show('select image please', context,
                        //       duration: Toast.LENGTH_LONG);
                        // }
                        //       else {
                        //         try {
                        //
                        //           //value.deleteImage();
                        //           Navigator.pop(context);
                        //         } catch (e) {
                        // //          Toast.show("enter number of price", context,duration: Toast.LENGTH_LONG);
                        //           print(e);
                        //         }
                        //       }
                      } ),
            )
          ],
        ),
      ),
    );
  }
}

// buildItemDialog(BuildContext context, String s, IconData image, ImageSource gallery) {
//   return   Builder(
//       builder: (innerContex) => Container(
//         color: Colors.teal,
//         child: ListTile(
//           title: Text(s),
//           leading: Icon(image),
//           onTap: () {
//             Provider.of<Products>(context,
//                 listen: false)
//                 .getImage(gallery);
//             Navigator.of(innerContex).pop();
//           },
//         ),
//       ));
// }
