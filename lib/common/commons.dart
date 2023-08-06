import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

abstract class CommonFunctions {
  static const String _apiUrl = "https://homeautomation.onrender.com";

  /// This function uses to Auth user using Password and App ID.
  static Future authUser(
      {required String userId, required String password}) async {
    try {
      Uri url = Uri.parse('$_apiUrl/auth');
      var response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'userId': userId, 'password': password}),
      );
      if (response.statusCode >= 200) {
        var data = json.decode(response.body);
        return data[0];
      } else {
        throw Exception("Somthing Wrong");
      }
    } on Exception catch (e) {
      throw Exception(e);
    }
  }

//This function use to get user Status using userId so User need to be logrdin.
  static Future<Map<String, dynamic>> getUserStatus({String? id}) async {
    Uri url = Uri.parse('$_apiUrl/getStatus');
    var response = await http.post(
      url,
      headers: {'Content-Type': "application/json"},
      body: json.encode(
        {'_id': id},
      ),
    );
    if (response.statusCode >= 200) {
      List data = json.decode(response.body);
      return data[0];
    } else {
      throw Exception("Somthing Wrong");
    }
  }

// This function use to set devies status and also add devices.
  static Future setDeviceState({String? id, String? room, Map? val}) async {
    Uri url = Uri.parse('$_apiUrl/addRoom');
    await http.post(url,
        headers: {'Content-Type': "application/json"},
        body: json.encode({'_id': id, 'room': room, 'val': val}));
  }

// Uses for add devices.
  static Future addDevice({String? id, String? room, Map? val}) async {
    Uri url = Uri.parse('$_apiUrl/addDevice');
    await http.post(url,
        headers: {'Content-Type': "application/json"},
        body: json.encode({'_id': id, 'room': room, 'val': val}));
  }

//Uses for add room.
  static Future addRoom({String? id, String? room, Map? val}) async {
    Uri url = Uri.parse('$_apiUrl/addRoom');
    await http.post(url,
        headers: {'Content-Type': "application/json"},
        body: json.encode({'_id': id, 'room': room, 'val': val}));
  }

  static Future deleteRoom({String? id, String? room}) async {
    Uri url = Uri.parse('$_apiUrl/deleteRoom');
    var res = await http.post(url,
        headers: {'Content-Type': "application/json"},
        body: json.encode({'_id': id, 'room': room}));
        return res;
  }

  /// This function is use to achive or get height respect to Screen height
  static getHeight(BuildContext context, double height) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    final double h = mediaQueryData.size.height;
    return (h * height) / 100;
  }

  /// This function is use to achive or get width respect to Screen width
  static double getWidth(BuildContext context, double width) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    final double w = mediaQueryData.size.width;
    return (w * width) / 100;
  }
}
