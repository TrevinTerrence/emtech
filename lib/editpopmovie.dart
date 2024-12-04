import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:helloworld/class/genre.dart';
import 'package:helloworld/class/popmovie.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class EditPopMovie extends StatefulWidget {
  int movieID;

  EditPopMovie({super.key, required this.movieID});

  @override
  EditPopMovieState createState() {
    return EditPopMovieState();
  }
}

class EditPopMovieState extends State<EditPopMovie> {
  final _formKey = GlobalKey<FormState>();
  PopMovie? _pm;
  TextEditingController _titleCont = TextEditingController();
  TextEditingController _homepageCont = TextEditingController();
  TextEditingController _overviewCont = TextEditingController();
  TextEditingController _releaseDate = TextEditingController();
  TextEditingController _runtimeCont = TextEditingController();
  TextEditingController _urlCont = TextEditingController();
  Widget comboGenre = Text('tambah genre');
  Uint8List? _imageBytes;

  @override
  void initState() {
    super.initState();
    bacaData();
  }

  Future<String> fetchData() async {
    final response = await http.post(Uri.parse("https://ubaya.xyz/flutter/160721036/detailmovie.php"), body: {'id': widget.movieID.toString()});
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to read API');
    }
  }

  bacaData() {
    fetchData().then((value) {
      Map json = jsonDecode(value);
      _pm = PopMovie.fromJson(json['data']);
      setState(() {
        _titleCont.text = _pm!.title;
        _homepageCont.text = _pm!.homepage;
        _overviewCont.text = _pm!.overview;
        _releaseDate.text = _pm!.releaseDate;
        _runtimeCont.text = _pm!.runtime.toString();
        _urlCont.text=_pm!.url!;

      });
    });
  }

  void submit() async {
    final response = await http.post(
        Uri.parse("https://ubaya.xyz/flutter/160721036/updatemovie.php"),
        body: {
          'title': _pm!.title,
          'overview': _pm!.overview,
          'homepage': _pm!.homepage,
          'release_date':_pm!.releaseDate,
          'runtime':_pm!.runtime.toString(),
          'url':_pm!.url,
          'movie_id': widget.movieID.toString()
        });
    if (response.statusCode == 200) {
      Map json = jsonDecode(response.body);
      if (json['result'] == 'success') {
        if (!mounted) return;
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Sukses mengubah Data')));
      }
    } else {
      throw Exception('Failed to read API');
    }
  }
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

  Future<List> daftarGenre() async {
    Map json;
    final response = await http.post(
        Uri.parse("https://ubaya.xyz/flutter/160721036/genrelist.php"),
        body: {'movie_id': widget.movieID.toString()});

    if (response.statusCode == 200) {
      print(response.body);
      json = jsonDecode(response.body);
      return json['data'];
    } else {
      throw Exception('Failed to read API');
    }
  }

  void generateComboGenre() {
    List<Genre> genres;
    var data = daftarGenre();
    data.then((value) {
      genres = List<Genre>.from(value.map((i) {
        return Genre.fromJSON(i);}));
      setState(() {
        comboGenre = DropdownButton(
            dropdownColor: Colors.grey[100],
            hint: const Text("tambah genre"),
            isDense: false,
            items: genres.map((gen) {
              return DropdownMenuItem(
                value: gen.genre_id,
                child: Column(children: <Widget>[
                  Text(gen.genre_name, overflow: TextOverflow.visible),
                ]),
              );
            }).toList(),
            onChanged: (value) {
              addGenre(value);
            });
      });
    });
  }

  void addGenre(genre_id) async {
    final response = await http.post(
        Uri.parse("https://ubaya.xyz/flutter/160721036/addmoviegenre.php"),
        body: {'genre_id': genre_id.toString(), 'movie_id': widget.movieID.toString()
        });
    if (response.statusCode == 200) {
      print(response.body);
      Map json = jsonDecode(response.body);
      if (json['result'] == 'success') {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Sukses menambah genre')));
        setState(() {
          bacaData();
        });
      }
    } else {
      throw Exception('Failed to read API');
    }
  }

  Future<void> deleteMovieGenre(int movieId, int genreId) async {
    final response = await http.post(
      Uri.parse("https://ubaya.xyz/flutter/160721036/deletemoviegenre.php"),
      body: {'movie_id': movieId.toString(),'genre_id':genreId.toString()},
    );
    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      if (result['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('genre deleted successfully')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to delete the genre')),
        );
      }
    } else {
      throw Exception('Failed to delete genre');
    }
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              color: Colors.white,
              child: Wrap(
                children: <Widget>[
                  ListTile(
                      tileColor: Colors.white,
                      leading: const Icon(Icons.photo_library),
                      title: const Text('Galeri'),
                      onTap: () {
                        imgGaleri();
                        Navigator.of(context).pop();
                      }),
                  ListTile(
                    leading: const Icon(Icons.photo_camera),
                    title: const Text('Kamera'),
                    onTap: () {
                      imgKamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  imgGaleri() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 50,
        maxHeight: 600,
        maxWidth: 600);
    if (image != null) {
      final bytes = await image.readAsBytes();
      setState(() {
        _imageBytes = bytes;
      });
    }
  }
  imgKamera() async {
    final picker = ImagePicker();
    final image =
    await picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 20);
    if (image != null) {
      final bytes = await image.readAsBytes();
      setState(() {
        _imageBytes = bytes;
      });
    }
  }

  void uploadScene64() async {
    String base64Image = base64Encode(_imageBytes!);
    final response = await http.post(
      Uri.parse("https://ubaya.xyz/flutter/160721036/uploadscene64.php"),
      body: {
        'movie_id': widget.movieID.toString(),
        'image': base64Image,
      },
    );
    if (response.statusCode == 200) {
      Map json = jsonDecode(response.body);
      if (json['result'] == 'success') {
        if (!mounted) return;
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Sukses mengupload Scene')));setState(() {
    bacaData();
    });
    }
    } else {
    throw Exception('Failed to read API');
    }
  }

  Future<void> deleteScene(String sceneFileName) async {
    final response = await http.post(
      Uri.parse("https://ubaya.xyz/flutter/160721036/deletemoviescene.php"),
      body: {
        'movie_id': widget.movieID.toString(),
        'scene': sceneFileName,
      },
    );
    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      if (result['result'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Scene deleted successfully')),
        );
        setState(() {
          bacaData();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to delete the scene')),
        );
      }
    } else {
      throw Exception('Failed to delete scene');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Popular Movie"),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            Padding(
                padding: EdgeInsets.all(10),
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Title',
                  ),
                  onChanged: (value) {
                    _pm!.title = value;
                  },
                  controller: _titleCont,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'judul harus diisi';
                    }
                    return null;
                  },
                )),
            Padding(
                padding: EdgeInsets.all(10),
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Website',
                  ),
                  onChanged: (value) {
                    _pm!.homepage = value;
                  },
                  controller: _homepageCont,
                  validator: (value) {
                    if (value == null || !Uri.parse(value).isAbsolute) {
                      return 'alamat website salah';
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
                    _pm!.overview = value;
                  },
                  controller: _overviewCont,
                  keyboardType: TextInputType.multiline,
                  minLines: 3,
                  maxLines: 6,
                )),
            Padding(
                padding: EdgeInsets.all(10),
                child: TextFormField(
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  decoration: const InputDecoration(
                    labelText: 'Runtime',
                  ),
                  controller: _runtimeCont,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Runtime harus diisi';
                    }
                    return null;
                  },
                )),
            Padding(
                padding: EdgeInsets.all(10),
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'URL Poster',
                  ),
                  onChanged: (value) {
                    validateImage(value).then((v) {
                      if(v)
                      {
                        setState(() {
                        });
                      }
                    }
                    );
                  },
                  controller: _urlCont,
                  validator: (value) {
                    if (value == null || !Uri.parse(value).isAbsolute) {
                      return 'alamat url salah';
                    }
                    return null;
                  },
                )),
            if(_urlCont.text!='') Image.network(_urlCont.text),

            Padding(padding: EdgeInsets.all(10), child: Text('Genre:')),
            if(_pm != null)
              Padding(
                  padding: EdgeInsets.all(10),
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: _pm!.genres!.length ?? 0,
                      itemBuilder: (BuildContext ctxt, int index) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(_pm!.genres![index]['genre_name']),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                setState(() {
                                  deleteMovieGenre(widget.movieID, _pm!.genres![index]['genre_id']);
                                });
                              },
                            ),
                          ],
                        );
                      })),
            if(_pm != null)
              Padding(
                  padding: const EdgeInsets.all(10),
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: _pm!.scene!.length,
                      itemBuilder: (BuildContext ctxt, int index) {
                        String sceneFileName = _pm!.scene![index];
                        return Row(
                            children: [
                         Image.network("https://ubaya.xyz/flutter/160721036/"+_pm?.scene?[index]),
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  deleteScene(sceneFileName);
                                },
                              ),
                            ]);
                      })),
            if (_pm != null)
              Padding(
                padding: const EdgeInsets.all(10),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _pm!.scene!.length,
                  itemBuilder: (BuildContext ctxt, int index) {
                    String sceneFileName = _pm!.scene![index];
                    return Row(
                      children: [
                        Image.network("https://ubaya.xyz/flutter/160721036/$sceneFileName"),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            deleteScene(sceneFileName);
                          },
                        ),
                      ],
                    );
                  },
                ),
              ),
            Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: comboGenre),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                onPressed: () {
                  var state = _formKey.currentState;
                  if (state == null || !state.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Harap Isian diperbaiki')));
                  } else {
                    submit();
                  }
                },
                child: Text('Submit'),
              ),
            ),
            const Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Text("Scenes")),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                onPressed: () {
                  _showPicker(context);
                },
                child: const Text('Pick Scene'),
              ),
            ),

            if(_imageBytes!=null)
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Image.memory(_imageBytes!)),
            if(_imageBytes!=null)
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: ElevatedButton(child: const Text("Upload"),
                      onPressed: () => uploadScene64())),
          ],
        ),
      ),
    );
  }
}
