
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_attendance_app/models/student.dart';
import 'package:smart_attendance_app/APIS/NodeAPIS.dart';
import 'main.dart';
import 'dart:async';

class MyHome extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => MyHomeState();

}
class MyHomeState extends State<MyHome>{
  TextEditingController? _rfidController;
  GlobalKey<FormState>? _formKey;
 late List<Student>  specificStudent=[];
  late List<Student> _students = [];
  @override
  void initState()  {
    super.initState();
    _rfidController = TextEditingController();
    _formKey = GlobalKey();
    _getStudents();
   Timer.periodic(Duration(seconds: 2), (Timer t) => _getStudents());

  }
  void _getStudents() async {
    _students = (await APIHelper().getStudents());
   Future.delayed(const Duration(seconds: 1)).then((value) => setState(() {}));
  }

  @override
  Widget build(BuildContext context){
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'FlutterTab',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: DefaultTabController(length: 2,child:Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.cyanAccent,
           title:Image.asset('assets/images/kyan.png',width: 50,) ,
    actions: [
        Padding(
        padding: EdgeInsets.only(right: 20.0),
          child: GestureDetector(
            onTap: () {
              Navigator.pushAndRemoveUntil
                (
                context,
                MaterialPageRoute(
                    builder: (context)=> const LogIn(title: 'login',
                    )
                ),(Route<dynamic> route) => false, );
            },
            child: Icon(
              Icons.logout,
              size: 26.0,
            ),
          )
      )],
          bottom: TabBar(
            unselectedLabelColor: Color(0xff164276),
            indicator: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: Color(0xff164276)

            ),
            tabs: [
              Tab(child:Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(
                    color: Color(0xff164276),
                    width: 1
                  )

                ),
                child: Align(
                  alignment: Alignment.center,
                  child: Text('DashBoard',   style: GoogleFonts.josefinSans(
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 15,
                    ),
                  ),),
                ),
              )),
              Tab(child:Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(
                        color: Color(0xff164276),
                        width: 1
                    )

                ),
                child: Align(
                  alignment: Alignment.center,
                  child: Text('RFID Search',
                    style: GoogleFonts.josefinSans(
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 15,
                      ),
                    ),),
                ),
              ))],
          ),),
        body: TabBarView(children: [
          _students == null || _students.isEmpty
              ? const Center(
            child: CircularProgressIndicator(),
          ): Column(children:[ Image.asset('assets/images/dash.jpg',) ,_dashBoardHeader(),_dashBoard(_students)]),
          SingleChildScrollView(
            child: _searchStudent(_rfidController,_formKey))
        ],),
      ),)
    );
  }


  Widget _searchStudent(TextEditingController? rfidController,GlobalKey<FormState>? _sentFormKey) {
    return Column(children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Form(
          key:_sentFormKey,
          child: SizedBox(
            width: double.infinity,

            child: Column(
                children: [
                  const SizedBox(
                    height: 15,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Text(
                        'RFID',
                        style: GoogleFonts.josefinSans(
                          textStyle: const TextStyle(
                            color: Color(0xff8fa1b6),
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      TextFormField(
                        controller:rfidController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'RFID is required';
                          }
                          return null;

                        }

                        ,
                        cursorColor: Colors.red,
                        decoration: InputDecoration(
                          hintText: 'STUDENTRFID',
                          hintStyle: GoogleFonts.josefinSans(
                            textStyle: const TextStyle(
                              color: Color(0xffc5d2e1),
                              fontWeight: FontWeight.w400,
                              fontSize: 20,
                            ),
                          ),

                          enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xffdfe8f3)),
                          ),
                        ),
                      ),
                    ],//closethe shit
                  ),
                  const SizedBox(
                    height: 30,
                  )
                  ,_searchBtn(rfidController,_sentFormKey)
                ]
            ),),

        ),),
      specificStudent == null || specificStudent.isEmpty
          ?  Center(

        child: Column(children: [SizedBox(height: 100,),Text(
          "NO DATA TO SHOW",
          style: GoogleFonts.josefinSans(
            textStyle: const TextStyle(
              color: Colors.redAccent,
              fontWeight: FontWeight.w800,
              fontSize: 24,
            ),
          ),
        )],) ,
      ): _studentWidget()
    ],) ;

  }
