import 'dart:convert';

import 'package:addproduct/provider/auth.dart';
import 'package:addproduct/provider/products.dart';
import 'package:addproduct/screens/add_product.dart';
import 'package:addproduct/screens/home.dart';
import 'package:addproduct/screens/product_details.dart';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized( );
  runApp(
      MultiProvider( providers: [
        ChangeNotifierProvider<Auth>(
          create: (_) => Auth( ),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
            create: (_) => Products( ),
            update: (ctx, value, previous) =>
                previous..getData( previous==null?[]:previous.productList, value.token ) ),

      ],
        child: MyApp( ), )
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<Auth>(
      builder: (context, value, _) =>
          MaterialApp(
            debugShowCheckedModeBanner: false,
            home: value.isAuth ? Home( ) : FutureBuilder(
                future: value.tryautoLogin( ),
                builder: (context, snapShot) =>
                snapShot.connectionState == ConnectionState.waiting ? Center(
                  child: CircularProgressIndicator( ), ):MyHome() ),
          ),
    );
  }
}


class MyHome extends StatefulWidget {
  @override
  _MyHomeState createState() => _MyHomeState( );
}
enum AuthLogin { LOGIN, SIGNUP }

class _MyHomeState extends State<MyHome> {

  AuthLogin _authLogin = AuthLogin.LOGIN;
  Map<String, String> _saveInfo = {
    'emailInfo': "",
    'passwordInfo': "",
  };

  void _switch() {
    if (_authLogin == AuthLogin.LOGIN) {
      setState( () {
        _authLogin = AuthLogin.SIGNUP;
      } );
    } else {
      setState( () {
        _authLogin = AuthLogin.LOGIN;
      } );
    }
  }

  void toggalSecure() {
    if (_switchSecure == true) {
      setState( () {
        _switchSecure = false;
      } );
    }
    else {
      setState( () {
        _switchSecure = true;
      } );
    }
  }

  final GlobalKey<FormState> _formKey = GlobalKey( );
  TextEditingController _emailController = TextEditingController( );

  TextEditingController _passwordController = TextEditingController( );
  bool _switchSecure = true;

