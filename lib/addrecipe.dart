import 'package:flutter/material.dart';
import 'package:helloworld/class/recipe.dart';

class AddRecipe extends StatefulWidget {
  const AddRecipe({super.key});

  @override
  State<StatefulWidget> createState() {
    return _AddRecipeState();
  }
}

class _AddRecipeState extends State<AddRecipe> {
  final TextEditingController _recipeNameController = TextEditingController();
  final TextEditingController _recipeDescController = TextEditingController();
  final TextEditingController _recipePhotoController = TextEditingController();
  int _charleft = 0;
  String _recipeCategory = "Indonesian";
  bool _isSpicy = false;

  @override
  void initState() {
    super.initState();
    _recipeNameController.text = "your food name";
    _recipeDescController.text = "Recipe of ..";
    _charleft = 200 - _recipeDescController.text.length;
  }

  Color getButtonColor(Set<MaterialState> states) {
    if (states.contains(MaterialState.pressed)) {
      return Colors.red;
    } else {
      return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Recipe'),
      ),
      body: Column(
        children: [
          Text('Nama Makanan'),
          TextField(
            // decoration: new InputDecoration.collapsed(
            //     hintText: _recipeNameController.text
            // ),
            controller: _recipeNameController,
            onChanged: (v) {
              print(_recipeNameController.text);
              print(v);
            },
          ),
          TextField(
            controller: _recipeDescController,
            onChanged: (v) {
              setState(() {
                _charleft = 200 - v.length;
              });
            },
            keyboardType: TextInputType.multiline,
            minLines: 4,
            maxLines: null,
          ),
          Text("char left : $_charleft"),
          TextField(
            controller: _recipePhotoController,
            onSubmitted: (v) {
              setState(() {});
            },
          ),
          Image.network(_recipePhotoController.text),
          DropdownButton(
            items: const [
              DropdownMenuItem(
                value: "Indonesian",
                child: Text("Indonesian"),
              ),
              DropdownMenuItem(
                value: "Japanese",
                child: Text("Japanese"),
              ),
              DropdownMenuItem(
                value: "Korean",
                child: Text("Korean"),
              ),
            ],
            value: _recipeCategory,
            onChanged: (value) {
              setState(() {
                _recipeCategory = value!;
              });
            },
          ),
          Row(
            children: [
              Checkbox(
                value: _isSpicy,
                onChanged: (bool? value) {
                  setState(() {
                    _isSpicy = value!;
                  });
                },
              ),
              const Text('Is Spicy')
            ],
          ),
          ElevatedButton(
              style: ButtonStyle(
                elevation: MaterialStateProperty.all(5),
                backgroundColor: MaterialStateProperty.resolveWith(getButtonColor),
              ),
              onPressed: () {
                recipes.add(
                  Recipe(id: recipes.length + 1, name: _recipeNameController.text, desc: _recipeDescController.text, photo: _recipePhotoController.text, category: _recipeCategory, isSpicy: _isSpicy),
                );
                showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                          title: Text('Add Recipe'),
                          content: Text('Recipe successfully added'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.pop(context, 'OK'),
                              child: const Text('OK'),
                            ),
                          ],
                        ));
              },
              child: const Text('SUBMIT')),
        ],
      ),
    );
  }
}
