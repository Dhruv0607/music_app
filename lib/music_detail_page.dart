import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:audioplayers/audioplayers.dart';

import 'colors.dart';

class MusicDetailPage extends StatefulWidget {
  final String title;
  final String description;
  final Color color;
  final String img;
  final String songUrl;

  const MusicDetailPage(
      {Key key,
      this.title,
      this.description,
      this.color,
      this.img,
      this.songUrl})
      : super(key: key);
  @override
  _MusicDetailPageState createState() => _MusicDetailPageState();
}

class _MusicDetailPageState extends State<MusicDetailPage> {
  double _currentSliderValue = 20;

  // audio player here
  AudioPlayer advancedPlayer;
  AudioCache audioCache;
  bool isPlaying = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  initPlayer() {
    advancedPlayer = new AudioPlayer();
    audioCache = new AudioCache(fixedPlayer: advancedPlayer);
    playSound(widget.songUrl);
  }

  playSound(localPath) async {
    await audioCache.play(localPath);
  }

  stopSound(localPath) async {
    File audioFile = (await audioCache.load(localPath)) as File;
    await advancedPlayer.setUrl(audioFile.path);
    advancedPlayer.stop();
  }

  seekSound() async {
    File audioFile = (await audioCache.load(widget.songUrl)) as File;
    await advancedPlayer.setUrl(audioFile.path);
    advancedPlayer.seek(Duration(milliseconds: 2000));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    stopSound(widget.songUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: getAppBar(),
      body: getBody(),
    );
  }

  Widget getAppBar() {
    return AppBar(
      backgroundColor: Colors.black,
      elevation: 0,
      actions: [
        IconButton(
            icon: Icon(
              Feather.more_vertical,
              color: Colors.white,
            ),
            onPressed: null),
      ],
    );
  }

  Widget getBody() {
    var size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        children: [
          Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 30,
                  right: 30,
                  top: 20,
                ),
                child: Container(
                  width: size.width - 100,
                  height: size.width - 60,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: widget.color,
                        blurRadius: 50,
                        spreadRadius: 5,
                        offset: Offset(-10, 40),
                      ),
                    ],
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 30,
                  right: 30,
                  top: 20,
                ),
                child: Container(
                  width: size.width - 60,
                  height: size.width - 60,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(widget.img),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 10,
              right: 20,
            ),
            child: Container(
              width: size.width - 80,
              height: 70,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    AntDesign.addfolder,
                    color: Colors.white,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        widget.title,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        width: 150,
                        child: Text(
                          widget.description,
                          maxLines: 1,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.white.withOpacity(0.5),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Icon(
                    Feather.more_vertical,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Slider(
            activeColor: primary,
            value: _currentSliderValue,
            min: 0,
            max: 200,
            onChanged: (value) {
              setState(() {
                _currentSliderValue = value;
              });
              seekSound();
            },
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 30,
              right: 30,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "1:50",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                  ),
                ),
                Text(
                  "4:50",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 20,
              right: 20,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(
                    Feather.shuffle,
                    color: Colors.white.withOpacity(0.8),
                    size: 25,
                  ),
                  onPressed: null,
                ),
                IconButton(
                  icon: Icon(
                    Feather.skip_back,
                    color: Colors.white.withOpacity(0.8),
                    size: 25,
                  ),
                  onPressed: null,
                ),
                IconButton(
                  iconSize: 50,
                  icon: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: primary,
                    ),
                    child: Center(
                      child: Icon(
                        isPlaying
                            ? Entypo.controller_stop
                            : Entypo.controller_play,
                        size: 28,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  onPressed: () {
                    if (isPlaying) {
                      stopSound(widget.songUrl);
                      setState(() {
                        isPlaying = false;
                      });
                    } else {
                      playSound(widget.songUrl);
                      setState(() {
                        isPlaying = true;
                      });
                    }
                  },
                ),
                IconButton(
                  icon: Icon(
                    Feather.skip_forward,
                    color: Colors.white.withOpacity(0.8),
                    size: 25,
                  ),
                  onPressed: null,
                ),
                IconButton(
                  icon: Icon(
                    AntDesign.retweet,
                    color: Colors.white.withOpacity(0.8),
                    size: 25,
                  ),
                  onPressed: null,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Feather.tv,
                color: primary,
                size: 20,
              ),
              SizedBox(
                width: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 3,
                ),
                child: Text(
                  "Chromcast is ready",
                  style: TextStyle(
                    color: primary,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
