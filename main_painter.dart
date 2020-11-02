import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';

void main() {
  runApp(IndicatorApp());
}

class SignInController extends GetxController {
  var _isSignIn = true.obs;

  bool get isSignIn => _isSignIn.value;
  set isSignIn(bool value) => _isSignIn.value = value;
}

class TwinRow extends StatefulWidget {
  final List<Widget> twins;
  final Function(int) onPressed;
  final Color tabColor;
  final double tabThickness;
  const TwinRow({
    Key key,
    @required this.twins,
    this.onPressed,
    this.tabColor,
    this.tabThickness = 3.0,
  })  : assert(twins.length == 2),
        super(key: key);

  @override
  _TwinRowState createState() => _TwinRowState();
}

class _TwinRowState extends State<TwinRow> with SingleTickerProviderStateMixin {
  GlobalKey _rowKey = GlobalKey();
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: kTabScrollDuration,
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    var tabColor = widget.tabColor ?? Theme.of(context).indicatorColor;
    return CustomPaint(
      painter: _TabPainter(_controller, _rowKey, tabColor, widget.tabThickness),
      child: Padding(
        padding: EdgeInsets.only(bottom: widget.tabThickness),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          key: _rowKey,
          children: [
            FlatButton(
                onPressed: () => _handlePress(0.0, 0), child: widget.twins[0]),
            FlatButton(
                onPressed: () => _handlePress(1.0, 1), child: widget.twins[1]),
          ],
        ),
      ),
    );
  }

  _handlePress(double target, int index) {
    var _signInController = Get.find<SignInController>();

    _controller.animateTo(target, curve: Curves.ease);
    (index == 0)
        ? _signInController.isSignIn = true
        : _signInController.isSignIn = false;
    widget.onPressed?.call(index);
  }
}

class _TabPainter extends CustomPainter {
  final Animation<double> animation;
  final GlobalKey rowKey;
  final Color tabColor;
  final double tabThickness;

  _TabPainter(this.animation, this.rowKey, this.tabColor, this.tabThickness)
      : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    var rects = (rowKey.currentContext.findRenderObject() as RenderFlex)
        .getChildrenAsList()
        .map((e) => (e.parentData as BoxParentData).offset & e.size);
    var rect =
        Rect.lerp(rects.elementAt(0), rects.elementAt(1), animation.value);

    canvas.drawRect(rect.bottomLeft & Size(rect.width, tabThickness),
        Paint()..color = tabColor);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class IndicatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Indicator Test',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: IndicatorHome(),
    );
  }
}

class IndicatorHome extends StatefulWidget {
  @override
  _IndicatorHomeState createState() => _IndicatorHomeState();
}

class _IndicatorHomeState extends State<IndicatorHome>
    with SingleTickerProviderStateMixin {
  var _isSignInController = Get.put(SignInController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Text(
              'Animated Painter Test',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 30),
            Obx(
              () => TwinRow(
                twins: [
                  Text(
                    'Sign In',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: (_isSignInController.isSignIn)
                          ? Theme.of(context).primaryColor
                          : Colors.black,
                    ),
                  ),
                  Text(
                    'Sign Up',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: (!_isSignInController.isSignIn)
                          ? Theme.of(context).primaryColor
                          : Colors.black,
                    ),
                  ),
                ],
                tabThickness: 5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
