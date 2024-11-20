import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:helloworld/class/popmovie.dart';
import 'package:helloworld/detailpop.dart';
import 'package:http/http.dart' as http;

class PopularMovie extends StatefulWidget {
  const PopularMovie({super.key});

  @override
  State<StatefulWidget> createState() {
    return _PopularMovieState();
  }
}

class _PopularMovieState extends State<PopularMovie> {
  String _temp = 'waiting API respond…';
  List<PopMovie> PMs = [];
  String _txtcari = '';

  Future<String> fetchData() async {
    final response = await http.post(Uri.parse("https://ubaya.xyz/flutter/160721036/movielist.php"), body: {'cari': _txtcari});
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
    PMs.clear();
    Future<String> data = fetchData();
    data.then((value) {
      Map json = jsonDecode(value);
      setState(() {
        if (json['result'] == 'success') {
          for (var mov in json['data']) {
            PopMovie pm = PopMovie.fromJson(mov);
            PMs.add(pm);
          }
        } else {
          PMs.clear();
        }
      });
    });
  }

  Widget DaftarPopMovie(PopMovs) {
    if (PopMovs != null) {
      return ListView.builder(
          itemCount: PopMovs.length,
          itemBuilder: (BuildContext ctxt, int index) {
            return Card(
                child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            DetailPop(movieID: PMs[index].id),
                      ),
                    );

                  },
                  leading: const Icon(Icons.movie, size: 30),
                  title: Text(PopMovs[index].title),
                  subtitle: Text(PopMovs[index].overview),
                ),
              ],
            ));
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
      appBar: AppBar(title: const Text('Popular Movie')),
      body: ListView(
        children: <Widget>[
          TextFormField(
            decoration: const InputDecoration(
              icon: Icon(Icons.search),
              labelText: 'Judul mengandung kata:',
            ),
            onFieldSubmitted: (value) {
              _txtcari = value;
              bacaData();
            },
          ),
          Container(
            height: MediaQuery.of(context).size.height - 200,
            child: PMs.length > 0 ? DaftarPopMovie(PMs) : Text('tidak ada data'),
          )
        ],
      ),
    );
  }
}
