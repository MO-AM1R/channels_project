import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function onTap;
  const BottomNavBar({super.key, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: const BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.only(
            topLeft: Radius.elliptical(30, 20),
            topRight: Radius.elliptical(30, 20),
          )),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            onPressed: () => onTap(0),
            icon: Icon(Icons.add_box,
                color: currentIndex == 0 ? Colors.white : Colors.grey,
                size: 30),
          ),
          IconButton(
            onPressed: () => onTap(1),
            icon: Icon(Icons.subscriptions,
                color: currentIndex == 1 ? Colors.white : Colors.grey,
                size: 30),
          ),
        ],
      ),
    );
  }
}
