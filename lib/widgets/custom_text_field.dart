import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextField extends StatefulWidget {
  final String text;
  final bool isPassword;
  final String? Function(String?)? validator;
  final void Function(String)? onSubmit;
  final TextEditingController? controller;
  final TextInputType inputType;
  final double bottomPadding;
  final FocusNode? currentFocusNode;
  final bool isEnabled;
  final IconData? prefixIcon;
  final String? initText;

  const CustomTextField({
    super.key,
    required this.text,
    this.isPassword = false,
    this.validator,
    this.onSubmit,
    this.controller,
    this.inputType = TextInputType.text,
    this.bottomPadding = 10.0,
    this.currentFocusNode,
    this.isEnabled = true,
    this.prefixIcon,
    this.initText,
  });

  @override
  CustomTextFieldState createState() => CustomTextFieldState();
}

class CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;
  Color _activeBorderColor = const Color(0xffEBEDEC);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: widget.bottomPadding.h),
      child: TextFormField(
        style: const TextStyle(
          fontSize: 19,
          fontWeight: FontWeight.w500,
          color: Colors.black,
          fontFamily: "Poppins",
        ),
        initialValue: widget.initText,
        focusNode: widget.currentFocusNode,
        enabled: widget.isEnabled,
        onFieldSubmitted: widget.onSubmit,
        keyboardType: widget.inputType,
        obscureText: widget.isPassword ? _obscureText : false,
        validator: widget.validator,
        controller: widget.controller,
        onChanged: (val) {
          setState(() {
            _activeBorderColor = val.isNotEmpty ? const Color(0xff5AC268) : const Color(0xffEBEDEC);
          });
        },
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          labelText: widget.text,
          floatingLabelStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black54,
            fontFamily: "Poppins",
          ),
          labelStyle: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w500,
            color: Colors.black54,
            fontFamily: "Poppins",
          ),
          prefixIcon: widget.prefixIcon != null ? Icon(widget.prefixIcon) : null,
          enabledBorder: _buildBorder(_activeBorderColor),
          focusedBorder: _buildBorder(const Color(0xff5AC268)),
          errorBorder: _buildBorder(Colors.red),
          focusedErrorBorder: _buildBorder(Colors.red),
          disabledBorder: _buildBorder(_activeBorderColor),
          suffixIcon: widget.isPassword
              ? IconButton(
            icon: Icon(!_obscureText ? CupertinoIcons.eye : CupertinoIcons.eye_slash),
            onPressed: () {
              setState(() {
                _obscureText = !_obscureText;
              });
            },
          )
              : null,
        ),
      ),
    );
  }

  OutlineInputBorder _buildBorder(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(15.r),
      borderSide: BorderSide(color: color, width: 2.0.w),
    );
  }
}
