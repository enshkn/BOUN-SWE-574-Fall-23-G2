import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:swe/_core/extensions/string_extensions.dart';

import '../../_core/widgets/base_widgets.dart';

class AppSearchBar extends StatefulWidget {
  final void Function(TextEditingController)? onSearchControllerReady;
  final String? hintText;
  final void Function(String?)? onChanged;
  final VoidCallback? onPressedFilter;
  final String? searchTerm;
  const AppSearchBar({
    super.key,
    this.onSearchControllerReady,
    this.hintText,
    this.onChanged,
    this.onPressedFilter,
    this.searchTerm,
  });

  @override
  State<AppSearchBar> createState() => _AppSearchBarState();
}

class _AppSearchBarState extends State<AppSearchBar> {
  late TextEditingController _searchController;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchController.text = widget.searchTerm ?? '';
    widget.onSearchControllerReady?.call(_searchController);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              prefixIcon: SvgPicture.asset(
                'search'.toSvg,
              ),
              isDense: false,
              fillColor: Colors.white,
              filled: true,
              border: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.all(
                  Radius.circular(12),
                ),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.all(
                  Radius.circular(12),
                ),
              ),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.all(
                  Radius.circular(12),
                ),
              ),
              hintText: widget.hintText,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              suffixIcon: _searchController.text.isNotEmpty
                  ? GestureDetector(
                      onTap: () {
                        _focusNode.unfocus();
                        _searchController.clear();
                        widget.onChanged?.call('');
                      },
                      child: const Icon(
                        Icons.close,
                        size: 20,
                      ),
                    )
                  : null,
            ),
            onChanged: widget.onChanged,
          ),
        ),
        if (widget.onPressedFilter != null) BaseWidgets.lowerDistance,
        if (widget.onPressedFilter != null)
          GestureDetector(
            onTap: widget.onPressedFilter,
            child: Container(
              width: 35,
              height: 35,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: const Center(
                child: Icon(
                  Icons.filter_list,
                  size: 22,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
