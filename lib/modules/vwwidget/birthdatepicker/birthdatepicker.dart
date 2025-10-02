import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum DateOrder {
  mdy, // Month, Day, Year (US format)
  dmy, // Day, Month, Year (International format)
  ymd, // Year, Month, Day (Asian format)
}

class BirthdatePicker extends StatefulWidget {
  final Function(DateTime?)? onDateChanged;
  final DateTime? initialDate;
  final String? label;
  final DateOrder dateOrder;
  final bool enableDropdown;

  const BirthdatePicker({
    Key? key,
    this.onDateChanged,
    this.initialDate,
    this.label,
    this.dateOrder = DateOrder.mdy,
    this.enableDropdown = true,
  }) : super(key: key);

  @override
  State<BirthdatePicker> createState() => _BirthdatePickerState();
}

class _BirthdatePickerState extends State<BirthdatePicker> {
  late TextEditingController _monthController;
  late TextEditingController _dayController;
  late TextEditingController _yearController;

  final FocusNode _monthFocus = FocusNode();
  final FocusNode _dayFocus = FocusNode();
  final FocusNode _yearFocus = FocusNode();

  int? _selectedMonth;
  int? _selectedDay;

  @override
  void initState() {
    super.initState();
    _monthController = TextEditingController(
      text: widget.initialDate?.month.toString() ?? '',
    );
    _dayController = TextEditingController(
      text: widget.initialDate?.day.toString() ?? '',
    );
    _yearController = TextEditingController(
      text: widget.initialDate?.year.toString() ?? '',
    );

    _selectedMonth = widget.initialDate?.month;
    _selectedDay = widget.initialDate?.day;
  }

  @override
  void dispose() {
    _monthController.dispose();
    _dayController.dispose();
    _yearController.dispose();
    _monthFocus.dispose();
    _dayFocus.dispose();
    _yearFocus.dispose();
    super.dispose();
  }

  void _notifyDateChanged() {
    if (_monthController.text.isNotEmpty &&
        _dayController.text.isNotEmpty &&
        _yearController.text.isNotEmpty) {
      try {
        final month = int.parse(_monthController.text);
        final day = int.parse(_dayController.text);
        final year = int.parse(_yearController.text);

        if (month >= 1 && month <= 12 && day >= 1 && day <= 31 && year >= 1900) {
          final date = DateTime(year, month, day);
          widget.onDateChanged?.call(date);
        } else {
          widget.onDateChanged?.call(null);
        }
      } catch (e) {
        widget.onDateChanged?.call(null);
      }
    } else {
      widget.onDateChanged?.call(null);
    }
  }

  List<Widget> _buildFieldsInOrder() {
    final fields = <Widget>[];

    switch (widget.dateOrder) {
      case DateOrder.mdy:
        fields.addAll([
          Expanded(flex: 2, child: _buildMonthField()),
          const SizedBox(width: 12),
          Expanded(flex: 2, child: _buildDayField()),
          const SizedBox(width: 12),
          Expanded(flex: 3, child: _buildYearField()),
        ]);
        break;
      case DateOrder.dmy:
        fields.addAll([
          Expanded(flex: 2, child: _buildDayField()),
          const SizedBox(width: 12),
          Expanded(flex: 2, child: _buildMonthField()),
          const SizedBox(width: 12),
          Expanded(flex: 3, child: _buildYearField()),
        ]);
        break;
      case DateOrder.ymd:
        fields.addAll([
          Expanded(flex: 3, child: _buildYearField()),
          const SizedBox(width: 12),
          Expanded(flex: 2, child: _buildMonthField()),
          const SizedBox(width: 12),
          Expanded(flex: 2, child: _buildDayField()),
        ]);
        break;
    }

    return fields;
  }

  Widget _buildMonthField() {
    if (widget.enableDropdown) {
      return _buildDropdownField(
        value: _selectedMonth,
        hint: 'Month',
        items: List.generate(12, (i) => i + 1),
        onChanged: (value) {
          setState(() {
            _selectedMonth = value;
            _monthController.text = value.toString();
          });
          _notifyDateChanged();
        },
      );
    } else {
      return _buildTextField(
        controller: _monthController,
        focusNode: _monthFocus,
        nextFocus: _dayFocus,
        hint: 'Month',
        maxLength: 2,
        onChanged: (value) {
          if (value.length == 2) {
            _dayFocus.requestFocus();
          }
          _notifyDateChanged();
        },
      );
    }
  }

  Widget _buildDayField() {
    if (widget.enableDropdown) {
      return _buildDropdownField(
        value: _selectedDay,
        hint: 'Day',
        items: List.generate(31, (i) => i + 1),
        onChanged: (value) {
          setState(() {
            _selectedDay = value;
            _dayController.text = value.toString();
          });
          _notifyDateChanged();
        },
      );
    } else {
      return _buildTextField(
        controller: _dayController,
        focusNode: _dayFocus,
        nextFocus: _yearFocus,
        previousFocus: _monthFocus,
        hint: 'Day',
        maxLength: 2,
        onChanged: (value) {
          if (value.length == 2) {
            _yearFocus.requestFocus();
          }
          _notifyDateChanged();
        },
      );
    }
  }

  Widget _buildYearField() {
    return _buildTextField(
      controller: _yearController,
      focusNode: _yearFocus,
      previousFocus: _dayFocus,
      hint: 'Year',
      maxLength: 4,
      onChanged: (value) {
        _notifyDateChanged();
      },
    );
  }

  Widget _buildDropdownField({
    required int? value,
    required String hint,
    required List<int> items,
    required Function(int?) onChanged,
  }) {
    return DropdownButtonFormField<int>(
      value: value,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: Colors.grey[400],
          fontSize: 14,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.blue, width: 2),
        ),
      ),
      items: items.map((int value) {
        return DropdownMenuItem<int>(
          value: value,
          child: Text(
            value.toString().padLeft(2, '0'),
            style: const TextStyle(fontSize: 14),
          ),
        );
      }).toList(),
      onChanged: onChanged,
      icon: Icon(Icons.arrow_drop_down, color: Colors.grey[600]),
      isExpanded: true,
      menuMaxHeight: 300,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              widget.label!,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),
        Row(
          children: _buildFieldsInOrder(),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required FocusNode focusNode,
    FocusNode? nextFocus,
    FocusNode? previousFocus,
    required String hint,
    required int maxLength,
    required Function(String) onChanged,
  }) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: TextInputType.number,
      textAlign: TextAlign.center,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(maxLength),
      ],
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: Colors.grey[400],
          fontSize: 14,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.blue, width: 2),
        ),
      ),
      onSubmitted: (value) {
        if (nextFocus != null) {
          nextFocus.requestFocus();
        }
      },
    );
  }
}