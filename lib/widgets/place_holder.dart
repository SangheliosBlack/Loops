import 'package:flutter/material.dart';

const List<Color> defaultColors = [
  Color.fromRGBO(0, 0, 0, 0.1),
  Color(0x44CCCCCC),
  Color.fromRGBO(0, 0, 0, 0.1)
];

class Shimmer extends StatefulWidget {
  final double height;
  final double width;
  final double radius;

  final bool isDarkMode;
  final bool isPurplishMode;
  final AlignmentGeometry beginAlign;
  final AlignmentGeometry endAlign;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final bool hasCustomColors;
  final bool hasBottomFirstLine;
  final bool hasBottomSecondLine;
  final List<Color> colors;
  final ScrollPhysics physics;
  final Color bgColor;

  const Shimmer(
      {Key? key,
      this.isDarkMode = false,
      this.isPurplishMode = false,
      this.beginAlign = Alignment.topLeft,
      this.endAlign = Alignment.bottomRight,
      this.padding = const EdgeInsets.all(16.0),
      this.margin = const EdgeInsets.all(16.0),
      this.hasCustomColors = false,
      this.colors = defaultColors,
      this.hasBottomFirstLine = true,
      this.hasBottomSecondLine = true,
      this.physics = const BouncingScrollPhysics(),
      this.bgColor = Colors.transparent,
      required this.height,
      required this.width,
      required this.radius})
      : super(key: key);
  @override
  _ShimmerState createState() => _ShimmerState();
}

class _ShimmerState extends State<Shimmer> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  // * init
  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(duration: const Duration(seconds: 2), vsync: this)
          ..repeat();
    _animation = Tween<double>(begin: -2, end: 2).animate(CurvedAnimation(
        curve: Curves.easeInOutSine, parent: _animationController));
  }

  // ***dispose
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color:
                  widget.isDarkMode ? const Color(0xFF0B0B0B) : widget.bgColor,
            ),
            child: Container(
              height: widget.height,
              width: widget.width,
              decoration: radiusBoxDecoration(
                  radius: widget.radius,
                  animation: _animation,
                  isPurplishMode: widget.isPurplishMode,
                  isDarkMode: widget.isDarkMode,
                  hasCustomColors: widget.hasCustomColors,
                  colors: widget.colors.length == 3
                      ? widget.colors
                      : defaultColors),
            ));
      },
    );
  }

  Decoration radiusBoxDecoration(
      {required Animation animation,
      bool isDarkMode = false,
      bool isPurplishMode = false,
      bool hasCustomColors = false,
      AlignmentGeometry beginAlign = Alignment.topLeft,
      AlignmentGeometry endAlign = Alignment.bottomRight,
      List<Color> colors = defaultColors,
      double radius = 10.0}) {
    return BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        shape: BoxShape.rectangle,
        gradient: LinearGradient(
            begin: beginAlign,
            end: endAlign,
            colors: hasCustomColors
                ? colors.map((color) {
                    return color;
                  }).toList()
                : [
                    isPurplishMode
                        ? const Color(0xFF8D71A9)
                        : isDarkMode
                            ? Colors.red
                            : const Color.fromRGBO(256, 256, 256, .1),
                    isPurplishMode
                        ? const Color(0xFF36265A)
                        : isDarkMode
                            ? Colors.red
                            : const Color.fromRGBO(256, 256, 256, .1),
                    isPurplishMode
                        ? const Color(0xFF8D71A9)
                        : isDarkMode
                            ? Colors.red
                            : const Color.fromRGBO(256, 256, 256, .0),
                  ],
            stops: [
              animation.value - 2,
              animation.value,
              animation.value + 2,
            ]));
  }
}
