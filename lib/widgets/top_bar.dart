import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../utils/colors.dart';
import 'glass.dart';

class TopBar extends StatelessWidget {
  const TopBar({super.key});
  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.of(context).padding.top;
    return Padding(
      padding: EdgeInsets.fromLTRB(12, topInset + 10, 12, 0),
      child: SizedBox(
        height: 48,
        child: Row(
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 4),
              child: Text.rich(
                TextSpan(children: [
                  TextSpan(
                      text: 'Bot Flow ',
                      style: TextStyle(
                          color: AppColors.accent,
                          fontWeight: FontWeight.w800,
                          fontSize: 15,
                          letterSpacing: -0.5)),
                  TextSpan(
                      text: 'Builder',
                      style: TextStyle(
                          color: AppColors.textDim,
                          fontWeight: FontWeight.w500,
                          fontSize: 15)),
                ]),
              ),
            ),
            const Spacer(),
            _glassBtn('assets/icons/full-screen-bold.svg'),
            const SizedBox(width: 8),
            _glassBtn('assets/icons/upload-bold.svg'),
          ],
        ),
      ),
    );
  }

  Widget _glassBtn(String icon) {
    return Glass(
      borderRadius: BorderRadius.circular(20),
      child: SizedBox(
        width: 40,
        height: 40,
        child: Center(
          child: SvgPicture.asset(icon,
              width: 18,
              height: 18,
              colorFilter:
                  const ColorFilter.mode(AppColors.text, BlendMode.srcIn)),
        ),
      ),
    );
  }
}
