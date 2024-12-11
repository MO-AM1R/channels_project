import 'package:channels/models/channel.dart';
import 'package:flutter/material.dart';

class ChannelCard extends StatelessWidget {
  final bool subscribed;
  final Function onSubscriptionChanged;
  final Function removeChannel;
  final Channel channel;
  final int index;

  const ChannelCard(
      {super.key,
      required this.channel,
      required this.subscribed,
      required this.onSubscriptionChanged,
      required this.removeChannel,
      required this.index});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: Column(
          children: [
            InkWell(
              onTap: (){
                removeChannel(index);
              },
              child: const Align(
                alignment: Alignment.topRight,
                child: Icon(Icons.close),
              ),
            ),
            CircleAvatar(
              backgroundImage: NetworkImage(channel.imageUrl),
              radius: 30,
            ),
            const SizedBox(
              height: 30,
            ),
            Text(
              channel.name,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.black,
                fontSize: 20,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Wrap(
              children: [
                FittedBox(
                  child: Text(
                    channel.description,
                    style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 20,
                        overflow: TextOverflow.ellipsis),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Switch(
                  activeColor: Colors.yellow,
                  activeTrackColor: Colors.black,
                  value: subscribed,
                  onChanged: (value) {
                    onSubscriptionChanged(value, index);
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
