import 'package:e_commerce/constants/Kcolors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomDropdown extends StatelessWidget {
  final String label;
  final List<DropdownMenuItem<String>> items;
  final void Function(String?)? onChanged;
  final String? Function(String?)? validator;
  final double bottomPadding;
  final bool isLoading;
  final bool isEnabled;
  final IconData? prefixIcon;

  const CustomDropdown({
    super.key,
    required this.label,
    required this.items,
    this.onChanged,
    this.validator,
    this.bottomPadding = 10.0,
    this.isEnabled = true,
    this.prefixIcon,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: bottomPadding.h),
      child: DropdownButtonFormField<String>(
        items: items,
        onChanged: isEnabled ? onChanged : null,
        validator: validator,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          labelText: label,
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
          prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
          enabled: !isLoading,
          suffixIcon: isLoading
              ? const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(
                    color: baseColor,
                    strokeWidth: 2,
                  ),
                )
              : null,
          enabledBorder: _buildBorder(const Color(0xffEBEDEC)),
          focusedBorder: _buildBorder(const Color(0xff5AC268)),
          errorBorder: _buildBorder(Colors.red),
          focusedErrorBorder: _buildBorder(Colors.red),
          disabledBorder: _buildBorder(const Color(0xffEBEDEC)),
        ),
        dropdownColor: Colors.white,
        iconEnabledColor: Colors.black,
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
