import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class NewPopMovie extends StatefulWidget {
  const NewPopMovie({super.key});

  @override
  State<NewPopMovie> createState() => _NewPopMovieState();
}

class _NewPopMovieState extends State<NewPopMovie> {
  final _formKey = GlobalKey<FormState>();
  String _title = "";
  String _runtime = "0";
  String _homepage = "";
  String _overview = "";
  String _url = "";
  final _controllerDate = TextEditingController();
  final _homepageController = TextEditingController();



  Future<bool> validateImage(String imageUrl) async {
    http.Response res;
    try {
      res = await http.get(Uri.parse(imageUrl));
    } catch (e) {
      return false;
    }
    if (res.statusCode != 200) return false;
    Map<String, dynamic> data = res.headers;
    if (data['content-type'] == 'image/jpeg' ||
        data['content-type'] == 'image/png' ||
        data['content-type'] == 'image/gif') {
      return true;
    }
    return false;
  }

  void submit() async {
    final response = await http
        .post(Uri.parse("https://ubaya.xyz/flutter/160721036/newmovie.php"), body: {
      'title': _title,
      'overview': _overview,
      'homepage': _homepage,
      'release_date': _controllerDate.text,
      'runtime': _runtime,
      'url':_url
    });
    if (response.statusCode == 200) {
      Map json = jsonDecode(response.body);
      if (json['result'] == 'success') {
        if (!mounted) return;
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Sukses Menambah Data')));
      }
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error')));
      throw Exception('Failed to read API');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("New Popular Movie"),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(10),
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Title',
                  ),
                  onChanged: (value) {
                    _title = value;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Judul harus diisi';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                  padding: EdgeInsets.all(10),
                  child: TextFormField(
                    controller: _homepageController,
                    decoration: const InputDecoration(
                      labelText: 'Homepage',
                    ),
                    onChanged: (value) {
                      _homepage = value;
                    },
                    validator: (value) {
                      if (value == null || !Uri.parse(value).isAbsolute) {
                        return 'alamat homepage salah';
                      }
                      return null;
                    },
                  )),
              Padding(
                  padding: EdgeInsets.all(10),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Overview',
                    ),
                    onChanged: (value) {
                      _overview = value;
                    },
                    validator: (value){
                      if(value!.length<50){
                        return 'overview kurang panjang';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.multiline,
                    minLines: 3,
                    maxLines: 6,
                  )),
              Padding(
                padding: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                        child: TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Release Date',
                          ),
                          controller: _controllerDate,
                        )),
                    ElevatedButton(
                      onPressed: () {
                        showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2000), lastDate: DateTime(2200)).then((value) {
                          setState(() {
                            _controllerDate.text = value.toString().substring(0, 10);
                          });
                        });
                      },
                      child: Icon(
                        Icons.calendar_today_sharp,
                        color: Colors.white,
                        size: 24.0,
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: TextFormField(
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  decoration: const InputDecoration(
                    labelText: 'Runtime',
                  ),
                  onChanged: (value) {
                    _runtime = value;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Judul harus diisi';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                  padding: EdgeInsets.all(10),
                  child: TextFormField(
                    controller: _homepageController,
                    decoration: const InputDecoration(
                      labelText: 'Homepage',
                    ),
                    onChanged: (value) {
                      validateImage(value).then((v) {
                        if(v)
                        {
                          setState(() {
                            _url = value;
                          });
                        }
                      }
                      );

                    },
                    validator: (value) {
                      if (value == null || !Uri.parse(value).isAbsolute) {
                        return 'alamat homepage salah';
                      }
                      return null;
                    },
                  )),
              if (_url.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child:Image.network(
                    _url,
                    height: 300,
                    width: 200,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Text("Gambar tidak dapat dimuat"),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState != null && !_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Harap Isian diperbaiki')));
                    }else{
                      submit();
                    }
                  },
                  child: Text('Submit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
