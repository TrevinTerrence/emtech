import 'package:flutter/material.dart';
import 'package:helloworld/itemBasket.dart';
import 'class/recipe.dart';

class Basket extends StatelessWidget {

  Basket({super.key});

  List<Widget> widRecipes() {
    List<Widget> temp = [];
    int i = 0;
    while (i < recipes.length) {
      Widget w = Container(
          margin: const EdgeInsets.all(15),
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: -6,
              blurRadius: 8,
              offset: const Offset(8, 7),
            ),
          ]),
          child: Card(
              child: Column(children: [
            Container(
                margin: const EdgeInsets.all(15),
                child: Text(
                  recipes[i].name,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                )),
            Image.network(recipes[i].photo),
                if (recipes[i].isSpicy)
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.local_fire_department, color: Colors.red),
                        const SizedBox(width: 5),
                        const Text(
                          'Spicy',
                          style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                Divider(height: 10),
                Container(
                  alignment: FractionalOffset.centerLeft,
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text("Kategori: ${recipes[i].category}"),
                ),
            Container(
              margin: const EdgeInsets.all(20),
              child: Text(recipes[i].desc),
            )
          ])));
      temp.add(w);
      i++;
    }
    return temp;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Basket'),
      ),
      body: SingleChildScrollView(
          child: Column(children: [
        Text("Your basket "),
        ListView(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          children: widRecipes(),
        ),
        Divider(
          height: 100,
        )
      ])),
    );
  }
}


