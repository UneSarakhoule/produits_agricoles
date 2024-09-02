import 'package:flutter/material.dart';
import 'package:agricol/models/constants.dart';

class MyTextField extends StatelessWidget {


  final TextEditingController? controller;
  final Key? fieldkey;
  final String? hintText;
  final String? labelText;
  final TextInputType? keyboardType;
  final Widget? prefixIcon;
  final FormFieldSetter<String>? onSaved;
  final FormFieldValidator<String>? validator;
  final String? errorMsg;
  final String? globalErrorMsg;
  final bool obscureText;
  final bool? isPasswordField;

  const MyTextField({super.key,
    this.prefixIcon,
    this.validator,
    this.errorMsg,
    this.fieldkey,
    this.isPasswordField,
    this.labelText,
    this.controller,
    this.hintText,
    this.keyboardType,
    this.onSaved,
    this.globalErrorMsg,
    required this.obscureText,
  }) ;


  @override
  Widget build(BuildContext context) {
    Constants myConstants = Constants();
    return Container(
      height: 40,
      decoration: ShapeDecoration(
        color: myConstants.color9,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          prefixIcon: prefixIcon,
          hintText: hintText,
          hintStyle: TextStyle(
            color: myConstants.color7,
            fontSize: 13,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w400,
            height: 1,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
          errorText: errorMsg,
        ),
        validator: validator,
        style: TextStyle(
          color: myConstants.color7,
          fontSize: 13,
        ),
      ),
    );
  }


}


