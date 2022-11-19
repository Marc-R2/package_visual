import 'package:flutter/material.dart';

import 'package:package_visual/openMenu/open_menu_item.dart';

/// A widget that displays a OpenMenu
///
/// A OpenMenu allways shows a leading widget and can reveal a hidden widget
class OpenMenu extends StatefulWidget {
  /// Create a new OpenMenu instance
  const OpenMenu({
    super.key,
    required this.items,
    required this.showMenu,
    this.menuWidth = 256,
  });

  /// The items to display
  final List<OpenMenuItem> items;

  /// Whether the hidden widgets should be shown
  final bool showMenu;

  /// The width of the hidden widgets area
  final double menuWidth;

  @override
  State<OpenMenu> createState() => _OpenMenuState();
}

class _OpenMenuState extends State<OpenMenu> {
  bool hoverShow = false;

  bool get show => widget.showMenu || hoverShow;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (value) => setState(() => hoverShow = true),
      onExit: (value) => setState(() => hoverShow = false),
      child: Padding(
        padding: const EdgeInsets.only(top: 16),
        child: Row(
          children: [
            const SizedBox(width: 16),
            Column(
              children: [
                const SizedBox(width: 16),
                for (final item in widget.items)
                  SizedBox(
                    height: item.height,
                    child: item.leading,
                  ),
              ],
            ),
            const SizedBox(width: 16),
            AnimatedContainer(
              duration: const Duration(milliseconds: 256),
              curve: Curves.easeInOut,
              width: show ? widget.menuWidth : 0,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const NeverScrollableScrollPhysics(),
                child: SizedBox(
                  width: widget.menuWidth,
                  child: Column(
                    children: [
                      const SizedBox(width: 16),
                      for (final item in widget.items)
                        InkWell(
                          onTap: item.onTap,
                          child: SizedBox(
                            height: item.height,
                            child: item.editable,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
