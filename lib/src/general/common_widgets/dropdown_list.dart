import 'package:cool_dropdown/cool_dropdown.dart';
import 'package:cool_dropdown/models/cool_dropdown_item.dart';
import 'package:flutter/material.dart';

class DropdownList extends StatelessWidget {
  const DropdownList({
    Key? key,
    required this.dropdownController,
    required this.itemsList,
    this.placeholder,
    required this.onChanged(String value),
  }) : super(key: key);
  final DropdownController dropdownController;
  final List<CoolDropdownItem<String>> itemsList;
  final Function onChanged;
  final String? placeholder;
  @override
  Widget build(BuildContext context) {
    return CoolDropdown<String>(
      controller: dropdownController,
      dropdownList: itemsList,
      defaultItem: placeholder != null ? null : itemsList[0],
      onChange: (value) async {
        if (dropdownController.isError) {
          await dropdownController.resetError();
        }
        dropdownController.close();
        onChanged(value);
      },
      onOpen: (value) {},
      resultOptions: ResultOptions(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        width: double.infinity,
        icon: const SizedBox(
          width: 10,
          height: 10,
          child: CustomPaint(
            painter: DropdownArrowPainter(),
          ),
        ),
        render: ResultRender.all,
        placeholder: placeholder,
        isMarquee: true,
      ),
      dropdownOptions: const DropdownOptions(
          top: 20,
          height: 400,
          gap: DropdownGap.all(10),
          borderSide: BorderSide(width: 1, color: Colors.black),
          padding: EdgeInsets.symmetric(horizontal: 10),
          align: DropdownAlign.left,
          animationType: DropdownAnimationType.size),
      dropdownTriangleOptions: const DropdownTriangleOptions(
        width: 20,
        height: 30,
        align: DropdownTriangleAlign.left,
        borderRadius: 0,
        left: 20,
      ),
      dropdownItemOptions: const DropdownItemOptions(
        isMarquee: true,
        mainAxisAlignment: MainAxisAlignment.start,
        render: DropdownItemRender.all,
        height: 50,
      ),
    );
  }
}
