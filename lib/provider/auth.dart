import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


class Auth with ChangeNotifier{

  String _userId;
  String _token;
  DateTime _expiresDate ;
  Timer _authTimer;

  bool get isAuth{
   return token !=null;
  }

  String get token{
    if(_expiresDate != null && _expiresDate.isAfter(DateTime.now())&& _token !=null){
      return _token;
    }
    return null;
  }


  Future<void> _authanticate(String email ,String password ,String urlSegment) async{
    try{
      final Uri url = Uri.parse("https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyCOx6sehKl7aGw7Dx4OxRdbqMPhWx30pgI");
    var res =await http.post(url , body:json.encode({
      'email':email,
      'password':password,
      'returnSecureToken':true,
    }));
    var resData =json.decode(res.body);
    if(resData['error'] != null){
      throw "${resData['error']['message']}";
    }
    _token =resData['idToken'];
    print(_token);
    _userId =resData['localId'];
    _expiresDate =DateTime.now().add(Duration(seconds: int.parse(resData['expiresIn'])));
      autoLogout();
      notifyListeners();

      SharedPreferences pref = await SharedPreferences.getInstance();
      var value = json.encode({
      'token' : _token,
      'userId' :_userId,
      'expiresDate' : _expiresDate.toIso8601String(),
      });
      pref.setString('userData', value);

    }
    catch(e){
      throw e ;
    }

}

Future<void> login(String email ,String password ){
    return _authanticate(email, password, "signInWithPassword");
}
  Future<void> signUp(String email ,String password ){
   return  _authanticate(email, password, "signUp");
  }
  Future<void> logout() async {
    _expiresDate=null;
    _token =null;
    _userId =null;
    if(_authTimer != null){
      _authTimer.cancel();
      _authTimer= null;
    }
    notifyListeners();
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.clear();

  }
  void autoLogout(){
    if(_authTimer != null){
      _authTimer.cancel();
    }

    var expireTime =_expiresDate.difference(DateTime.now()).inSeconds;
    _authTimer=Timer(Duration(seconds: expireTime) ,logout);
  }

  Future<bool> tryautoLogin() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if(pref == null){
      return false;
    }
    var extractedDataString=pref.getString('userdata');

   var extractedData = json.decode(extractedDataString)as Map<String,dynamic>;

   final expiresDate =DateTime.parse(extractedData['expiresDate']);
   if(expiresDate.isBefore(DateTime.now())){
     return false;
   }
   _userId =extractedData['userId'];
   _token =extractedData['token'];
   _expiresDate =expiresDate;
   notifyListeners();
   autoLogout();
   return true;


  }


}