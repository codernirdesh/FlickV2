import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerCard extends StatelessWidget {
  const ShimmerCard({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: Container(
        width: 110,
        height: 150,
        child: Shimmer(
            child: ClipRect(
              child: Container(
                width: 110,
                height: 150,
                color: Colors.white.withOpacity(0.3),
              ),
            ),
            gradient: LinearGradient(colors: [Colors.white, Colors.white10])),
        color: Colors.white.withOpacity(0.2),
      ),
    );
  }
}
