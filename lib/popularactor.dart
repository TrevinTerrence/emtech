import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:helloworld/class/pop_actor.dart';
import 'package:helloworld/class/popmovie.dart';
import 'package:http/http.dart' as http;

class PopularActor extends StatefulWidget {
  const PopularActor({super.key});

  @override
  State<StatefulWidget> createState() {
    return _PopularActorState();
  }
}

class _PopularActorState extends State<PopularActor> {
  String _temp = 'waiting API respond…';
  List<PopActor> PAs = [];

  Future<String> fetchData() async {
    final response = await http.get(Uri.parse("https://ubaya.xyz/flutter/160721036/actorlist.php"));
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to read API');
    }
  }

  // bacaData() {
  //   Future<String> data = fetchData();
  //   data.then((value) {
  //     setState(() {
  //       _temp = value;
  //     });
  //   });
  // }
  bacaData() {
    Future<String> data = fetchData();
    data.then((value) {
      Map json = jsonDecode(value);
      for (var act in json['data']) {
        PopActor pa = PopActor.fromJson(act);
        PAs.add(pa);
      }
      setState(() {
        _temp = PAs[5].name;
      });
    });
  }

  Widget DaftarPopActor(PopActs) {
    if (PopActs != null) {
      return ListView.builder(
          itemCount: PopActs.length,
          itemBuilder: (BuildContext ctxt, int index) {
            return Card(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                      leading: const Icon(Icons.person, size: 30),
                      title: Text(PopActs[index].name),
                    ),
                  ],
                )
            );
          });
    } else {
      return const CircularProgressIndicator();
    }
  }

  @override
  void initState() {
    super.initState();
    bacaData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Popular Actor')),
      body: ListView(
        children: <Widget>[
          Container(
            height: MediaQuery
                .of(context)
                .size
                .height - 200,
            child: DaftarPopActor(PAs),
          )
        ],
      ),
    );
  }
}
