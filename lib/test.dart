import 'dart:math';

import 'package:card_animation/models/photo_card.dart';
import 'package:card_animation/widgets/photo.dart';
import 'package:flutter/material.dart';

class SliderDemo extends StatefulWidget {
  SliderDemo({Key key}) : super(key: key);

  @override
  _SliderDemoState createState() => _SliderDemoState();
}

class _SliderDemoState extends State<SliderDemo>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  final List<PhotoCard> photos = [
    PhotoCard(
      description: 'Photo card #1',
      link: 'https://picsum.photos/900/600?1',
    ),
    PhotoCard(
      description: 'Photo card #2',
      link: 'https://picsum.photos/900/600?2',
    ),
    PhotoCard(
      description: 'Photo card #3',
      link: 'https://picsum.photos/900/600?3',
    ),
    // PhotoCard(
    //   description: 'Photo card #4',
    //   link: 'https://picsum.photos/900/600?4',
    // ),
    // PhotoCard(
    //   description: 'Photo card #5',
    //   link: 'https://picsum.photos/900/600?5',
    // ),
    // PhotoCard(
    //   description: 'Photo card #6',
    //   link: 'https://picsum.photos/900/600?6',
    // ),
    // PhotoCard(
    //   description: 'Photo card #7',
    //   link: 'https://picsum.photos/900/600?7',
    // ),
  ];

  static const _dx = -15.0;
  static const _dy = -15.0;
  static const _dOp = 0.2;
  static const _dS = 0.01;

  final sliderIdx = [];

  static const slidesToShow = 2;
  int currentSlide = 0;

  List<Animation<Offset>> _offsetDy = [];
  List<Animation<double>> _opacity = [];
  List<Animation<double>> _scale = [];
  Animation<double> _rotate;
  Animation<Offset> _offsetDx;

  double _screenWidth;
  double _currentPos;
  double _currentAnimValue;
  bool _isReverse = false;
  bool _panStarted = false;
  int _animatedIdx = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      value: 0,
    );

    for (var idx = 0; idx < slidesToShow; idx++) {
      var oDy = Tween<Offset>(
        begin: Offset(0, _dy * idx),
        end: Offset(0, _dy * (idx - 1)),
      ).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(0, 1),
        ),
      );

      _offsetDy.add(oDy);

      var _op = Tween<double>(
        begin: 1 - (idx) * _dOp,
        end: idx == 0 ? 1 : 1 - (idx - 1) * _dOp,
      ).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(0, 1),
        ),
      );

      _opacity.add(_op);

      var s = Tween<double>(
        begin: 1 - idx * _dS,
        end: idx == 0 ? 1 : 1 - (idx - 1) * _dS,
      ).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(0, 1),
        ),
      );

      _scale.add(s);
    }

    _offsetDx = Tween<Offset>(
      begin: Offset(0, 0),
      end: Offset(-500, 10),
    ).animate(
      CurvedAnimation(parent: _controller, curve: Interval(.0, 1)),
    );

    _rotate = Tween<double>(
      begin: 0.0,
      end: -pi / 10,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Interval(.0, 1)),
    );
  }

  @override
  void didChangeDependencies() {
    _screenWidth = MediaQuery.of(context).size.width;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: _onTap,
            child: Stack(
              children: [
                for (var idx = 0; idx < photos.length; idx++)
                  _buildChild(idx, photos[idx])
              ].reversed.toList(),
            ),
          )
        ],
      ),
    );
  }

  PhotoCard getPhoto(idx) {
    if (currentSlide + idx >= photos.length) {
      return photos[((currentSlide + idx + 1) - photos.length) - 1];
    } else {
      return photos[currentSlide + idx];
    }
  }

  Widget _buildChild(idx, photo) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => _buildAnimation(context, child, idx),
      child: Photo(
        key: ValueKey(idx),
        photoCard: photo,
      ),
    );
  }

  Widget _buildAnimation(context, child, idx) {
    if (!_isAnimated(idx))
      return Transform.translate(
        offset: _offsetDx.value,
        child: Opacity(
          opacity: _opacity[_animatedIdx].value,
          child: child,
        ),
      );

    print(_animatedIdx);

    var isFirst = _animatedIdx == 0;

    var widgets = Transform.translate(
      offset: isFirst ? _offsetDx.value : _offsetDy[_animatedIdx].value,
      child: Opacity(
        opacity: _opacity[_animatedIdx].value,
        child: child,
      ),
    );

    if (_animatedIdx + 1 >= slidesToShow) {
      _animatedIdx = 0;
    } else {
      _animatedIdx++;
    }

    return widgets;
  }

  bool _isAnimated(idx) {
    if (currentSlide + slidesToShow < photos.length) {
      if (idx >= currentSlide && idx <= currentSlide + (slidesToShow - 1)) {
        return true;
      } else {
        return false;
      }
    } else {
      if (idx >= currentSlide) {
        return true;
      } else if (idx <= slidesToShow - (photos.length - currentSlide)) {
        return true;
      } else {
        return false;
      }
    }
  }

  void _onTap() {
    setState(() {
      if (currentSlide >= photos.length - 1) {
        currentSlide = 0;
      } else {
        currentSlide++;
      }
    });

    _controller.reset();
  }
}
