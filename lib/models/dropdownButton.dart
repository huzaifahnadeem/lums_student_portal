import 'package:flutter/material.dart';

DropdownButton dropDownButtonCustom = DropdownButton(
  hint: Text("Update"),
  isExpanded: false,
  value: "Update",
  focusColor: Colors.red,
  dropdownColor: Colors.red,
  items: ["bleh"].map((categoryItem) {
    return DropdownMenuItem(
      value: categoryItem ,
      child: Text(categoryItem),
    );
  }).toList(),
) ;