import 'package:flutter/material.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

const kLoadingTextStyle = TextStyle(
  fontSize: 16.0,
  color: Colors.white,
);

class ProcessingDialog extends StatelessWidget {
  final Color color;
  final Widget icon;
  final String message;
  final Color waveColor;
  final bool showWave;

  ProcessingDialog({
    @required this.color,
    @required this.message,
    this.icon,
    this.waveColor,
    this.showWave = true,
  }) : assert(showWave ? waveColor != null : true);

  @override
  Widget build(BuildContext context) {
    // return Container(
    //   margin: EdgeInsets.all(24.0),
    //   constraints: BoxConstraints(minHeight: 256.0),
    //   decoration: BoxDecoration(
    //     borderRadius: BorderRadius.circular(8.0),
    //     color: color,
    //   ),
    //   clipBehavior: Clip.hardEdge,
    //   child: _buildWaveContent(
    //     Padding(
    //       padding: const EdgeInsets.all(24.0),
    //       child: Column(
    //         mainAxisAlignment: MainAxisAlignment.center,
    //         mainAxisSize: MainAxisSize.min,
    //         children: [
    //           this.icon,
    //           Flexible(
    //               child: SizedBox(
    //             height: 24.0,
    //           )),
    //           Text(
    //             this.message,
    //             textAlign: TextAlign.center,
    //             style: kLoadingTextStyle,
    //           ),
    //         ],
    //       ),
    //     ),
    //   ),
    // );
    return Container(
      margin: EdgeInsets.all(24.0),
      constraints: BoxConstraints(minHeight: 256.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: color,
      ),
      clipBehavior: Clip.hardEdge,
      child: _buildWaveContent(
        Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              this.icon,
              Flexible(child: SizedBox(height: 24.0)),
              Text(
                this.message,
                textAlign: TextAlign.center,
                style: kLoadingTextStyle,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWaveContent(Widget content) {
    if (!showWave) {
      return content;
    } else {
      return Stack(
        children: [
          Positioned.fill(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: WaveWidget(
                config: CustomConfig(
                  colors: [Color.lerp(waveColor, color, .5), waveColor],
                  durations: [25000, 10000],
                  heightPercentages: [.1, .25],
                ),
                size: Size.fromHeight(96.0),
                waveAmplitude: 15.0,
              ),
            ),
          ),
          content,
        ],
      );
    }
  }
}
