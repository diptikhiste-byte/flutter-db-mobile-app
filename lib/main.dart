import 'package:flutter/material.dart';
import 'db_helper.dart';

void main() {
  runApp(MaterialApp(
    home: StudentApp(),
    debugShowCheckedModeBanner: false,
  ));
}

class StudentApp extends StatefulWidget {
  @override
  _StudentAppState createState() => _StudentAppState();
}

class _StudentAppState extends State<StudentApp> {
  TextEditingController nameCtrl = TextEditingController();
  DBHelper dbHelper = DBHelper();
  List<Map<String, dynamic>> students = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  // Load students from database
  void loadData() async {
    students = await dbHelper.getStudents();
    setState(() {});
  }

  // Add student to database
  void addStudent() async {
    String name = nameCtrl.text.trim();
    if (name != "") {
      await dbHelper.insertStudent(name);
      nameCtrl.clear();
      loadData();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter a name")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Student Database App")),
      body: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            TextField(
              controller: nameCtrl,
              decoration: InputDecoration(
                labelText: "Enter Name",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: addStudent,
              child: Text("Add Student"),
            ),
            SizedBox(height: 20),
            Expanded(
              child: students.isEmpty
                  ? Center(child: Text("No students added yet"))
                  : ListView.builder(
                itemCount: students.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      leading:
                      CircleAvatar(child: Text(students[index]['id'].toString())),
                      title: Text(students[index]['name']),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
