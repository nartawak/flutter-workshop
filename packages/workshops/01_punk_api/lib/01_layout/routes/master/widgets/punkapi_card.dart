import 'package:flutter/material.dart';

class PunkApiCard extends StatelessWidget {
  const PunkApiCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
      height: 100,
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          Container(
            width: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.green,
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.yellow,
            ),
          )
        ],
      ),
    );
  }
}
