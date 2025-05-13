// Fixed CustomFormField.dart to handle password visibility better
import 'package:deepex/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum InputFieldType {
  text,
  email,
  password,
  phone,
  number,
  multiline,
}

class CustomFormField extends StatefulWidget {
  final String label;
  final String? hint;
  final String? helperText;
  final String? errorText;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final bool isRequired;
  final bool readOnly;
  final bool autoFocus;
  final bool obscureText;
  final bool enabled;
  final int? maxLength;
  final int maxLines;
  final int minLines;
  final InputFieldType inputType;
  final TextInputAction? textInputAction;
  final Widget? prefix;
  final Widget? suffix;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final List<TextInputFormatter>? inputFormatters;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final Function()? onTap;
  final String? Function(String?)? validator;
  final TextCapitalization textCapitalization;
  final EdgeInsetsGeometry? contentPadding;
  final BoxConstraints? suffixIconConstraints;
  final BoxConstraints? prefixIconConstraints;
  final double borderRadius;
  final Color? fillColor;
  final Color? borderColor;
  final Color? focusedBorderColor;
  final Color? errorBorderColor;
  final Color? textColor;
  final Color? labelColor;
  final Color? hintColor;
  final Color? cursorColor;

  const CustomFormField({
    super.key,
    required this.label,
    this.hint,
    this.helperText,
    this.errorText,
    this.controller,
    this.focusNode,
    this.isRequired = false,
    this.readOnly = false,
    this.autoFocus = false,
    this.obscureText = false,
    this.enabled = true,
    this.maxLength,
    this.maxLines = 1,
    this.minLines = 1,
    this.inputType = InputFieldType.text,
    this.textInputAction,
    this.prefix,
    this.suffix,
    this.prefixIcon,
    this.suffixIcon,
    this.inputFormatters,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.validator,
    this.textCapitalization = TextCapitalization.none,
    this.contentPadding,
    this.suffixIconConstraints,
    this.prefixIconConstraints,
    this.borderRadius = 8.0,
    this.fillColor,
    this.borderColor,
    this.focusedBorderColor,
    this.errorBorderColor,
    this.textColor,
    this.labelColor,
    this.hintColor,
    this.cursorColor,
  });

  @override
  State<CustomFormField> createState() => _CustomFormFieldState();
}

class _CustomFormFieldState extends State<CustomFormField> {
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    // Important: Start with the widget's obscureText value
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void didUpdateWidget(CustomFormField oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update _obscureText if the widget's obscureText changed
    if (oldWidget.obscureText != widget.obscureText) {}
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {});
  }

  // We're not using this as we'll let the parent component handle toggling
  // This is commented out intentionally to avoid conflicts
  /*
  void _toggleObscureText() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }
  */

  TextInputType _getKeyboardType() {
    switch (widget.inputType) {
      case InputFieldType.email:
        return TextInputType.emailAddress;
      case InputFieldType.phone:
        return TextInputType.phone;
      case InputFieldType.number:
        return TextInputType.number;
      case InputFieldType.multiline:
        return TextInputType.multiline;
      case InputFieldType.password:
      case InputFieldType.text:
        return TextInputType.text;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    // Default colors based on theme
    final defaultFillColor = isDarkMode ? Colors.grey[800]! : Colors.grey[100]!;
    final defaultBorderColor =
        isDarkMode ? Colors.grey[700]! : Colors.grey[400]!;
    final defaultFocusedBorderColor = AppColors.primary;
    final defaultErrorBorderColor = Colors.red;
    final defaultTextColor = isDarkMode ? Colors.white : Colors.black87;
    final defaultLabelColor = isDarkMode ? Colors.white70 : Colors.black54;
    final defaultHintColor = isDarkMode ? Colors.grey[500]! : Colors.grey[500]!;
    final defaultCursorColor = AppColors.primary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label.isNotEmpty) ...[
          Row(
            children: [
              Text(
                widget.label,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  color: widget.labelColor ?? defaultLabelColor,
                ),
              ),
              if (widget.isRequired)
                Text(
                  ' *',
                  style: TextStyle(
                    color: defaultErrorBorderColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
        ],
        TextFormField(
          controller: widget.controller,
          focusNode: _focusNode,
          readOnly: widget.readOnly,
          enabled: widget.enabled,
          // Use widget.obscureText directly rather than _obscureText
          // This ensures the toggling from the parent is honored
          obscureText: widget.obscureText,
          maxLength: widget.maxLength,
          maxLines: widget.inputType == InputFieldType.multiline
              ? widget.maxLines
              : 1,
          minLines: widget.inputType == InputFieldType.multiline
              ? widget.minLines
              : 1,
          keyboardType: _getKeyboardType(),
          textInputAction: widget.textInputAction ??
              (widget.inputType == InputFieldType.multiline
                  ? TextInputAction.newline
                  : TextInputAction.next),
          textCapitalization: widget.textCapitalization,
          style: TextStyle(
            color: widget.textColor ?? defaultTextColor,
            fontSize: 16,
          ),
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: TextStyle(
              color: widget.hintColor ?? defaultHintColor,
              fontSize: 16,
            ),
            helperText: widget.helperText,
            errorText: widget.errorText,
            filled: true,
            fillColor: widget.fillColor ?? defaultFillColor,
            contentPadding: widget.contentPadding ??
                const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            prefixIcon: widget.prefixIcon,
            suffixIcon: widget.suffixIcon,
            prefix: widget.prefix,
            suffix: widget.suffix,
            prefixIconConstraints: widget.prefixIconConstraints,
            suffixIconConstraints: widget.suffixIconConstraints,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              borderSide: BorderSide(
                color: widget.borderColor ?? defaultBorderColor,
                width: 1.0,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              borderSide: BorderSide(
                color: widget.borderColor ?? defaultBorderColor,
                width: 1.0,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              borderSide: BorderSide(
                color: widget.focusedBorderColor ?? defaultFocusedBorderColor,
                width: 1.0,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              borderSide: BorderSide(
                color: widget.errorBorderColor ?? defaultErrorBorderColor,
                width: 1.0,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              borderSide: BorderSide(
                color: widget.errorBorderColor ?? defaultErrorBorderColor,
                width: 1.0,
              ),
            ),
          ),
          inputFormatters: widget.inputFormatters,
          onChanged: widget.onChanged,
          onFieldSubmitted: widget.onSubmitted,
          onTap: widget.onTap,
          validator: widget.validator,
          cursorColor: widget.cursorColor ?? defaultCursorColor,
          autocorrect: widget.inputType != InputFieldType.email &&
              widget.inputType != InputFieldType.password,
          autofocus: widget.autoFocus,
        ),
      ],
    );
  }
}
