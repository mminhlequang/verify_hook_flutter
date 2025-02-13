import 'package:app/src/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:internal_core/internal_core.dart';
import 'package:wrapfit/wrapfit.dart';

class WidgetTagTextField extends StatefulWidget {
  const WidgetTagTextField({
    super.key,
    required this.hintText,
    required this.tags,
    required this.onSubmitted,
    required this.onRemove,
    this.onChanged,
  });

  final String hintText;
  final List<String> tags;
  final Function(String value) onSubmitted;
  final Function(int index) onRemove;
  final Function(String value)? onChanged;

  @override
  State<WidgetTagTextField> createState() => _WidgetTagTextFieldState();
}

class _WidgetTagTextFieldState extends State<WidgetTagTextField> {
  final TextEditingController controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: hexColor('#E6E6E6')),
      ),
      child: Wrap2(
        alignment: WrapAlignment.start,
        crossAxisAlignment: WrapCrossAlignment.start,
        spacing: 8.sw,
        runSpacing: 8.sw,
        children: [
          ...List.generate(
            widget.tags.length,
            (index) => Container(
              padding: EdgeInsets.fromLTRB(8.sw, 3.sw, 6.sw, 3.sw),
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(4.sw),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.tags[index],
                    style: w400TextStyle(fontSize: 14.sw, color: Colors.black),
                  ),
                  Gap(6.sw),
                  GestureDetector(
                    onTap: () {
                      appHaptic();
                      widget.onRemove.call(index);
                    },
                    child: Icon(Icons.clear, size: 20.sw, color: Colors.red),
                  ),
                ],
              ),
            ),
          ),
          Wrapped(
            fit: WrapFit.runLoose,
            child: TextFormField(
              controller: controller,
              style: w400TextStyle(fontSize: 16.sw),
              minLines: 5,
              maxLines: 7,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                isDense: true,
                isCollapsed: true,
                filled: true,
                fillColor: Colors.white,
                contentPadding: EdgeInsets.zero,
                hintText: widget.hintText,
                hintStyle: w400TextStyle(fontSize: 16.sw, color: hexColor('#E0E0E0')),
                border: const OutlineInputBorder(borderSide: BorderSide.none),
                hoverColor: Colors.transparent,
              ),
              cursorColor: const Color(0xFF1E1C58),
              onChanged: (value) => widget.onChanged?.call(value),
              onFieldSubmitted: (value) {
                widget.onSubmitted.call(value.trim());
                controller.clear();
              },
            ),
          ),
        ],
      ),
    );
  }
}
