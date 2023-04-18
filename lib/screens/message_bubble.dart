import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble(this.messsage, this.userName, this.userImage, this.isMe,
      {this.key});
  final Key? key;
  final String messsage;
  final String userName;
  final String userImage;
  final bool isMe;
  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Row(
          mainAxisAlignment:
              !isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  color:
                      !isMe ? Colors.grey[300] : Theme.of(context).accentColor,
                  borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(14),
                      topRight: const Radius.circular(14),
                      bottomLeft: !isMe
                          ? const Radius.circular(0)
                          : const Radius.circular(14),
                      bottomRight: isMe
                          ? const Radius.circular(0)
                          : const Radius.circular(14))),
              width: 140,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
              child: Column(
                crossAxisAlignment:
                    !isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    userName,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: !isMe
                            ? Colors.black
                            : Theme.of(context).colorScheme.primary),
                  ),
                  Text(
                    messsage,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: !isMe
                            ? Colors.black
                            : Theme.of(context).colorScheme.primary),
                    textAlign: !isMe ? TextAlign.end : TextAlign.start,
                  ),
                ],
              ),
            ),
          ],
        ),
        Positioned(
          top: 0,
          left: isMe ? 120 : null,
          right: !isMe ? 120 : null,
          child: CircleAvatar(
            backgroundImage: NetworkImage(userImage),
          ),
        ),
      ],
    );
  }
}
