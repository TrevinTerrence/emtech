import 'package:flutter/material.dart';
import 'package:helloworld/studentDetail.dart';

class StudentList extends StatelessWidget {
  const StudentList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Student List'),
        ),
        body: Center(
          child: Column(children: [
            const Text("Pilih nomor anda"),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const StudentDetail(1)));
                },
                child: const Text("Student 1")),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const StudentDetail(2)));
                },
                child: const Text("Student 2")),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const StudentDetail(3)));
                },
                child: const Text("Student 3"))
          ]),
        ));
  }
}
