import 'package:flutter/material.dart' ;
import 'package:dropdown_button2/dropdown_button2.dart';
import 'ios_modal_dropdown.dart';

class IosModalDropdownExample extends StatefulWidget {
  const IosModalDropdownExample({super.key});

  @override
  State<IosModalDropdownExample> createState() => _IosModalDropdownExampleState();
}

class _IosModalDropdownExampleState extends State<IosModalDropdownExample> {
  String? selectedValue;
  
  final List<String> items = [
    'Option 1',
    'Option 2', 
    'Option 3',
    'Option 4',
    'Option 5',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('iOS Modal Dropdown Example'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Basic Example:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            IosModalDropdown<String>(
              items: items.map((String item) {
                return DropdownMenuItem <String>(
                  value: item,
                  child: Text(item),
                );
              }).toList(),
              value: selectedValue,
              hint: const Text('Select an option'),
              modalTitle: 'Choose Option',
              onChanged: (String? newValue) {
                setState(() {
                  selectedValue = newValue;
                });
              },
              isExpanded: true,
              buttonStyleData: const  ButtonStyleData(
                height: 50,
                decoration: BoxDecoration(
                  border: Border.fromBorderSide(
                    BorderSide(color: Colors.grey),
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
              ),
            ),
            const SizedBox(height: 32),
            if (selectedValue != null) ...[
              Text(
                'Selected: $selectedValue',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    selectedValue = null;
                  });
                },
                child: const Text('Clear Selection'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}