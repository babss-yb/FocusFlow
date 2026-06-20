import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class VxSettingsRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? value;

  const VxSettingsRow({
    super.key,
    required this.icon,
    required this.title,
    this.value,
  });

  @override
  Widget build(BuildContext context) {
    return HStack([
      Icon(icon, color: Vx.slate500),
      16.widthBox,
      VStack([
        if (value != null) title.text.slate400.sm.make() else const SizedBox.shrink(),
        if (value != null) 4.heightBox else const SizedBox.shrink(),
        (value ?? title).text.slate800.semiBold.make(),
      ]).expand(),
      Icon(value != null ? Icons.edit : Icons.chevron_right, color: Vx.slate400, size: 20),
    ]).py12();
  }
}
