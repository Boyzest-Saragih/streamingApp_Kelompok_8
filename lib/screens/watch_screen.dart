import 'package:flutter/material.dart';

class WatchPage extends StatefulWidget {
  final String titleMovie;
  final String descMovie;
  final String releaseDateMovie;
  const WatchPage({
    super.key,
    required this.titleMovie,
    required this.descMovie,
    required this.releaseDateMovie,
  });

  @override
  State<WatchPage> createState() => _WatchPageState();
}

class _WatchPageState extends State<WatchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.titleMovie)),
      body: Column(
        children: [Text(widget.descMovie), Text(widget.releaseDateMovie)],
      ),
    );
  }
}
