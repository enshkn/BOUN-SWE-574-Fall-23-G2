// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class DropDownMenu extends StatefulWidget {
  final List<String> list;
  final String hintText;
  String selectedItem;

  DropDownMenu({
    required this.list,
    required this.hintText,
    required this.selectedItem,
    super.key,
  });

  @override
  State<DropDownMenu> createState() => _DropDownState();
}

class _DropDownState extends State<DropDownMenu> {
  @override
  Widget build(BuildContext context) {
    return DropdownMenu<String>(
      hintText: widget.hintText,
      width: MediaQuery.of(context).size.width * 0.92,
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.blue),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.blue),
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.blue),
          borderRadius: BorderRadius.circular(12),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red.shade900),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      menuStyle: MenuStyle(
        side: MaterialStateProperty.all(
          const BorderSide(
            color: Colors.blue,
          ),
        ),
      ),
      onSelected: (String? value) {
        setState(() {
          value = value!;
          widget.selectedItem = value!;
        });
      },
      dropdownMenuEntries:
          widget.list.map<DropdownMenuEntry<String>>((String value) {
        return DropdownMenuEntry<String>(
          value: value,
          label: value,
        );
      }).toList(),
    );
  }
}
