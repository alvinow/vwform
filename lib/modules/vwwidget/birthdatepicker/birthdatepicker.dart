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
  final DateTime? minDate;
  final DateTime? maxDate;

  const BirthdatePicker({
    Key? key,
    this.onDateChanged,
    this.initialDate,
    this.label,
    this.dateOrder = DateOrder.mdy,
    this.enableDropdown = true,
    this.minDate,
    this.maxDate,
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
  int? _selectedYear;

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
    _selectedYear = widget.initialDate?.year;
  }

  // Helper function to check if a year is a leap year
  bool _isLeapYear(int year) {
    if (year % 4 != 0) return false;
    if (year % 100 != 0) return true;
    if (year % 400 != 0) return false;
    return true;
  }

  // Helper function to get days in a month
  int _getDaysInMonth(int year, int month) {
    if (month == 2) {
      return _isLeapYear(year) ? 29 : 28;
    }
    if (month == 4 || month == 6 || month == 9 || month == 11) {
      return 30;
    }
    return 31;
  }

  // Get available days based on selected year and month
  List<int> _getAvailableDays() {
    if (widget.dateOrder == DateOrder.ymd) {
      // For YMD format, calculate days based on selected year and month
      if (_selectedYear != null && _selectedMonth != null) {
        final daysInMonth = _getDaysInMonth(_selectedYear!, _selectedMonth!);
        return _filterDaysByDateRange(daysInMonth, _selectedYear!, _selectedMonth!);
      }
      // If year or month not selected yet, show all 31 days
      return List.generate(31, (i) => i + 1);
    }
    // For other formats, always show 31 days
    return List.generate(31, (i) => i + 1);
  }

  // Filter days based on minDate and maxDate
  List<int> _filterDaysByDateRange(int daysInMonth, int year, int month) {
    final days = <int>[];

    for (int day = 1; day <= daysInMonth; day++) {
      final currentDate = DateTime(year, month, day);

      bool isValid = true;

      if (widget.minDate != null) {
        final minCompare = DateTime(widget.minDate!.year, widget.minDate!.month, widget.minDate!.day);
        if (currentDate.isBefore(minCompare)) {
          isValid = false;
        }
      }

      if (widget.maxDate != null) {
        final maxCompare = DateTime(widget.maxDate!.year, widget.maxDate!.month, widget.maxDate!.day);
        if (currentDate.isAfter(maxCompare)) {
          isValid = false;
        }
      }

      if (isValid) {
        days.add(day);
      }
    }

    return days;
  }

  // Get available months based on selected year
  List<int> _getAvailableMonths() {
    if (_selectedYear == null) {
      return List.generate(12, (i) => i + 1);
    }

    final months = <int>[];

    for (int month = 1; month <= 12; month++) {
      bool isValid = true;

      if (widget.minDate != null) {
        final minYear = widget.minDate!.year;
        final minMonth = widget.minDate!.month;

        if (_selectedYear! < minYear || (_selectedYear! == minYear && month < minMonth)) {
          isValid = false;
        }
      }

      if (widget.maxDate != null) {
        final maxYear = widget.maxDate!.year;
        final maxMonth = widget.maxDate!.month;

        if (_selectedYear! > maxYear || (_selectedYear! == maxYear && month > maxMonth)) {
          isValid = false;
        }
      }

      if (isValid) {
        months.add(month);
      }
    }

    return months;
  }

  // Get available years
  List<int> _getAvailableYears() {
    final currentYear = DateTime.now().year;
    int startYear = widget.minDate?.year ?? 1900;
    int endYear = widget.maxDate?.year ?? currentYear + 1;

    final years = <int>[];
    for (int year = startYear; year <= endYear; year++) {
      years.add(year);
    }

    return years.reversed.toList();
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
          // Preserve UTC/Local timezone and time from initialDate
          DateTime date;
          if (widget.initialDate != null) {
            final initial = widget.initialDate!;
            if (initial.isUtc) {
              date = DateTime.utc(
                year,
                month,
                day,
                initial.hour,
                initial.minute,
                initial.second,
                initial.millisecond,
                initial.microsecond,
              );
            } else {
              date = DateTime(
                year,
                month,
                day,
                initial.hour,
                initial.minute,
                initial.second,
                initial.millisecond,
                initial.microsecond,
              );
            }
          } else {
            // If no initialDate, use local timezone with midnight time
            date = DateTime(year, month, day);
          }

          // Validate against date range
          bool isValid = true;

          if (widget.minDate != null) {
            final minCompare = DateTime(widget.minDate!.year, widget.minDate!.month, widget.minDate!.day);
            final dateCompare = DateTime(date.year, date.month, date.day);
            if (dateCompare.isBefore(minCompare)) {
              isValid = false;
            }
          }

          if (widget.maxDate != null) {
            final maxCompare = DateTime(widget.maxDate!.year, widget.maxDate!.month, widget.maxDate!.day);
            final dateCompare = DateTime(date.year, date.month, date.day);
            if (dateCompare.isAfter(maxCompare)) {
              isValid = false;
            }
          }

          widget.onDateChanged?.call(isValid ? date : null);
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
      // For YMD format, disable month field until year is selected
      final isDisabled = widget.dateOrder == DateOrder.ymd && _selectedYear == null;

      return _buildDropdownField(
        value: isDisabled ? null : _selectedMonth,
        hint: 'Month',
        items: _getAvailableMonths(),
        isEnabled: !isDisabled,
        onChanged: (value) {
          setState(() {
            _selectedMonth = value;
            _monthController.text = value?.toString() ?? '';

            // For YMD format, validate and adjust day if needed
            if (widget.dateOrder == DateOrder.ymd && _selectedYear != null && _selectedDay != null && value != null) {
              final availableDays = _getAvailableDays();
              if (!availableDays.contains(_selectedDay)) {
                _selectedDay = availableDays.isNotEmpty ? availableDays.first : null;
                _dayController.text = _selectedDay?.toString() ?? '';
              }
            }
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
        isEnabled: widget.dateOrder != DateOrder.ymd || _selectedYear != null,
        onChanged: (value) {
          if (value.length == 2) {
            final month = int.tryParse(value);
            if (month != null) {
              final availableMonths = _getAvailableMonths();
              if (!availableMonths.contains(month)) {
                _monthController.clear();
                return;
              }
            }
            _dayFocus.requestFocus();
          }
          _notifyDateChanged();
        },
      );
    }
  }

  Widget _buildDayField() {
    if (widget.enableDropdown) {
      // For YMD format, disable day field until year and month are selected
      final isDisabled = widget.dateOrder == DateOrder.ymd &&
          (_selectedYear == null || _selectedMonth == null);

      return _buildDropdownField(
        value: isDisabled ? null : _selectedDay,
        hint: 'Day',
        items: _getAvailableDays(),
        isEnabled: !isDisabled,
        onChanged: (value) {
          setState(() {
            _selectedDay = value;
            _dayController.text = value?.toString() ?? '';
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
        isEnabled: widget.dateOrder != DateOrder.ymd ||
            (_selectedYear != null && _selectedMonth != null),
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
    if (widget.enableDropdown) {
      // Generate years based on date range
      final years = _getAvailableYears();

      return _buildDropdownField(
        value: _selectedYear,
        hint: 'Year',
        items: years,
        isEnabled: true,
        onChanged: (value) {
          setState(() {
            _selectedYear = value;
            _yearController.text = value.toString();

            // For YMD format, validate and adjust month and day if needed
            if (widget.dateOrder == DateOrder.ymd) {
              // Check if current month is still valid
              if (_selectedMonth != null) {
                final availableMonths = _getAvailableMonths();
                if (!availableMonths.contains(_selectedMonth)) {
                  _selectedMonth = availableMonths.isNotEmpty ? availableMonths.first : null;
                  _monthController.text = _selectedMonth?.toString() ?? '';
                }
              }

              // Check if current day is still valid
              if (_selectedMonth != null && _selectedDay != null) {
                final availableDays = _getAvailableDays();
                if (!availableDays.contains(_selectedDay)) {
                  _selectedDay = availableDays.isNotEmpty ? availableDays.first : null;
                  _dayController.text = _selectedDay?.toString() ?? '';
                }
              }
            }
          });
          _notifyDateChanged();
        },
      );
    } else {
      return _buildTextField(
        controller: _yearController,
        focusNode: _yearFocus,
        previousFocus: _dayFocus,
        hint: 'Year',
        maxLength: 4,
        isEnabled: true,
        onChanged: (value) {
          // For YMD format with text input
          if (widget.dateOrder == DateOrder.ymd && value.length == 4) {
            try {
              final year = int.parse(value);
              final availableYears = _getAvailableYears();

              if (!availableYears.contains(year)) {
                _yearController.clear();
                _selectedYear = null;
                return;
              }

              _selectedYear = year;
              setState(() {
                // Validate month when year is fully entered
                if (_selectedMonth != null) {
                  final availableMonths = _getAvailableMonths();
                  if (!availableMonths.contains(_selectedMonth)) {
                    _selectedMonth = null;
                    _monthController.clear();
                  }
                }

                // Validate day when year is fully entered
                if (_selectedMonth != null && _selectedDay != null) {
                  final availableDays = _getAvailableDays();
                  if (!availableDays.contains(_selectedDay)) {
                    _selectedDay = availableDays.isNotEmpty ? availableDays.first : null;
                    _dayController.text = _selectedDay?.toString() ?? '';
                  }
                }
              });
            } catch (e) {
              _selectedYear = null;
            }
          }
          _notifyDateChanged();
        },
      );
    }
  }

  Widget _buildDropdownField({
    required int? value,
    required String hint,
    required List<int> items,
    required bool isEnabled,
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
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[200]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.blue, width: 2),
        ),
        filled: !isEnabled,
        fillColor: !isEnabled ? Colors.grey[100] : null,
      ),
      items: items.map((int value) {
        return DropdownMenuItem<int>(
          value: value,
          child: Text(
            value.toString().padLeft(hint == 'Year' ? 4 : 2, '0'),
            style: const TextStyle(fontSize: 14),
          ),
        );
      }).toList(),
      onChanged: isEnabled ? onChanged : null,
      icon: Icon(Icons.arrow_drop_down, color: isEnabled ? Colors.grey[600] : Colors.grey[400]),
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
    required bool isEnabled,
    required Function(String) onChanged,
  }) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      enabled: isEnabled,
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
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[200]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.blue, width: 2),
        ),
        filled: !isEnabled,
        fillColor: !isEnabled ? Colors.grey[100] : null,
      ),
      onSubmitted: (value) {
        if (nextFocus != null) {
          nextFocus.requestFocus();
        }
      },
    );
  }
}