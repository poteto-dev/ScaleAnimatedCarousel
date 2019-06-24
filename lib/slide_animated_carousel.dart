library slide_animated_carousel;

import 'dart:math';

import 'package:flutter/widgets.dart';

class ScaleAnimatedCarousel extends StatefulWidget {
  final double dotHeight, extraPaddingForDots, dotGap, viewport, aspectRatio;
  final IndexedWidgetBuilder builder;
  final PageController pageController;
  final int itemCount;
  final Color dotColor, indicatorColor;

  const ScaleAnimatedCarousel(
      {Key key,
      this.dotHeight = 8.0,
      this.extraPaddingForDots = 48.0,
      this.dotGap = 8.0,
      this.viewport = 0.84,
      @required this.builder,
      this.pageController,
      @required this.itemCount,
      this.dotColor,
      this.aspectRatio = 1.0})
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
        aspectRatio: widget.aspectRatio,
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
                child: Stack(
                  children: <Widget>[
                    Row(
                      children: List.generate(
                        widget.itemCount + 1,
                            (int i) {
                          return Container(
                            width: widget.dotHeight,
                            height: widget.dotHeight,
                            margin: EdgeInsets.only(
                              right:
                              i == widget.itemCount ? 0.0 : widget.dotGap,
                            ),
                            decoration: BoxDecoration(
                              color: widget.dotColor ?? Color(0xFFDDDDDD),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          );
                        },
                      ),
                    ),
                    Positioned(
                      left: carouselPage * (widget.dotHeight + widget.dotGap),
                      child: Container(
                        height: widget.dotHeight,
                        width: widget.dotHeight * 2 + widget.dotGap,
                        decoration: BoxDecoration(
                          color: widget.indicatorColor ?? Color(0xFF3ebc93),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
