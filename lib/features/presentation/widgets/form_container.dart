import 'package:flutter/material.dart';
import 'package:social/constants.dart';

class FormContainer extends StatefulWidget {
  const FormContainer({super.key, this.controller, this.fieldkey, this.isPasswordField, this.hintText, this.labelText, this.helperText, this.onSaved, this.validator, this.onFieldSubmitted, this.type, this.prefixIcon, this.isFilled=true, this.maxLines=1});
  final TextEditingController? controller;
  final Key? fieldkey;
  final bool? isPasswordField;
  final String? hintText;
  final String? labelText;
  final String? helperText;
  final FormFieldSetter<String>? onSaved;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onFieldSubmitted;
  final TextInputType? type;
  final IconData? prefixIcon;
  final bool? isFilled;
  final int? maxLines;

  @override
  State<FormContainer> createState() => _FormContainerState();
}

class _FormContainerState extends State<FormContainer> {
  bool _obscureText = true;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextFormField(
        key: widget.fieldkey,
        controller: widget.controller,
        keyboardType: widget.type,
        cursorColor: primary,
        obscureText: widget.isPasswordField == true ? _obscureText : false,
        onSaved: widget.onSaved,
        validator: widget.validator,
        onFieldSubmitted: widget.onFieldSubmitted,
        maxLines: widget.maxLines,
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: TextStyle(
              fontFamily: "Roboto",
              color: grey500, fontSize: 14),
          prefixIcon: Icon(widget.prefixIcon,size: 20,),
          prefixIconColor: grey500,
          fillColor: const Color(0xffF8F9F9).withOpacity(0.7),
          filled: widget.isFilled,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50)),
          contentPadding: const EdgeInsets.only(top: 20, left: 20),
          enabledBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(50)),
            borderSide:
            BorderSide(width: 1.5, color: grey400!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(50)),
            borderSide:
            BorderSide(width: 1.5, color: grey500!),
          ),
          suffixIcon: GestureDetector(
              onTap: (){
                setState(() {
                  _obscureText=!_obscureText;
                });
              },
              child: widget.isPasswordField == true ? Icon(_obscureText?Icons.visibility_off : Icons.visibility,color: grey400,size: 20,):const Text(""),
          )
        ),
      ),
    );
  }
}
