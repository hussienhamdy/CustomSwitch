library custom_switch;

import 'package:flutter/material.dart';

class CustomSwitch extends StatefulWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final Color activeColor;
  final Color inActiveColor;
  final Color borderColor;
  final Color activeCircleColor;
  final Color inActiveCircleColor;
  final double height;
  final double width;
  final bool isRTL;

  const CustomSwitch({
    Key key,
    this.value,
    this.onChanged,
    this.activeColor,
    this.inActiveColor,
    this.width,
    this.height,
    this.activeCircleColor,
    this.inActiveCircleColor,
    this.borderColor,
    this.isRTL,
  }) : super(key: key);

  @override
  _CustomSwitchState createState() => _CustomSwitchState();
}

class _CustomSwitchState extends State<CustomSwitch>
    with SingleTickerProviderStateMixin {
  Animation _circleAnimation;
  AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    Alignment active;
    Alignment inActive;
    if(widget.isRTL){
      active = Alignment.centerLeft;
      inActive = Alignment.centerRight;
    } else{
      active = Alignment.centerRight;
      inActive = Alignment.centerLeft;
    }
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 60));
    _circleAnimation = AlignmentTween(
            begin: widget.value ? active : inActive,
            end: widget.value ? inActive : active)
        .animate(CurvedAnimation(
            parent: _animationController, curve: Curves.linear));
  }

  @override
  Widget build(BuildContext context) {
    Alignment inActiveAlignment = Alignment.centerLeft;
    if(widget.isRTL){
      inActiveAlignment = Alignment.centerRight;
    }
    print('ssssss${_circleAnimation.value == Alignment.centerRight}');
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return GestureDetector(
            onTap: () {
              if (_animationController.isCompleted) {
                _animationController.reverse();
              } else {
                _animationController.forward();
              }
              widget.value == false
                  ? widget.onChanged(true)
                  : widget.onChanged(false);
            },
            child: Stack(overflow: Overflow.visible, children: [
              Container(
                width: widget.width,
                height: widget.height,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    border: Border.all(color: _circleAnimation.value == inActiveAlignment
                          ? widget.inActiveColor
                          : widget.activeColor),
                    color: _circleAnimation.value == inActiveAlignment
                        ? widget.inActiveColor
                        : widget.activeColor),
              ),
              Positioned(
                left: _circleAnimation.value == Alignment.centerLeft ? 1 : null,
                right:_circleAnimation.value == Alignment.centerLeft ? null: 1,
                child: Container(
                  width: widget.height,
                  height: widget.height,
                  decoration: BoxDecoration(
                    border: Border.all(color: _circleAnimation.value == inActiveAlignment
                          ? widget.inActiveColor
                          : widget.activeColor),
                      shape: BoxShape.circle,
                      color: _circleAnimation.value == inActiveAlignment
                          ? widget.inActiveCircleColor
                          : widget.activeCircleColor),
                ),
              ),
            ]));
      },
    );
  }
}