void getStudentData(TextEditingController? rfidController){
  FocusManager.instance.primaryFocus?.unfocus();
  APIHelper().getStudent(rfidController!.value.text).then((value) =>
      setState(() {
        rfidController.clear();
        specificStudent=(value.length>0?value:[]);
      })

  );
}
  Widget _searchBtn(TextEditingController? rfidController,GlobalKey<FormState>? _sentFormKey) {
    String email;
    String password;
    return Container(
      width: double.infinity,
      height: 60,
      decoration: const BoxDecoration(
        color: Color(0xff008fff),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: ElevatedButton(

        onPressed:()=> {
          if (_sentFormKey!.currentState!.validate()) {
              getStudentData(rfidController)
      //Future.delayed(const Duration(seconds: 1)).then((value) => setState(() {}))
          //  _sentFormKey.currentContext.un

          }

        },
        child: Text(
          "Search",
          style: GoogleFonts.josefinSans(
            textStyle: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 24,
            ),
          ),
        ),
      ),
    );
  }


  Widget _studentWidget() {
    return  Column(
        children: <Widget>[
          SizedBox(
            height: 20,
            width: 200,
            child: Divider(
              color: Colors.white,
            ),
          ),
          Text(
            '${specificStudent[0].FirstName} ${specificStudent[0].LastName}',
            style: TextStyle(
              fontSize: 40.0,
              color: Colors.blue,
              fontWeight: FontWeight.bold,
              fontFamily: "Pacifico",
            ),
          ),
          SizedBox(
            height: 20,
            width: 200,
            child: Divider(
              color: Colors.white,
            ),
          ),

          // we will be creating a new widget name info carrd
          _infoCardWidget( 'RFID: ${specificStudent[0].RFID!}', Icons.ad_units),
          _infoCardWidget( 'Last Temprature taken: ${specificStudent[0].Temprature} ', Icons.device_thermostat),
          _infoCardWidget( 'Last show up: ${specificStudent[0].Timestamp} ', Icons.date_range),
          _infoCardWidget( 'Days attended this Month: ${specificStudent.length} ', Icons.date_range),
          _infoCardWidget( '${specificStudent[0].Email!}', Icons.email),

        ]
    );
  }
}
Widget _dashBoard( List<Student> _students) {
  return  SingleChildScrollView(
      child: Column(
      children: [  ListView.separated(
              shrinkWrap: true,
              itemBuilder: (context, index) => ListTile(
              leading: Text('${_students[index].RFID}',style: GoogleFonts.cabin(
              textStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,

              ),
              )),
              title: Text('${_students[index].FirstName} ${_students[index].LastName}',style: GoogleFonts.cabin(
                textStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,

                ),
              )),
              subtitle: Text(_students[index].Email!) ,
              trailing: SizedBox(
              width: 100,
              child: Text('${_students[index].Temprature} degree',style: GoogleFonts.cabin(
              textStyle:  TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
                color:
                (_students[index].Temprature!>37.2)
                    ? Colors.red
                    :Colors.black

              ),
              ))),
              ),
              separatorBuilder: (context, index) => const Divider(),
              itemCount: _students.length)
        ],
        ),);
}

Widget _dashBoardHeader( ) {
  return  SingleChildScrollView(
    child: Column(
      children: [  ListView.separated(
          shrinkWrap: true,
          itemBuilder: (context, index) => ListTile(
            leading:Column(children: [
              SizedBox(height: 19,width: 50,),Text('RFID', style: GoogleFonts.josefinSans(
              textStyle: const TextStyle(
                color: Colors.indigo,
                fontWeight: FontWeight.bold,
                fontSize: 20,

              ),
            ))],) ,
            title: Text('Pesonal Details', style: GoogleFonts.josefinSans(
              textStyle: const TextStyle(
                color: Colors.indigo,
                fontWeight: FontWeight.bold,
                fontSize: 20,

              ),
            )),
              trailing: Text('Temperature', style: GoogleFonts.josefinSans(
                textStyle: const TextStyle(
                  color: Colors.indigo,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,

                ),
              ))
          ),
          separatorBuilder: (context, index) => const Divider(),
          itemCount: 1)
      ],
    ),);
}

Widget _infoCardWidget(String text,IconData icon) {
return  GestureDetector(
  child: Card(
    color: Colors.white,
    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
    child: ListTile(
      leading: Icon(
        icon,
        color: Colors.teal,
      ),
      title: Text(
        text,
        style: TextStyle(
            color: Colors.teal,
            fontSize: 20,
            fontFamily: "Source Sans Pro"),
      ),
    ),
  ),
);;
}

