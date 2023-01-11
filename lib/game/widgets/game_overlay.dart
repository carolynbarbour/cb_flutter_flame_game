// Copyright 2022 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:io' show Platform;
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

import '../doodle_dash.dart';
import 'widgets.dart';

class GameOverlay extends StatefulWidget {
  const GameOverlay(this.game, {super.key});

  final Game game;

  @override
  State<GameOverlay> createState() => GameOverlayState();
}

class GameOverlayState extends State<GameOverlay> {
  bool isPaused = false;
  bool isMobile = !kIsWeb && (Platform.isAndroid || Platform.isIOS);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          Positioned(
            top: 30,
            left: 30,
            child: ScoreDisplay(game: widget.game),
          ),
          Positioned(
            top: 30,
            right: 30,
            child: ElevatedButton(
              child: isPaused
                  ? const Icon(
                      Icons.play_arrow,
                      size: 48,
                    )
                  : const Icon(
                      Icons.pause,
                      size: 48,
                    ),
              onPressed: () {
                (widget.game as DoodleDash).togglePauseState();
                setState(
                  () {
                    isPaused = !isPaused;
                  },
                );
              },
            ),
          ),
          if (isMobile)
            SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: GestureDetector(
                    onTapDown: (details) async {
                      var playerPosition =
                          (widget.game as DoodleDash).player.position;

                      if (details.globalPosition.dx < playerPosition.x) {
                        (widget.game as DoodleDash).player.moveLeft();
                      } else if (details.globalPosition.dx > playerPosition.x) {
                        (widget.game as DoodleDash).player.moveRight();
                      }

                      await Future.delayed(Duration(milliseconds: 60), () {
                        (widget.game as DoodleDash).player.resetDirection();
                        return;
                      });
                    },
                    onTapUp: (details) {
                      (widget.game as DoodleDash).player.resetDirection();
                    },
                    onTapCancel: () =>
                        {(widget.game as DoodleDash).player.resetDirection()})),
          if (isPaused)
            Positioned(
              top: MediaQuery.of(context).size.height / 2 - 72.0,
              right: MediaQuery.of(context).size.width / 2 - 72.0,
              child: const Icon(
                Icons.pause_circle,
                size: 144.0,
                color: Colors.black12,
              ),
            ),
        ],
      ),
    );
  }
}