  @override
  void dispose() {
    super.dispose( );
    _emailController.dispose( );
    _passwordController.dispose( );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery
            .of( context )
            .size
            .width,
        height: MediaQuery
            .of( context )
            .size
            .height,
        decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage( 'assets/b.jpg' ),
              fit: BoxFit.cover,
            )
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric( horizontal: 20 ),
          child: SingleChildScrollView(
            padding: EdgeInsets.only( top: 75 ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText( text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Welcome back!\n',
                        style: TextStyle( fontSize: 30 ),
                      ),
                      TextSpan(
                        text: 'Sign in to your account\n',
                        style: TextStyle( fontSize: 15 ),
                      ),
                    ]
                ) ),
                SizedBox(
                  height: 30,
                ),
                Container(

                  height: (_authLogin == AuthLogin.LOGIN) ? 250 : 360,
                  width: MediaQuery
                      .of( context )
                      .size
                      .width - 20,
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular( 20 ),
                  ),
                  child: Stack(
                    children: [
                      Form(
                        key: _formKey,
                        child: Padding(
                          padding: const EdgeInsets.symmetric( horizontal: 25,
                              vertical: 15 ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextFormField(
                                controller: _emailController,
                                onSaved: (val) {
                                  if (val.isNotEmpty) {
                                    setState( () {
                                      _saveInfo['emailInfo'] = val;
                                    } );
                                  }
                                },
                                validator: (val) {
                                  if (val.isEmpty || !val.contains( '@' )) {
                                    return 'please enter valid email';
                                  } else {
                                    return null;
                                  }
                                },
                                cursorColor: Colors.white30,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15
                                ),
                                decoration: InputDecoration(
                                  labelText: 'Your Text',
                                  labelStyle: TextStyle( color: Colors.white ),
                                  hintText: 'email@address.com',
                                  hintStyle: TextStyle( color: Colors.white30 ),
                                  enabled: true,
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.white30 ),

                                  ),

                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.white30 ),

                                  ),


                                ),


                              ),
                              TextFormField(
                                controller: _passwordController,
                                onSaved: (val) {
                                  if (val.isNotEmpty) {
                                    setState( () {
                                      _saveInfo['passwordInfo'] = val;
                                    } );
                                  }
                                },
                                validator: (val) {
                                  if (val.isEmpty || val.length < 6) {
                                    return 'password is invaild';
                                  } else {
                                    return null;
                                  }
                                },
                                cursorColor: Colors.white30,
                                obscureText: _switchSecure,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15
                                ),


                                decoration: InputDecoration(
                                  suffix: SizedBox(
                                      height: 10,
                                      child: IconButton( icon: Icon(
                                        Icons.remove_red_eye_outlined,
                                        color: Colors.white30, size: 15, ),
                                        onPressed: toggalSecure, ) ),
                                  focusColor: Colors.white30,

                                  labelText: 'Password',
                                  labelStyle: TextStyle( color: Colors.white ),
                                  hintText: '**********',
                                  hintStyle: TextStyle( color: Colors.white30 ),
                                  enabled: true,

                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.white30 ),


                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.white30 ),

                                  ),


                                ),

                              ),
                              if(_authLogin == AuthLogin.SIGNUP) TextFormField(

                                validator: (val) {
                                  if (val.isEmpty ||
                                      _passwordController.text != val) {
                                    return 'password is not equal';
                                  } else {
                                    return null;
                                  }
                                },

                                cursorColor: Colors.white30,
                                obscureText: _switchSecure,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15

                                ),

                                decoration: InputDecoration(
                                  suffix: SizedBox(
                                      height: 10,
                                      child: IconButton( icon: Icon(
                                        Icons.remove_red_eye_outlined,
                                        color: Colors.white30, size: 15, ),
                                        onPressed: toggalSecure, ) ),
                                  focusColor: Colors.white30,

                                  labelText: ' confirm Password',
                                  labelStyle: TextStyle( color: Colors.white ),
                                  hintText: '**********',
                                  hintStyle: TextStyle( color: Colors.white30 ),
                                  enabled: true,

                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.white30 ),


                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.white30 ),

                                  ),


                                ),

                              ),


                            ],
                          ),
                        ),
                      ),
                      Positioned
                        (
                        right: 0,
                        bottom: 0,
                        child: Container(
                            height: 50,
                            width: 125,
                            decoration: BoxDecoration(
                              color: Colors.amber,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular( 20 ),
                                  bottomLeft: Radius.circular( 20 ),
                                  bottomRight: Radius.circular( 20 ) ),
                            ),
                            child: Center(
                              child: InkWell(
                                onTap: () {
                                  _submet( );
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text( _authLogin == AuthLogin.LOGIN
                                        ? 'LOGIN'
                                        : 'SING UP', style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold ), ),
                                    SizedBox( width: 10, ),
                                    Icon( Icons.arrow_forward,
                                      color: Colors.white, )

                                  ],
                                ),
                              ),
                            )
                        ),
                      ),
                      Positioned(
                        bottom: 7,
                        left: 15,
                        child: TextButton( onPressed: () {}, child: Text(
                          'Forget Password ?',
                          style: TextStyle( color: Colors.amber ), ), ), )
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text( 'Dont have an account?',
                      style: TextStyle( color: Colors.white ), ),
                    TextButton( onPressed: () {
                      _switch( );
                    },
                        child: Text( _authLogin == AuthLogin.LOGIN
                            ? 'Create One'
                            : 'LOGIN',
                          style: TextStyle( color: Colors.white ), ) )
                  ],
                )


              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _submet() async {
    if (!_formKey.currentState.validate( )) {
      return;
    }
    _formKey.currentState.save( );
    try {
      if (_authLogin == AuthLogin.LOGIN) {
        await Provider.of<Auth>( context, listen: false ).login(
            _saveInfo['emailInfo'], _saveInfo['passwordInfo'] );
      }
      else if (_authLogin == AuthLogin.SIGNUP) {
        await Provider.of<Auth>( context, listen: false ).signUp(
            _saveInfo['emailInfo'], _saveInfo['passwordInfo'] );
      }
    } catch (error) {
      // print(error);
      var message = 'error';
      if (error.toString( ).contains( 'EMAIL_EXISTS' )) {
        message = 'email is exits';
      }
      _showDiloge( message );
    }
  }

  void _showDiloge(String message) {
    showDialog( context: context, builder: (innercontex) =>
        AlertDialog(
          title: Text( 'error' ),
          content: Text( 'something rong' ),
          actions: [
            ElevatedButton(
                onPressed: () => Navigator.of( context ).pop( innercontex ),
                child: Text( 'ok' ) )
          ],
        ) );
  }
}


//Card(
//                         elevation: 8,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(15),
//                         ),
//                         child: Stack(
//                           children: [
//                             ClipRRect(
//                               borderRadius: BorderRadius.only(
//                                 topLeft: Radius.circular(10),
//                                 topRight: Radius.circular(10),
//                               ),
//                               child: Image.file(
//                                 item.image,
//                                 fit: BoxFit.cover,
//                               ),
//                             ),
//                             buildPostion(item.title, item.description, item.price),
//                             Positioned(
//                                 left: 10,
//                                 bottom: 10,
//                                 child: FloatingActionButton(
//                                   backgroundColor: Colors.deepOrange,
//                                   heroTag: item.title ,
//                                   onPressed: () => Provider.of<Products>(context ,listen: false).delete(item.description),
//                                   child: Icon(Icons.delete ,color: Colors.white,),
//                                 )),
//                           ],
//                         ),
//                       ),
