// widgets/custom_text_field.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomTextField extends StatefulWidget {
  final String label;
  final String hintText;
  final bool isRequired;

  final String fieldType;
  final String? initialValue;
  final Function(String)? onChanged;
  final bool isCompact;
  final bool isPassword;
  final bool enabled;
  final int? maxLength;

  const CustomTextField({
    super.key,
    required this.label,
    required this.hintText,
    this.isRequired = false,
    this.fieldType = 'text',
    this.initialValue,
    this.onChanged,
    this.isCompact = false,
    this.isPassword = false,
    this.enabled = true,
    this.maxLength,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late TextEditingController _controller;
  bool _obscureText = true;
  bool _isUpdating = false;


  String? _selectedDateForSaving;

  @override
  void initState() {
    super.initState();


    if (widget.fieldType == 'date' && widget.initialValue != null && widget.initialValue!.isNotEmpty) {
      try {

        DateTime date = DateFormat('yyyy-MM-dd').parse(widget.initialValue!);

        _controller = TextEditingController(
            text: DateFormat('dd-MM-yyyy').format(date)
        );
        _selectedDateForSaving = widget.initialValue; // Store original format
      } catch (e) {
        _controller = TextEditingController(text: widget.initialValue);
        _selectedDateForSaving = widget.initialValue;
      }
    } else {
      _controller = TextEditingController(text: widget.initialValue ?? '');
    }

    _controller.addListener(_onTextChanged);
  }

  @override
  void didUpdateWidget(CustomTextField oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.initialValue != oldWidget.initialValue && !_isUpdating) {
      _isUpdating = true;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {

          if (widget.fieldType == 'date' && widget.initialValue != null && widget.initialValue!.isNotEmpty) {
            try {
              DateTime date = DateFormat('yyyy-MM-dd').parse(widget.initialValue!);
              _controller.text = DateFormat('dd-MM-yyyy').format(date);
              _selectedDateForSaving = widget.initialValue;
            } catch (e) {
              _controller.text = widget.initialValue ?? '';
              _selectedDateForSaving = widget.initialValue;
            }
          } else {
            _controller.text = widget.initialValue ?? '';
          }

          _controller.selection = TextSelection.fromPosition(
            TextPosition(offset: _controller.text.length),
          );
          _isUpdating = false;
        }
      });
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    super.dispose();
  }

  void _onTextChanged() {

    if (!_isUpdating && widget.onChanged != null) {

      if (widget.fieldType == 'date' && _selectedDateForSaving != null) {
        widget.onChanged!(_selectedDateForSaving!);
      } else {
        widget.onChanged!(_controller.text);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              widget.label,
              style: TextStyle(
                fontSize: widget.isCompact ? 13 : 14,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF374151),
              ),
            ),
            if (widget.isRequired)
              const Text(' *', style: TextStyle(color: Color(0xFFEF4444))),
          ],
        ),
        const SizedBox(height: 8),
        widget.fieldType == 'multiline'
            ? _buildMultilineField()
            : _buildTextField(),
      ],
    );
  }

  Widget _buildTextField() {
    return TextField(
      controller: _controller,
      obscureText: widget.isPassword ? _obscureText : false,
      enabled: widget.enabled,
      maxLength: widget.maxLength,
      keyboardType: widget.fieldType == 'date'
          ? TextInputType.none
          : widget.fieldType == 'number'
          ? TextInputType.number
          : TextInputType.text,
      style: TextStyle(
        fontSize: widget.isCompact ? 13 : 14,
        color: const Color(0xFF1F2937),
      ),
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: const TextStyle(color: Color(0xFF999999), fontSize: 13),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF4F46E5), width: 2),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: 12,
          vertical: widget.isCompact ? 10 : 14,
        ),
        counterText: widget.maxLength != null ? null : '',
        suffixIcon: widget.isPassword
            ? IconButton(
          icon: Icon(
            _obscureText ? Icons.visibility_off : Icons.visibility,
            color: Colors.grey,
            size: 20,
          ),
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
        )
            : null,
        prefixIcon: widget.fieldType == 'date'
            ? const Icon(Icons.calendar_today, color: Colors.grey, size: 18)
            : null,
      ),
      onTap: widget.fieldType == 'date' ? _selectDate : null,
    );
  }

  Widget _buildMultilineField() {
    return TextField(
      controller: _controller,
      maxLines: 4,
      enabled: widget.enabled,
      style: const TextStyle(fontSize: 14, color: Color(0xFF1F2937)),
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: const TextStyle(color: Color(0xFF999999), fontSize: 13),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF4F46E5), width: 2),
        ),
        contentPadding: const EdgeInsets.all(12),
      ),
    );
  }

  Future<void> _selectDate() async {

    DateTime initialDate = DateTime.now();
    if (_selectedDateForSaving != null && _selectedDateForSaving!.isNotEmpty) {
      try {
        initialDate = DateFormat('yyyy-MM-dd').parse(_selectedDateForSaving!);
      } catch (e) {
        initialDate = DateTime.now();
      }
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );

    if (picked != null) {

      String saveFormat = DateFormat('yyyy-MM-dd').format(picked);


      String displayFormat = DateFormat('dd-MM-yyyy').format(picked);

      setState(() {
        _controller.text = displayFormat;
        _selectedDateForSaving = saveFormat;
      });

      // Send SAVE format to ViewModel (yyyy-MM-dd)
      if (widget.onChanged != null) {
        widget.onChanged!(saveFormat);
      }
    }
  }
}