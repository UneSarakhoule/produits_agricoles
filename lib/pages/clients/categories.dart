import 'package:flutter/material.dart';
import 'package:agricol/models/constants.dart';

import 'ProductListByCategory.dart';

class Categories extends StatefulWidget {
  const Categories({super.key});

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  Constants myConstants = Constants();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 100, left: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Catégories',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 120, // Hauteur du conteneur pour les catégories
                child: ListView(
                  scrollDirection: Axis.horizontal, // Défilement horizontal
                  children: [
                    // Légumes
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductListByCategory(category: 'Légumes'),
                          ),
                        );
                      },
                      child: Container(
                        height: 150,
                        width: 150,
                        margin: const EdgeInsets.only(right: 15), // Espacement entre les conteneurs
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [myConstants.gradient1, myConstants.gradient2],
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image(
                              image: AssetImage('assets/images/legumes.png'),
                              height: 80,
                              width: 80,
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Légumes',
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Fruits
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductListByCategory(category: 'Fruits'),
                          ),
                        );
                      },
                      child: Container(
                        height: 150,
                        width: 150,
                        margin: const EdgeInsets.only(right: 15),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [myConstants.vert, myConstants.vert2],
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image(
                              image: AssetImage('assets/images/fruits.png'),
                              height: 80,
                              width: 80,
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Fruits',
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Epices
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductListByCategory(category: 'Epices'),
                          ),
                        );
                      },
                      child: Container(
                        height: 150,
                        width: 150,
                        margin: const EdgeInsets.only(right: 10),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [myConstants.red1, myConstants.red2],
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image(
                              image: AssetImage('assets/images/epices.png'),
                              height: 80,
                              width: 80,
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Épices',
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
