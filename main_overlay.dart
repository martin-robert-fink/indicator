import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';

void main() {
  runApp(OverlayApp());
}

class OverlayApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Overlay Test',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: OverlayHome(),
    );
  }
}

class OverlayHome extends StatelessWidget {
  var _isSignIn = true.obs;
  final _signinKey = GlobalKey();
  final _signupKey = GlobalKey();

  OverlayEntry _indicatorOverlayEntry;

  void _setIndicator() {
    _indicatorOverlayEntry?.remove();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _indicatorOverlayEntry = _overlayEntry();
      Overlay.of(_signinKey.currentContext).insert(_indicatorOverlayEntry);
    });
  }

  OverlayEntry _overlayEntry() {
    RenderBox signinRenderBox = _signinKey.currentContext.findRenderObject();
    RenderBox signupRenderBox = _signupKey.currentContext.findRenderObject();
    final signinWidgetPosition = signinRenderBox.localToGlobal(Offset.zero);
    final signupWidgetPosition = signupRenderBox.localToGlobal(Offset.zero);
    final signinWidgetSize = signinRenderBox.size;
    final signupWidgetSize = signupRenderBox.size;

    return OverlayEntry(
      builder: (context) => Stack(
        children: [
          Obx(
            () => AnimatedPositioned(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeOutQuint,
              top: signinWidgetPosition.dy + signinWidgetSize.height,
              height: 3.0,
              left: (_isSignIn.value)
                  ? signinWidgetPosition.dx
                  : signupWidgetPosition.dx,
              width: (_isSignIn.value)
                  ? signinWidgetSize.width
                  : signupWidgetSize.width,
              child: Container(color: Theme.of(context).primaryColor),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            _setIndicator();
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                Text(
                  'Animated Overlay Test',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 30),
                Obx(
                  () => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      FlatButton(
                        child: Text(
                          "Sign In",
                          key: _signinKey,
                          style: (_isSignIn.value)
                              ? TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold)
                              : TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                        ),
                        onPressed: () {
                          _isSignIn.value = true;
                        },
                      ),
                      FlatButton(
                        child: Text(
                          "Sign Up",
                          key: _signupKey,
                          style: (!_isSignIn.value)
                              ? TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold)
                              : TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                        ),
                        onPressed: () {
                          _isSignIn.value = false;
                        },
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
