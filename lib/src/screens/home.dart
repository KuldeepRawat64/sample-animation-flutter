import 'dart:math';

import 'package:flutter/material.dart';

import '../widgets/cat.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  late Animation<double> _catAnimation;
  late AnimationController _catController;
  late Animation<double> _boxAnimation;
  late AnimationController _boxController;

  @override
  void initState() {
    super.initState();
    _catController = AnimationController(
        duration: const Duration(milliseconds: 200), vsync: this);

    _catAnimation = Tween(begin: -35.0, end: -82.0).animate(
      CurvedAnimation(
        parent: _catController,
        curve: Curves.easeIn,
      ),
    );

    _boxController = AnimationController(
        duration: const Duration(milliseconds: 200), vsync: this);

    _boxAnimation = Tween(begin: pi * 0.6, end: pi * 0.65).animate(
      CurvedAnimation(
        parent: _boxController,
        curve: Curves.easeInOut,
      ),
    );

    _boxAnimation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _boxController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _boxController.forward();
      }
    });
    _boxController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Animation'),
      ),
      body: GestureDetector(
        onTap: onTap,
        child: Center(
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              buildCatAnimation(),
              buildBox(),
              buildLeftFlap(),
              buildRightFlap(),
            ],
          ),
        ),
      ),
    );
  }

  onTap() {
    if (_catController.status == AnimationStatus.completed) {
      _boxController.forward();
      _catController.reverse();
    } else if (_catController.status == AnimationStatus.dismissed) {
      _boxController.stop();
      _catController.forward();
    }
  }

  Widget buildCatAnimation() {
    return AnimatedBuilder(
        animation: _catAnimation,
        builder: (BuildContext context, Widget? child) {
          return Positioned(
            left: 0.0,
            right: 0.0,
            top: _catAnimation.value,
            child: Container(
              child: child,
            ),
          );
        },
        child: const Cat());
  }

  Widget buildBox() {
    return Container(
      height: 200,
      width: 200,
      color: Colors.brown,
    );
  }

  Widget buildLeftFlap() {
    return Positioned(
      left: 3,
      child: AnimatedBuilder(
        animation: _boxAnimation,
        builder: (context, child) {
          return Transform.rotate(
            angle: _boxAnimation.value,
            alignment: Alignment.topLeft,
            child: child,
          );
        },
        child: Container(
          height: 10.0,
          width: 110.0,
          color: Colors.brown,
        ),
      ),
    );
  }

  Widget buildRightFlap() {
    return Positioned(
      right: 3,
      child: AnimatedBuilder(
        animation: _boxAnimation,
        builder: (context, child) {
          return Transform.rotate(
            angle: -_boxAnimation.value,
            alignment: Alignment.topRight,
            child: child,
          );
        },
        child: Container(
          height: 10.0,
          width: 110.0,
          color: Colors.brown,
        ),
      ),
    );
  }
}
