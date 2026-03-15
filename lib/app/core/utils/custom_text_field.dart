import 'package:demo_project/app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool? isObscureText;
  final String? obscure;
  final Color? filColor;
  final Widget? prefixIcon;
  final String? labelText;
  final String? hintText;
  final double? contentPaddingHorizontal;
  final double? contentPaddingVertical;
  final Widget? suffixIcon;
  final FormFieldValidator? validator;
  final Function(String)? onFieldSubmitted;
  final Function(String)? onChanged;
  final bool isPassword;
  final bool? isEmail;
  final bool? filled;
  final bool? readOnly;
  final int? minLines;

  const CustomTextField({
    super.key,
    this.contentPaddingHorizontal,
    this.contentPaddingVertical,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.minLines,
    this.isEmail,
    this.onFieldSubmitted,
     this.controller,
    this.keyboardType = TextInputType.text,
    this.isObscureText = false,
    this.filled = false,
    this.readOnly = false,
    this.obscure = '*',
    this.onChanged,
    this.filColor,
    this.labelText,
    this.isPassword = false,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool obscureText = true;

  void toggle() {
    setState(() {
      obscureText = !obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      keyboardType: widget.keyboardType,
      obscuringCharacter: widget.obscure!,
      minLines: widget.minLines,
      // validator: widget.validator,
      onFieldSubmitted: widget.onFieldSubmitted,
      onChanged: widget.onChanged,
      validator: widget.validator,

      cursorColor: AppColors.primary,
      obscureText: widget.isPassword ? obscureText : false,
      readOnly: widget.readOnly ?? false,

      style: TextStyle(color: Color(0xFF747376), fontSize: 16),
      decoration: InputDecoration(
        filled: widget.filled,
        contentPadding: EdgeInsets.symmetric(
          horizontal: widget.contentPaddingHorizontal ?? 15,
          vertical: widget.contentPaddingVertical ?? 15,
        ),
        fillColor: widget.filColor,
        prefixIcon: Padding(
          padding: const EdgeInsets.all(8.0),
          child: widget.prefixIcon,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Color(0xFF94A3B8),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Color(0xFF94A3B8),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Color(0xFF94A3B8),
          ),
        ),
        suffixIcon: widget.isPassword
            ? GestureDetector(
                onTap: toggle,
                child: _suffixIcon(
                  obscureText ? Icons.visibility_off : Icons.visibility,
                ),
              )
            : widget.suffixIcon,
        prefixIconConstraints: BoxConstraints(minHeight: 24, minWidth: 24),
        labelText: widget.labelText,
        hintText: widget.hintText,
        hintStyle: TextStyle(
          color: Color(0xFF747376),
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  _suffixIcon(IconData icon) {
    return Padding(padding: EdgeInsets.all(14), child: Icon(icon, size: 20));
  }
}
