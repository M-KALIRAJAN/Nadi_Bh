import 'package:flutter/material.dart';
import 'package:nadi_user_app/core/constants/app_consts.dart';

class AppTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String? label;
  final TextInputType keyboardType;
  final bool isPassword;
  final IconData? prefixIcon;
  final String? Function(String?)? validator;
  final bool readonly;
  final bool enabled;
  final int? minLines;
  final int? maxLines;
  final String? prefixText;
  const AppTextField({
    super.key,
    this.controller,
    this.label,
    this.keyboardType = TextInputType.text,
    this.isPassword = false,
    this.prefixIcon,
    this.prefixText,
    this.validator,
    this.readonly = false,
    this.enabled = true,
    this.minLines,
    this.maxLines,
  });
  @override
  State<AppTextField> createState() => _AppTextFieldState();
}
class _AppTextFieldState extends State<AppTextField> {
  bool _obscure = true;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: widget.readonly,
      enabled: widget.enabled,
      controller: widget.controller,
      obscureText: widget.isPassword ? _obscure : false,
      keyboardType: widget.keyboardType,
      validator: widget.validator,
      minLines: widget.minLines,
      maxLines: widget.maxLines ?? (widget.isPassword ? 1 : 1),
      decoration: InputDecoration(
        labelText: widget.label,
        prefixText: widget.prefixText,
        labelStyle: const TextStyle(fontSize: 14, color: Color(0xFF79747E)),
        floatingLabelStyle: const TextStyle(color: AppColors.app_background_clr),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 10,
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.black26),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:  BorderSide(color:AppColors.app_background_clr ,width: 1.5)
        ),

        //   EYE ICON (Password)
        suffixIcon: widget.isPassword
            ? IconButton(
                icon: Icon(
                  _obscure ? Icons.visibility_off : Icons.visibility,
                  color: Colors.grey,
                ),
                onPressed: () {
                  setState(() => _obscure = !_obscure);
                },
              )
            : null,
      ),
    );
  }
}
