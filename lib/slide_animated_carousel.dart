library slide_animated_carousel;

import 'dart:math';

import 'package:flutter/widgets.dart';

class ScaleAnimatedCarousel extends StatefulWidget {
  final double dotHeight, extraPaddingForDots, dotGap, viewport;
  final IndexedWidgetBuilder builder;
  final PageController pageController;
  final int itemCount;
  final Color dotColor;

  const ScaleAnimatedCarousel(
      {Key key,
      this.dotHeight = 8.0,
      this.extraPaddingForDots = 48.0,
      this.dotGap = 8.0,
      this.viewport = 0.84,
      @required this.builder,
      this.pageController,
      @required this.itemCount,
      this.dotColor})
      : super(key: key);

  @override
  _ScaleAnimatedCarouselState createState() => _ScaleAnimatedCarouselState();
}

class _ScaleAnimatedCarouselState extends State<ScaleAnimatedCarousel> {
  double carouselPage = 0.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 32.0, bottom: widget.extraPaddingForDots),
      child: AspectRatio(
        aspectRatio: 480 / 160,
        child: NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification notification) {
            if (notification is ScrollUpdateNotification) {
              setState(() {
                carouselPage = widget.pageController.page;
              });
            }
          },
          child: Stack(
            overflow: Overflow.visible,
            children: <Widget>[
              PageView.builder(
                controller: widget.pageController,
                itemBuilder: (_, i) {
                  double scale = max(
                      0.88,
                      (1 - widget.viewport - (i - carouselPage).abs()) +
                          widget.viewport);

                  return Transform.scale(
                    scale: scale,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.width / 2,
                      child: widget.builder(_, i),
                    ),
                  );
                },
                itemCount: widget.itemCount,
              ),
              Positioned(
                bottom: -widget.dotHeight -
                    (widget.extraPaddingForDots / 2) +
                    (widget.dotHeight / 2),
                left: MediaQuery.of(context).size.width / 2 -
                    ((widget.dotHeight * widget.itemCount) / 2) -
                    ((widget.dotGap * widget.itemCount - 1) / 2),
                child: Row(
                  children: List.generate(
                    widget.itemCount,
                    (int i) {
                      return Container(
                        width: widget.dotHeight,
                        height: widget.dotHeight,
                        margin: EdgeInsets.only(
                          right:
                              i == widget.itemCount - 1 ? 0.0 : widget.dotGap,
                        ),
                        decoration: BoxDecoration(
                          color: widget.dotColor ?? Color(0xFFDDDDDD),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      );
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
