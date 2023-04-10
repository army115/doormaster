import 'package:doormster/components/button/button.dart';
import 'package:flutter/material.dart';
import 'package:animated_custom_dropdown/custom_dropdown.dart';

class DropdownSearchWidget extends StatefulWidget {
  const DropdownSearchWidget({
    Key? key,
  }) : super(key: key);

  @override
  _DropdownSearchWidgetState createState() => _DropdownSearchWidgetState();
}

class _DropdownSearchWidgetState extends State<DropdownSearchWidget> {
  final _formkey = GlobalKey<FormState>();
  TextEditingController _searchController = TextEditingController();
  List<String> _items = [
    'Item 1',
    'Item 2',
    'Item 3',
    'Item 4',
    'Item 1',
    'Item 2',
    'Item 3',
    'Item 4',
    'Item 1',
    'Item 2',
    'Item 3',
    'Item 4',
    'Item 1',
    'Item 2',
    'Item 3',
    'Item 4',
    'Item 1',
    'Item 2',
    'Item 3',
    'Item 4',
    'Item 1',
    'Item 2',
    'Item 3',
    'Item 4',
    'Item 1',
    'Item 2',
    'Item 3',
    'Item 4',
    'Item 1',
    'Item 2',
    'Item 3',
    'Item 4',
    'Item 1',
    'Item 2',
    'Item 3',
    'Item 4',
    'Item 1',
    'Item 2',
    'Item 3',
    'Item 4'
  ];
  List<String> _filteredItems = [];
  String? _selectedItem;

  @override
  void initState() {
    super.initState();
    _filteredItems = _items;
  }

  bool _isDropdownOpen = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Form(
        key: _formkey,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // CustomDropdown.search(
              //   borderRadius: BorderRadius.zero,
              //   errorText: 'error',
              //   hintText: 'Select job role',
              //   items: const ['Developer', 'Designer', 'Consultant', 'Student'],
              //   controller: _searchController,
              // ),
              Buttons(
                  title: 'บันทึก',
                  press: () {
                    if (_formkey.currentState!.validate()) {}
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
