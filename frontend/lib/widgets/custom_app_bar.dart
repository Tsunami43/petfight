import 'package:flutter/material.dart';
import 'package:petfight/constants.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:petfight/models/user.dart';
import 'package:petfight/models/custom_text.dart';

class CustomAppBar extends StatelessWidget {

  const CustomAppBar({
    super.key,
  });

  Future<void> _launchInBrowser() async {
    if (!await canLaunchUrl(Uri.parse(webSiteUrl))) {
      throw 'Could not launch $webSiteUrl';
    }
    await launchUrl(Uri.parse(webSiteUrl));
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return Container(
      color: Colors.red,
      child: Center(
        child: SizedBox(
          height: 60,
          child: CustomPaint(
            painter: AppbarPainter(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Center(
                      child: CustomTextRow(
                        partOne: 'Balance: ',
                        partTwo: '${user.balance}♛',
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color.fromARGB(255, 0, 0, 0),
                        width: 2.0,
                      ),
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        backgroundColor: const Color.fromARGB(255, 73, 73, 73),
                      ),
                      onPressed: _launchInBrowser,
                      child: const Icon(
                        Icons.public,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AppbarPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final borderPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;

    final fillPaint = Paint()
      ..color = Colors.white;

    const left = 0.0;
    final right = size.width;
    const top = 0.0;
    final bottom = size.height;

    const topLeft = Offset(left, top);
    final topRight = Offset(right, top);
    Offset bottomLeft= Offset(left, bottom - 10);
    final bottomRight = Offset(right, bottom);

    final path = Path()
      ..moveTo(topLeft.dx, topLeft.dy)
      ..lineTo(topRight.dx, topRight.dy)
      ..lineTo(bottomRight.dx, bottomRight.dy)
      ..lineTo(bottomLeft.dx, bottomLeft.dy)
      ..close();

    bottomLeft = Offset(left, bottom);

    final pathBottom = Path()
      ..moveTo(bottomLeft.dx, bottomLeft.dy)
      ..lineTo(bottomRight.dx, bottomRight.dy)
      ..close();

    canvas.drawPath(path, fillPaint);
    canvas.drawPath(path, borderPaint);
    canvas.drawPath(pathBottom, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
