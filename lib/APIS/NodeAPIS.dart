import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:smart_attendance_app/APIS/APIConstants.dart';
import 'package:smart_attendance_app/models/student.dart';


class APIHelper {
  Future<List<Student>> getStudents() async {
    List<Student> students=new List.empty() ;
   try {
      var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.studentEndpoint);
      var response = await http.get(url);
      if (response.statusCode == 200) {
        Iterable l = json.decode(response.body);
     students = List<Student>.from(l.map((model)=> Student.fromJson(model)));

        return students;
      }
    } catch (e) {
      print(e.toString());
    }
    return students;
  }

  Future<List<Student>> getStudent(String rfid) async {
    List<Student> students=new List.empty() ;
    try {
      var url = Uri.parse(ApiConstants.baseUrl + '/reading/'+rfid);
      var response = await http.get(url);

      if (response.statusCode == 200) {
        Iterable l = json.decode(response.body);
        print(response.body);

        students = List<Student>.from(l.map((model)=> Student.fromJson(model)));

        return students;
      }
    } catch (e) {
      print(e.toString());
    }

      return  students;
  }
  Future<bool> authenticateAdmin(String Email,String Password) async {
    try {

      var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.login,);
      var response = await http.post(url,
          headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          },body: jsonEncode(<String, String>{
        'Email': Email,
        'Password': Password,
      }));
      if (response.statusCode == 200) {
        return jsonDecode(response.body)['login'];
      }
    } catch (e) {
      print(e.toString());
    }

    return  false;
  }

}
