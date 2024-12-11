import 'package:channels/main.dart';
import 'package:channels/models/channel.dart';
import 'package:flutter/material.dart';

class ChannelListTile extends StatelessWidget {
  final Channel channel;
  const ChannelListTile({super.key, required this.channel});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        navigationKey.currentState!.pushNamed('/chat', arguments: channel);
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(channel.imageUrl),
                  radius: 30,
                ),
                const SizedBox(
                  width: 15,
                ),
                Text(
                  channel.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.arrow_forward_ios,
                color: Colors.black,
                size: 30,
              ),
            ),
          ],
        ),
      ),
    );
  }
}