import 'package:flutter/material.dart';

class MessageTile extends StatelessWidget {
  final String message;
  final bool formCurrentUser;
  const MessageTile(
      {super.key, required this.message, required this.formCurrentUser});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 18),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          formCurrentUser
              ? const Expanded(
                  child: SizedBox(),
                )
              : const SizedBox(),
          InkWell(
            onTap: () {
             // debugPrint("on tap");
            },
            onHover: (value) {
              // debugPrint("on hover detected");
              // debugPrint(value.toString());
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                vertical: 6,
                horizontal: 8,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                color: formCurrentUser
                    ? Colors.blue
                    : const Color.fromARGB(
                        255,
                        75,
                        75,
                        75,
                      ),
              ),
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * .5,
                ),
                child: Text(
                  message,
                  softWrap: true,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
