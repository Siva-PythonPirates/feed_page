import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class FeedItem {
  final String imageUrl;
  final String videoUrl;
  final String location;
  final String description;
  final List<String> comments;
  final String username;

  FeedItem({
    required this.imageUrl,
    required this.videoUrl,
    required this.location,
    required this.description,
    required this.comments,
    required this.username,
  });
}

class FeedScreen extends StatelessWidget {
  final List<FeedItem> feedItems = [    FeedItem(      imageUrl: 'https://static.videezy.com/system/resources/thumbnails/000/040/716/small/DSCF2211-264.jpg',      videoUrl: 'https://static.videezy.com/system/resources/previews/000/040/716/original/DSCF2211-264.mp4',      location: 'New York, USA',      description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed euismod nisi et arcu luctus, eu blandit magna ultrices. Nullam et lectus purus. Praesent eget neque dui. Nam suscipit massa quis arcu consectetur, vel fermentum ante.',      comments: [        'Comment 1',        'Comment 2',        'Comment 3',      ],
    username: 'user123',
  ),
    FeedItem(
      imageUrl: 'https://static.videezy.com/system/resources/thumbnails/000/040/717/small/DSCF2212-264.jpg',
      videoUrl: 'https://static.videezy.com/system/resources/previews/000/040/717/original/DSCF2212-264.mp4',
      location: 'Paris, France',
      description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed euismod nisi et arcu luctus, eu blandit magna ultrices. Nullam et lectus purus. Praesent eget neque dui. Nam suscipit massa quis arcu consectetur, vel fermentum ante.',
      comments: [
        'Comment 1',
        'Comment 2',
      ],
      username: 'user456',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Feed'),
        ),
        body: ListView.separated(
        separatorBuilder: (BuildContext context, int index) {
      return Divider(height: 16);
    },
    itemCount: feedItems.length,
    itemBuilder: (BuildContext context, int index) {
      final feedItem = feedItems[index];

      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                CircleAvatar(
                  child: Text(feedItem.username[0]),
                ),
                SizedBox(width: 8),
                Text(feedItem.username),
              ],
            ),
          ),
          Stack(
            children: [
              SizedBox(
                height: 200,
                child: PageView(
                  children: [
                    Image.network(feedItem.imageUrl),
                    VideoPlayerWidget(url: feedItem.videoUrl),
                  ],
                ),
              ),
              Positioned(
                top: 8,
                left: 8,
                child: Text(feedItem.location),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.bookmark_border),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: Icon(Icons.upload_sharp),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 8,
                left: 8,
                child: Text(
                  '${feedItem.comments.length} comments',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            feedItem.description.substring(0, 100) + '...',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 8),
          TextButton(
            child: Text('Read more'),
            onPressed: () {
// Show entire description in a dialog
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Full Description'),
                    content: Text(feedItem.description),
                    actions: [
                      TextButton(
                        child: Text('Close'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
          SizedBox(height: 8),
          Divider(),
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.thumb_up),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.chat_bubble_outline_outlined),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.share),
                onPressed: () {},
              ),
            ],
          ),
        ],
      );
    }
    ),
    );
    }
  }

class VideoPlayerWidget extends StatefulWidget {
  final String url;

  const VideoPlayerWidget({required this.url});

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.url)..initialize().then((_) {
      setState(() {});
    }).catchError((error) {
      // Handle the error
      print('Error initializing video player: $error');
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  void _togglePlaying() {
    setState(() {
      _isPlaying = !_isPlaying;
      if (_isPlaying) {
        _controller.play();
      } else {
        _controller.pause();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_controller.value.isInitialized) {
      return GestureDetector(
        onTap: _togglePlaying,
        child: AspectRatio(
          aspectRatio: _controller.value.aspectRatio,
          child: Stack(
            alignment: Alignment.center,
            children: [
              VideoPlayer(_controller),
              if (!_isPlaying)
                Icon(Icons.play_arrow, size: 50, color: Colors.white),
            ],
          ),
        ),
      );
    } else {
      return Container();
    }
  }
}
