import 'package:dropdown_button2/dropdown_button2.dart' hide MenuItemStyleData;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

typedef OnChangedCallback<T> = void Function(T? value);
/*
class ButtonStyleData {
  const ButtonStyleData({
    this.height,
    this.width,
    this.padding,
    this.decoration,
    this.elevation,
  });

  final double? height;
  final double? width;
  final EdgeInsetsGeometry? padding;
  final BoxDecoration? decoration;
  final double? elevation;
}

class DropdownStyleData {
  const DropdownStyleData({
    this.maxHeight,
    this.width,
    this.padding,
    this.scrollPadding,
    this.decoration,
    this.elevation,
    this.direction = DropdownDirection.textDirection,
    this.offset = Offset.zero,
    this.isOverButton = false,
    this.useSafeArea = true,
    this.useRootNavigator = false,
    this.scrollbarTheme,
    this.openInterval,
  });

  final double? maxHeight;
  final double? width;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? scrollPadding;
  final BoxDecoration? decoration;
  final double? elevation;
  final DropdownDirection direction;
  final Offset offset;
  final bool isOverButton;
  final bool useSafeArea;
  final bool useRootNavigator;
  final ScrollbarThemeData? scrollbarTheme;
  final Interval? openInterval;
}
*/
class MenuItemStyleDataIos {
  const MenuItemStyleDataIos({
    this.height,
    this.padding,
    this.overlayColor,
    this.textStyle,
    this.customHeights,
  });

  final double? height;
  final EdgeInsetsGeometry? padding;
  final WidgetStateProperty<Color?>? overlayColor;
  final TextStyle? textStyle;
  final List<double>? customHeights;
}
/*
class IconStyleData {
  const IconStyleData({
    this.icon,
    this.iconDisabledColor,
    this.iconEnabledColor,
    this.iconSize,
    this.openMenuIcon,
  });

  final Widget? icon;
  final Color? iconDisabledColor;
  final Color? iconEnabledColor;
  final double? iconSize;
  final Widget? openMenuIcon;
}

enum DropdownDirection {
  textDirection,
  right,
  left,
}

 */
/*
class DropdownMenuItem<T> extends StatelessWidget {
  const DropdownMenuItem({
    super.key,
    this.onTap,
    this.value,
    this.enabled = true,
    this.alignment = AlignmentDirectional.centerStart,
    required this.child,
  });

  final VoidCallback? onTap;
  final T? value;
  final bool enabled;
  final AlignmentGeometry alignment;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: alignment,
      child: child,
    );
  }
}*/

class IosModalDropdown<T> extends StatefulWidget {
  const IosModalDropdown({
    super.key,
    required this.items,
    this.selectedItemBuilder,
    this.value,
    this.hint,
    this.disabledHint,
    this.onChanged,
    this.onTap,
    this.elevation = 8,
    this.style,
    this.underline,
    this.icon,
    this.iconDisabledColor,
    this.iconEnabledColor,
    this.iconSize = 24.0,
    this.isDense = false,
    this.isExpanded = false,
    this.itemHeight,
    this.focusColor,
    this.focusNode,
    this.autofocus = false,
    this.dropdownColor,
    this.menuMaxHeight,
    this.enableFeedback,
    this.alignment = AlignmentDirectional.centerStart,
    this.borderRadius,
    this.padding,
    this.buttonStyleData,
    this.iconStyleData,
    this.dropdownStyleData,
    this.menuItemStyleData,
    this.modalTitle,
    this.modalBackgroundColor,
    this.modalBarrierColor,
    this.useRootNavigator = false,
    this.useSafeArea = true,
  });

  final List<DropdownMenuItem<T>>? items;
  final DropdownButtonBuilder? selectedItemBuilder;
  final T? value;
  final Widget? hint;
  final Widget? disabledHint;
  final OnChangedCallback<T>? onChanged;
  final VoidCallback? onTap;
  final int elevation;
  final TextStyle? style;
  final Widget? underline;
  final Widget? icon;
  final Color? iconDisabledColor;
  final Color? iconEnabledColor;
  final double iconSize;
  final bool isDense;
  final bool isExpanded;
  final double? itemHeight;
  final Color? focusColor;
  final FocusNode? focusNode;
  final bool autofocus;
  final Color? dropdownColor;
  final double? menuMaxHeight;
  final bool? enableFeedback;
  final AlignmentGeometry alignment;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? padding;
  final ButtonStyleData? buttonStyleData;
  final IconStyleData? iconStyleData;
  final DropdownStyleData? dropdownStyleData;
  final MenuItemStyleDataIos? menuItemStyleData;
  final String? modalTitle;
  final Color? modalBackgroundColor;
  final Color? modalBarrierColor;
  final bool useRootNavigator;
  final bool useSafeArea;

  @override
  State<IosModalDropdown<T>> createState() => _IosModalDropdownState<T>();
}

