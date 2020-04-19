import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:skeleton_text/skeleton_text.dart';

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

class Shimmer2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 30, left: 30, right: 20),
      child: Column(children: [
        Row(
          children: <Widget>[
            SkeletonAnimation(
              shimmerColor: Colors.transparent,
              child: Container(
                width: 140.0,
                height: 140.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: Colors.grey[300],
                ),
              ),
            ),
            SizedBox(width: 30),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SkeletonAnimation(
                  child: Container(
                    width: MediaQuery.of(context).size.width / 2.3,
                    height: 20,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        color: Colors.grey[300]),
                  ),
                ),
                SizedBox(height: 10),
                SkeletonAnimation(
                  child: Container(
                    width: MediaQuery.of(context).size.width / 3,
                    height: 20,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        color: Colors.grey[300]),
                  ),
                ),
                SizedBox(height: 10),
                SkeletonAnimation(
                  child: Container(
                    width: MediaQuery.of(context).size.width / 5,
                    height: 20,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        color: Colors.grey[300]),
                  ),
                ),
              ],
            ),
          ],
        ),
      ]),
    );
  }
}
