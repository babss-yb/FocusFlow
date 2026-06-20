import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class VxTransactionItem extends StatelessWidget {
  final String title;
  final String amount;
  final bool isIncome;
  final String subtitle;

  const VxTransactionItem({
    super.key,
    required this.title,
    required this.amount,
    required this.isIncome,
    this.subtitle = "Aujourd'hui",
  });

  @override
  Widget build(BuildContext context) {
    return VxBox(
      child: HStack([
        VxBox(
          child: Icon(
            isIncome ? Icons.arrow_downward : Icons.arrow_upward,
            color: isIncome ? Vx.emerald500 : Vx.red500,
            size: 20,
          ),
        )
        .size(40, 40)
        .color(isIncome ? Vx.emerald100 : Vx.red100)
        .roundedFull
        .make(),
        
        16.widthBox,
        
        VStack([
          title.text.slate800.semiBold.ellipsis.make(),
          subtitle.text.slate500.sm.make(),
        ]).expand(),
        
        amount.text.bold
            .color(isIncome ? Vx.emerald600 : Vx.slate800)
            .make(),
      ]).p16(),
    )
    .white.rounded.shadowXs.margin(const EdgeInsets.only(bottom: 12)).make();
  }
}
