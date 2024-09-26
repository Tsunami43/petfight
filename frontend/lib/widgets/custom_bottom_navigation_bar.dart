import 'package:flutter/material.dart';
import 'package:petfight/constants.dart';
import 'package:provider/provider.dart';
import 'package:petfight/models/custom_text.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  const CustomBottomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    final navigationProvider = Provider.of<NavigationProvider>(context);
    return Container(
      color: Colors.red,
      height: 100,
      child: CustomPaint(
        painter: BottomPainter(),
        child: Container(
          color: Colors.transparent,
          height: 70,
          margin: const EdgeInsets.all(12.0),
          child: CustomPaint(
            painter: BottomNavigationPainter(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: CustomBottomNavigationButton(
                    title: 'Home',
                    isActive: navigationProvider.activeButton == 'Home',
                    onPressed: () {
                      navigationProvider.setActiveButton('Home');
                      Navigator.pushReplacementNamed(context, '/');
                    },
                  ),
                ),
                Expanded(
                  child: CustomBottomNavigationButton(
                    title: 'Shop',
                    isActive: navigationProvider.activeButton == 'Shop',
                    onPressed: () {
                      navigationProvider.setActiveButton('Shop');
                      Navigator.pushReplacementNamed(context, '/shop');
                    },
                  ),
                ),
                Expanded(
                  child: CustomBottomNavigationButton(
                    title: 'Tasks',
                    isActive: navigationProvider.activeButton == 'Tasks',
                    onPressed: () {
                      navigationProvider.setActiveButton('Tasks');
                      Navigator.pushReplacementNamed(context, '/task');
                    },
                  ),
                ),
                Expanded(
                  child: CustomBottomNavigationButton(
                    title: 'Friends',
                    isActive: navigationProvider.activeButton == 'Friends',
                    onPressed: () {
                      navigationProvider.setActiveButton('Friends');
                      Navigator.pushReplacementNamed(context, '/friends');
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BottomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint borderPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;

    Paint fillPaint = Paint()
      ..color = Colors.white;

    double left = 0;
    double right = size.width;
    double top = 0;
    double bottom = size.height;

    Offset topLeft = Offset(left, top);
    Offset topRight = Offset(right, top + 5);
    Offset bottomLeft = Offset(left, bottom);
    Offset bottomRight = Offset(right, bottom);

    Path path = Path()
      ..moveTo(topLeft.dx, topLeft.dy)
      ..lineTo(topRight.dx, topRight.dy)
      ..lineTo(bottomRight.dx, bottomRight.dy)
      ..lineTo(bottomLeft.dx, bottomLeft.dy)
      ..close();

    topLeft = Offset(left, top);
    topRight = Offset(right, top);
    Path pathTop = Path()
      ..moveTo(topLeft.dx, topLeft.dy)
      ..lineTo(topRight.dx, topRight.dy)
      ..close();

    canvas.drawPath(path, fillPaint);
    canvas.drawPath(path, borderPaint);
    canvas.drawPath(pathTop, borderPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class BottomNavigationPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint backgroundPaint = Paint()
      ..color = const Color.fromARGB(255, 73, 73, 73)
      ..style = PaintingStyle.fill;

    Paint borderPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;

    Path path = Path();
    path.moveTo(0, 10);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height - 10);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, backgroundPaint);
    canvas.drawPath(path, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class CustomBottomNavigationButton extends StatefulWidget {
  final String title;
  final VoidCallback onPressed;
  final bool isActive;

  const CustomBottomNavigationButton({
    super.key,
    required this.title,
    required this.onPressed,
    this.isActive = false,
  });

  @override
  // ignore: library_private_types_in_public_api
  _CustomBottomNavigationButtonState createState() =>
      _CustomBottomNavigationButtonState();
}

class _CustomBottomNavigationButtonState
    extends State<CustomBottomNavigationButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: widget.isActive
              ? const Color.fromARGB(255, 255, 255, 255)
              : Colors.transparent,
          border: Border.all(
            color: widget.isActive
                ? const Color.fromARGB(255, 0, 0, 0)
                : Colors.transparent,
            width: 2.0,
          ),
        ),
        child: SizedBox(
          child: CustomText(
            textAlign: TextAlign.center,
            data: widget.title,
            color: widget.isActive
                ? const Color.fromARGB(255, 255, 0, 0)
                : const Color.fromARGB(255, 255, 255, 255),
            fontSize: 20.0,
          ),
        ),
      ),
    );
  }
}
