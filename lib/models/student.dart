class Student{
  String? RFID;
  String? FirstName;
  String? LastName;
  String? Email;
  String? Age;
  String? Level;
  int? Temprature;
  String? Timestamp;
  Student({required String this.RFID,required this.FirstName,required this.LastName,required this.Temprature,required this.Email,required this.Timestamp });
   factory  Student.fromJson(dynamic json) {

    return Student(RFID:  json['RFID'], FirstName:   json['FirstName'], LastName:  json['LastName'],
        Temprature: json['Temprature'],Email: json['email'],
        Timestamp: json['TimeStamp']);


  }

}