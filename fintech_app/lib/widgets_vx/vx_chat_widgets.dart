import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class VxChatBubble extends StatelessWidget {
  final String text;
  final bool isBot;

  const VxChatBubble({
    super.key,
    required this.text,
    this.isBot = true,
  });

  @override
  Widget build(BuildContext context) {
    if (isBot) {
      return HStack([
        VxBox(child: const Icon(Icons.smart_toy, color: Vx.white, size: 16))
            .emerald500.roundedFull.size(32, 32).make(),
        12.widthBox,
        VxBox(child: text.text.slate800.make().p16())
            .white.roundedLg.shadowXs.make().expand(),
      ], crossAlignment: CrossAxisAlignment.start).pOnly(bottom: 24, right: 32);
    } else {
      return HStack([
        VxBox(child: text.text.white.make().p16())
            .emerald500.roundedLg.shadowXs.make().expand(),
      ], crossAlignment: CrossAxisAlignment.start).pOnly(bottom: 24, left: 48);
    }
  }
}

class VxChatPill extends StatelessWidget {
  final String text;

  const VxChatPill({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return VxBox(child: text.text.sm.emerald700.make().pSymmetric(h: 16, v: 8))
        .emerald50.roundedFull.border(color: Vx.emerald200)
        .margin(const EdgeInsets.only(right: 8)).make();
  }
}
