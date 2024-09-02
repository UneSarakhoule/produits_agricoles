import 'package:flutter/material.dart';

import '../../models/constants.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool isDarkTheme = false; // Initialisation de la variable isDarkTheme

  String? selectedType = 'Français';

  @override
  Widget build(BuildContext context) {
    Constants myConstants = Constants();
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: myConstants.secondaryColor,
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              height: screenHeight,
              child: Center(
                child: Container(
                  width: screenWidth * 1.8,
                  height: screenHeight * 0.50,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.05,
                      vertical: screenHeight * 0.07,
                    ),
                    child: Column(

                      children: [
                        _buildDropdown(myConstants),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            //LANGUE
            Positioned(
              left: 29,
              top: 151,
              child: Text(
                'Langue',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: myConstants.blackColor,
                  fontSize: 15,
                  fontFamily: 'Calibri',
                  fontWeight: FontWeight.w400,
                  height: 0,
                ),
              ),
            ),

            // PARAMETRE
            Positioned(
              left: 22,
              top: 79,
              child: Text(
                'PARAMETRES',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: myConstants.blackColor,
                  fontSize: 20,
                  fontFamily: 'Calibri',
                  fontWeight: FontWeight.bold,
                  height: 0,
                ),
              ),
            ),

            //LA LIGNE
            Positioned(
              left: 19,
              top: 120,
              child: Container(
                width: 300,
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      width: 1,
                      strokeAlign: BorderSide.strokeAlignCenter,
                      color: myConstants.gris2,
                    ),
                  ),
                ),
              ),
            ),

            // THEME
            Positioned(
              top: 260,
              left: 20,
              right: 0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Theme',
                    style: TextStyle(
                      fontSize: 15,
                      fontFamily: 'Calibri',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  CheckboxListTile(
                    title: const Text('Dark'),
                    value: isDarkTheme,
                    onChanged: (bool? value) {
                      setState(() {
                        isDarkTheme = value ?? false;
                      });
                    },
                  ),
                  CheckboxListTile(
                    title: const Text('Light'),
                    value: !isDarkTheme,
                    onChanged: (bool? value) {
                      setState(() {
                        isDarkTheme = !(value ?? true);
                      });
                    },
                  ),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }

  Widget _buildDropdown(Constants myConstants) {
    return Container(
      width: double.infinity,
      height: 40,
      decoration: ShapeDecoration(
        color: myConstants.gris,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: DropdownButtonFormField<String>(
        value: selectedType,
        decoration: InputDecoration(
          filled: true,
          fillColor: myConstants.thirtyColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
        ),
        items: [
          DropdownMenuItem(
            value: 'Français',
            child: Row(
              children: [
                Text(
                  'Français',
                  style: TextStyle(fontSize: 13, color: myConstants.blackColor),
                ),
              ],
            ),
          ),
          DropdownMenuItem(
            value: 'Anglais',
            child: Row(
              children: [
                Text(
                  'Anglais',
                  style: TextStyle(fontSize: 13, color: myConstants.blackColor),
                ),
              ],
            ),
          ),
        ],
        onChanged: (value) {
          setState(() {
            selectedType = value;
          });
        },
        icon: Icon(
          Icons.arrow_drop_down,
          color: myConstants.gris,
        ),
      ),
    );
  }
}

