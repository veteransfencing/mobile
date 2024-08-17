import 'package:evf/assets/evf_icons.dart';
import 'package:evf/styles.dart';
import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Icon(
          EVF.evfLogo,
          size: 50,
          color: AppStyles.stripes,
        ),
        const SizedBox(width: 10),
        Container(
          width: 260,
          height: 50,
          transform: Matrix4.translationValues(60.0, 8.0, 0.0),
          //clipBehavior: Clip.hardEdge,
          child: Stack(
            children: [
              Transform.translate(
                offset: const Offset(0.0, -12.0),
                child: const Text.rich(TextSpan(text: "European"), style: AppStyles.logoStyle),
              ),
              Transform.translate(
                offset: const Offset(0.0, 12.0),
                child: const Text.rich(TextSpan(text: "Veterans Fencing"), style: AppStyles.logoStyle),
              )
            ],
          ),
        ),
      ],
    );
  }
}
