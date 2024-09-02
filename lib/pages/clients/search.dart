import 'package:flutter/material.dart';

import '../../models/constants.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {

  @override
  Widget build(BuildContext context) {
    Constants myConstants = Constants();
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: myConstants.secondaryColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          '',
        ),
        centerTitle: true,
        leading:
        IconButton(
          onPressed: (){
            Navigator.pushNamed(context, '/bottomNavigation');},
          icon: Icon(Icons.arrow_back),
        ),
        actions: [
          IconButton(
            onPressed: (){},
            icon: Icon(Icons.person),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(22),
        child: Stack(
          children: [
            Column(
              children: [
                const SizedBox(height: 90,),
                SearchBar(
                  leading: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.search_sharp),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 8.0),
                        height: 24.0,
                        width: 1.0,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                  hintText: 'Rechercher ...',
                  backgroundColor: const WidgetStatePropertyAll(Colors.white),
                ),
              ],
            ),
            Positioned(
              left: 22,
              top: 288,
              child: Container(
                width: screenWidth * 0.8,
                height: screenHeight * 0.4,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/search.jpg'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),

    );
  }
}
