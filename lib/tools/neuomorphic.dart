import 'package:flutter/material.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';

class EditedNeuomprphicContainer extends StatelessWidget {
  EditedNeuomprphicContainer(
      {this.icon, this.text, this.isIcon = false, this.isLanding = false});
  final IconData? icon;
  final String? text;
  final bool? isIcon;

  final bool? isLanding;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: GlassContainer(
        borderRadius: BorderRadius.circular(20),
        width: isIcon! && !isLanding! ? 120 : 100,
        blur: 8,
        height: isIcon! && !isLanding! ? 120 : 100,
        opacity: 0.3,
        shadowStrength: 8,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // isIcon!
                // ?
                Icon(icon),
                // :Container(),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
                    text!,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
