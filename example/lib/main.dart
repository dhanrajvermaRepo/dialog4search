import 'package:dialog4search/dialog4search.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SearchDialog<Person>(
//              multipleSelect: true,
              searchFunction: (person, value) {
                return person.fathersName
                    .toUpperCase()
                    .contains(value.toUpperCase()) ||
                    person.name.toUpperCase().contains(value.toUpperCase());
              },
              itemBuilder: (context, person) {
                return Container(
                  color: Colors.white,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Person: ${person.name}"),
                      Text("Father: ${person.fathersName}"),
                    ],
                  ),
                );
              },
              list: testData,
              builder: (context, person) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  color: Colors.red,
                  height: 50,
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(left: 16),
                  child: Text("${person.name}"),
                );
              },
              searchBoxDecoration: InputDecoration(
                  hintText: 'Search Name',
                  contentPadding: EdgeInsets.symmetric(horizontal: 10,vertical: 0),
                  border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                  filled: true,
                  hintStyle: TextStyle(fontSize: 16, color: Colors.grey)),
              onChanged: (person){
                print("${person[0].name}");
              },
              onInitialization: (person){
                print("${person.name}");
              },
              initialValue: testData[2],
              dialogBoxBackgroundColor: Colors.red,
            ),
          ],
        ),
      ),// This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class Person {
  final String name;
  final String fathersName;
  Person({this.name, this.fathersName});
}

var testData = [
  Person(name: 'Anuj Patel', fathersName: 'Ram Lal Patel'),
  Person(name: 'Anuj Verma', fathersName: 'Ram Lal Verma'),
  Person(name: 'Dinesh Mishra', fathersName: 'Mangare Mishra'),
  Person(name: 'Kapil Gupta', fathersName: 'Jhanni Lal Gupta'),
  Person(name: 'Rajpal verma', fathersName: 'Baburam verma'),
  Person(name: 'Satendra Rathod', fathersName: 'Kamlesh Rathod'),
  Person(name: 'Shuresh Kumar', fathersName: 'Tikaram verma'),
  Person(name: 'Omkar kashyap', fathersName: 'Khanna kashyap'),
  Person(name: 'Sachin kumar', fathersName: 'Omkar kashyap'),
  Person(name: 'Sudheer Pandey', fathersName: 'Anchal Pandey'),
  Person(name: 'Anuj Patel', fathersName: 'Ram Lal Patel'),
  Person(name: 'Anuj Verma', fathersName: 'Ram Lal Verma'),
  Person(name: 'Dinesh Mishra', fathersName: 'Mangare Mishra'),
  Person(name: 'Kapil Gupta', fathersName: 'Jhanni Lal Gupta'),
  Person(name: 'Rajpal verma', fathersName: 'Baburam verma'),
  Person(name: 'Satendra Rathod', fathersName: 'Kamlesh Rathod'),
  Person(name: 'Shuresh Kumar', fathersName: 'Tikaram verma'),
  Person(name: 'Omkar kashyap', fathersName: 'Khanna kashyap'),
  Person(name: 'Sachin kumar', fathersName: 'Omkar kashyap'),
  Person(name: 'Sudheer Pandey', fathersName: 'Anchal Pandey'),
];