class _IosModalDropdownState<T> extends State<IosModalDropdown<T>> {
  T? _selectedValue;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.value;
  }

  @override
  void didUpdateWidget(IosModalDropdown<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      _selectedValue = widget.value;
    }
  }

  void _showModalBottomSheet() {
    if (widget.onTap != null) {
      widget.onTap!();
    }

    showModalBottomSheet<T>(
      context: context,
      backgroundColor: widget.modalBackgroundColor ?? Colors.transparent,
      barrierColor: widget.modalBarrierColor,
      useRootNavigator: widget.useRootNavigator,
      useSafeArea: widget.useSafeArea,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return _buildModalContent();
      },
    );
  }

  Widget _buildModalContent() {
    final maxHeight = widget.dropdownStyleData?.maxHeight ?? 
                     widget.menuMaxHeight ?? 
                     MediaQuery.of(context).size.height * 0.6;

    return Container(
      decoration: BoxDecoration(
        color: widget.dropdownColor ?? Theme.of(context).canvasColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.modalTitle != null) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Theme.of(context).dividerColor,
                    width: 0.5,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.modalTitle!,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: const Icon(
                      CupertinoIcons.xmark_circle_fill,
                      color: Colors.grey,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),
          ],
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: maxHeight,
            ),
            child: ListView.builder(
              shrinkWrap: true,
              padding: widget.dropdownStyleData?.padding ?? EdgeInsets.zero,
              itemCount: widget.items?.length ?? 0,
              itemBuilder: (context, index) {
                final item = widget.items![index];
                final isSelected = item.value == _selectedValue;



                return InkWell(
                  onTap: item.enabled
                      ? () {
                          Navigator.of(context).pop();
                          if (widget.onChanged != null) {
                            widget.onChanged!(item.value);
                          }
                          setState(() {
                            _selectedValue = item.value;
                          });
                          if (item.onTap != null) {
                            item.onTap!();
                          }
                        }
                      : null,
                  child: Container(
                    height: widget.menuItemStyleData?.height ?? 
                            widget.itemHeight ?? 
                            48.0,
                    padding: widget.menuItemStyleData?.padding ?? 
                            const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: isSelected 
                          ? Theme.of(context).primaryColor.withValues(alpha: 0.1)
                          : null,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: DefaultTextStyle(
                            style: widget.menuItemStyleData?.textStyle ??
                                   widget.style ??
                                   Theme.of(context).textTheme.bodyMedium!,
                            child: item.child,
                          ),
                        ),
                        if (isSelected)
                          Icon(
                            CupertinoIcons.check_mark,
                            color: Theme.of(context).primaryColor,
                            size: 20,
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            height: MediaQuery.of(context).padding.bottom,
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedItem() {
    if (_selectedValue == null) {
      return widget.hint ?? 
             widget.disabledHint ?? 
             const Text('Select an option');
    }

    if (widget.selectedItemBuilder != null) {
      final selectedItems = widget.selectedItemBuilder!(context);
      final selectedIndex = widget.items?.indexWhere(
        (item) => item.value == _selectedValue,
      ) ?? -1;
      
      if (selectedIndex >= 0 && selectedIndex < selectedItems.length) {
        return selectedItems[selectedIndex];
      }
    }

    final selectedItem = widget.items?.firstWhere(
      (item) => item.value == _selectedValue,
      orElse: () => widget.items!.first,
    );

    return selectedItem?.child ?? const Text('');
  }

  Widget _buildIcon() {
    final iconStyleData = widget.iconStyleData;
    final icon = iconStyleData?.icon ?? 
                 widget.icon ?? 
                 const Icon(Icons.arrow_drop_down);

    return icon;
  }

  @override
  Widget build(BuildContext context) {
    final isEnabled = widget.onChanged != null;
    final buttonStyleData = widget.buttonStyleData;

    return GestureDetector(
      onTap: isEnabled ? _showModalBottomSheet : null,
      child: Container(
        height: buttonStyleData?.height ?? (widget.isDense ? 40.0 : 48.0),
        width: buttonStyleData?.width,
        padding: buttonStyleData?.padding ?? 
                 widget.padding ?? 
                 const EdgeInsets.symmetric(horizontal: 12),
        decoration: buttonStyleData?.decoration ?? 
                   BoxDecoration(
                     border: Border.all(color: Colors.grey),
                     borderRadius: widget.borderRadius ?? BorderRadius.circular(4),
                   ),
        child: Row(
          children: [
            if (widget.isExpanded)
              Expanded(
                child: _buildSelectedItem(),
              )
            else
              _buildSelectedItem(),
            const SizedBox(width: 8),
            _buildIcon(),
          ],
        ),
      ),
    );
  }
}

typedef DropdownButtonBuilder = List<Widget> Function(BuildContext context);