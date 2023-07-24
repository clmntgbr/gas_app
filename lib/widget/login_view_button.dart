import 'package:flutter/material.dart';

Widget getLoginViewButton(Widget toScreen, BuildContext context) {
  return SizedBox(
    height: double.infinity,
    child: Center(
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        padding: const EdgeInsets.only(
          top: 15,
          left: 20,
          right: 20,
        ),
        children: [
          Container(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0),
            height: 58,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: const Color(0xff132137),
            ),
            child: InkWell(
              key: const ValueKey('SignIn button'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => toScreen),
                );
              },
              child: const Padding(
                padding: EdgeInsets.only(left: 16.0, right: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Me connecter',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Icon(Icons.arrow_forward_rounded, color: Colors.white),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    ),
  );
}
