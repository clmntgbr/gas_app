import 'package:flutter/material.dart';

void getShowSnackBar(BuildContext context, String type, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    getSnackBar(context, type, message),
  );
}

SnackBar getSnackBar(BuildContext context, String type, String message) {
  Color colorAccent = Colors.redAccent;
  Color color = const Color.fromARGB(255, 201, 32, 20);

  if (type == 'success') {
    colorAccent = const Color.fromARGB(255, 47, 198, 125);
    color = const Color.fromRGBO(22, 131, 26, 1);
  }

  return SnackBar(
    backgroundColor: Colors.transparent,
    behavior: SnackBarBehavior.floating,
    elevation: 0,
    margin: EdgeInsets.only(
      bottom: MediaQuery.of(context).size.height - 50,
      right: 20,
      left: 20,
    ),
    content: Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        Container(
          height: 60,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: colorAccent,
            borderRadius: const BorderRadius.all(
              Radius.circular(15),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                width: 50,
              ),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(fontSize: 14, color: Colors.white),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 25,
          left: 30,
          child: ClipRRect(
            child: Stack(
              children: [
                Icon(
                  Icons.circle,
                  color: color,
                  size: 17,
                )
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 10,
          left: 20,
          child: ClipRRect(
            child: Stack(
              children: [
                Icon(
                  Icons.circle,
                  color: color,
                  size: 10,
                )
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 30,
          left: 5,
          child: ClipRRect(
            child: Stack(
              children: [
                Icon(
                  Icons.circle,
                  color: color,
                  size: 25,
                )
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
