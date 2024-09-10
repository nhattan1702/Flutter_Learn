import 'package:flutter/material.dart';
import 'package:slidable_button/slidable_button.dart';

import '../common/color.dart';

class SliderButton extends StatelessWidget {
  SliderButton({required this.title, required this.routeName});

  final String routeName;
  final String title;

  @override
  Widget build(BuildContext context) {
    return HorizontalSlidableButton(
      initialPosition: SlidableButtonPosition.start,
      height: 60,
      width: MediaQuery.of(context).size.width / 3,
      buttonWidth: 100.0,
      color: Theme.of(context).colorScheme.secondary.withOpacity(0.5),
      buttonColor: AppColors.matchaLight,
      dismissible: false,
      label: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: AppColors.matchaLight,
        ),
        child: Text(title),
      ),
      onChanged: (position) {
        if (position == SlidableButtonPosition.end) {
          Navigator.pushReplacementNamed(context, routeName);
        }
      },
    );
  }
}
