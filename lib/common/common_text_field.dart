import 'package:flutter/material.dart';

// Reusable text field widget
// From https://www.boltuix.com/2023/05/how-to-use-flutter-text-field-complete.html
class CommonTextField extends StatefulWidget {
  // Properties of CommonTextField
  final TextEditingController controller;  // Text input controller
  final String? hintText;  // Hint text to be displayed when the field is empty
  final TextInputType? keyboardType;  // Keyboard type to display
  final bool obscureText;  // To obscure input text (i.e. password)
  final Function(String)? onChanged;  // Callback function for text changes
  final String? helperText;  // To assist the user when typing
  final String? labelText;  // Label text
  final int? maxLines;  // Max number of lines allowed for the field
  final bool hasError;
  final IconData? prefixIconData;
  final IconData? passwordHideIcon;
  final IconData? passwordShowIcon;
  final TextInputAction? textInputAction;  // Action button on the keyboard
  final Color? textColor;  // Input text color
  final Color? accentColor;  // Accent color of the field

  // Constructor
  const CommonTextField({
    super.key,
    required this.controller,
    this.hintText,
    this.keyboardType,
    this.obscureText = false,
    this.onChanged,
    this.helperText,
    this.labelText,
    this.hasError = false,
    this.prefixIconData,
    this.passwordHideIcon,
    this.passwordShowIcon,
    this.textInputAction,
    this.textColor,
    this.maxLines = 1,
    this.accentColor,
  });

  // Creates state for CommonTextField
  @override
  _CommonTextFieldState createState() => _CommonTextFieldState();
}

// State class for CommonTextFieldState
class _CommonTextFieldState extends State<CommonTextField> {
  bool _isObscure = false;

  // CommonTextField's UI
  @override
  Widget build(BuildContext context) {
    // Get current time
    final theme = Theme.of(context);
    // Sets the properties of CommonTextFieldState
    return TextField(
      controller: widget.controller,
      keyboardType: widget.keyboardType,
      obscureText: _isObscure,
      onChanged: widget.onChanged,
      textInputAction: widget.textInputAction,
      maxLines: !_isObscure ? widget.maxLines : 1,
      style: TextStyle(color: widget.textColor ?? Colors.black54), // Set text color

      // Input decoration
      decoration: InputDecoration(
        hintText: widget.hintText,
        labelText: widget.labelText ?? 'Default Simple TextField', // Use confirmation text as label if provided, else use default label text
        labelStyle: TextStyle(color: widget.accentColor ?? Colors.black54), // Set accent color
        helperText: widget.helperText,

        // Prefix icon
        prefixIcon: widget.prefixIconData != null
            ? Icon(widget.prefixIconData,
            color: widget.accentColor ?? theme.colorScheme.primary) // Set accent color for prefix icon
            : null,

        // Suffix Icon
        suffixIcon: widget.obscureText
            ? IconButton(
          onPressed: () {
            setState(() {
              _isObscure = !_isObscure;
            });
          },
          icon: Icon(_isObscure ? widget.passwordShowIcon ??
              Icons.visibility : widget.passwordHideIcon ?? Icons.visibility_off),
          color: widget.accentColor ?? theme.colorScheme.primary,
        )
            : null,

        // Paddings and border styles
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: theme.primaryColor, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: theme.colorScheme.secondary, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: theme.disabledColor, width: 1),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
      ),
    );
  }
}
