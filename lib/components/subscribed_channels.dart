import 'package:channels/components/channel_list_tile.dart';
import 'package:channels/constants.dart';
import 'package:flutter/material.dart';

class SubscribedChannels extends StatelessWidget {
  final Function logout;
  const SubscribedChannels({super.key, required this.logout});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Subscribed Channels',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey[900],
                fontSize: 30,
              ),
            ),
            IconButton(onPressed: (){
              logout();
            }, icon: const Icon(Icons.logout_outlined, size: 30, color: Colors.black,))
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        Expanded(
          child: ListView.builder(
            itemCount: user.subscribedChannels.length,
            itemBuilder: (context, index) {
              return ChannelListTile(channel: user.subscribedChannels[index]);
            },
          ),
        ),
      ],
    );
  }
}

