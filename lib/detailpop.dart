import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:helloworld/class/popmovie.dart';
import 'package:helloworld/editpopmovie.dart';
import 'package:http/http.dart' as http;

class DetailPop extends StatefulWidget {
  int movieID;

  DetailPop({super.key, required this.movieID});

  @override
  State<StatefulWidget> createState() {
    return _DetailPopState();
  }
}

class _DetailPopState extends State<DetailPop> {
  PopMovie? _pm;

  @override
  void initState() {
    super.initState();
    bacaData();
  }

  Future<void> deleteMovie() async {
    final response = await http.post(
      Uri.parse("https://ubaya.xyz/flutter/160721036/deletemovie.php"),
      body: {'id': widget.movieID.toString()},
    );
    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      if (result['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Movie deleted successfully')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to delete the movie')),
        );
      }
    } else {
      throw Exception('Failed to delete movie');
    }
  }

  void confirmDelete() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirm Delete"),
        content: const Text("Are you sure you want to delete this movie?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              deleteMovie();
            },
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }

  bacaData() {
    fetchData().then((value) {
      Map json = jsonDecode(value);
      setState(() {
        _pm = PopMovie.fromJson(json['data']);
      });
    });
  }

  Widget tampilData() {
    if (_pm == null) {
      return const CircularProgressIndicator();
    }
    print('object');
    return Card(
        elevation: 10,
        margin: const EdgeInsets.all(10),
        child: Column(children: <Widget>[
          Text(_pm!.title, style: const TextStyle(fontSize: 25)),
          Padding(padding: const EdgeInsets.all(10), child: Text(_pm!.overview, style: const TextStyle(fontSize: 15))),
          const Padding(padding: EdgeInsets.all(10), child: Text("Genre:")),
          Padding(
              padding: const EdgeInsets.all(10),
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _pm?.genres?.length,
                  itemBuilder: (BuildContext ctxt, int index) {
                    return Text(_pm?.genres?[index]['genre_name']);
                  })),
          Padding(padding: const EdgeInsets.all(10), child: Text(_pm!.overview, style: const TextStyle(fontSize: 15))),
          const Padding(padding: EdgeInsets.all(10), child: Text("Cast:")),
          Padding(
              padding: const EdgeInsets.all(10),
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _pm?.actor?.length,
                  itemBuilder: (BuildContext ctxt, int index) {
                    return Text(_pm?.actor?[index]);
                  }))
        ]));
  }

  Future<String> fetchData() async {
    final response = await http.post(Uri.parse("https://ubaya.xyz/flutter/160721036/detailmovie.php"), body: {'id': widget.movieID.toString()});
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to read API');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail of Popular Movie'),
      ),
      body: ListView(
        children: <Widget>[
          Text(widget.movieID.toString()),
          tampilData(),
          Padding(
              padding: EdgeInsets.all(10),
              child: ElevatedButton(
                child: Text('Edit'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          EditPopMovie(movieID: widget.movieID),
                    ),
                  );
                },
              )),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 10.0),
            child: ElevatedButton(
              onPressed: confirmDelete,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const Text('Delete Movie'),
            ),
          )
        ],
      ),
    );
  }
}
