import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_scene/scene.dart';
import 'package:vector_math/vector_math.dart';

class FlutterGpuPage extends StatefulWidget {
  const FlutterGpuPage({super.key});

  @override
  FlutterGpuPageState createState() => FlutterGpuPageState();
}

class FlutterGpuPageState extends State<FlutterGpuPage> {
  double hAngle = 1;
  double vAngle = 1;
  double radius = 1;

  final initResources = Scene.initializeStaticResources();
  final scene = Scene();

  Vector3 calculateCameraPosition() {
    final y = radius * sin(vAngle);
    final x = radius * cos(vAngle) * sin(hAngle);
    final z = radius * cos(vAngle) * cos(hAngle);
    return Vector3(x, y, z);
  }

  @override
  void initState() {
    super.initState();

    unawaited(
      // アセットからモデルを読み込む
      Node.fromAsset('assets/Shoe.model').then(scene.add),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter GPU Demo'),
      ),
      body: FutureBuilder(
        // リソースの初期化処理
        future: initResources,
        builder: (context, snapShot) {
          if (snapShot.connectionState != ConnectionState.done) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }

          return Center(
            child: SizedBox(
              height: 500,
              width: MediaQuery.sizeOf(context).width,
              child: GestureDetector(
                child: CustomPaint(
                  painter: ScenePainter(
                    scene: scene,
                    camera: PerspectiveCamera(
                      position: calculateCameraPosition(),
                    ),
                  ),
                ),
                onScaleUpdate: (details) {
                  setState(() {
                    radius = (radius / details.scale).clamp(0.5, 1.0);

                    final dx = details.focalPointDelta.dx / 100;
                    final dy = details.focalPointDelta.dy / 100;

                    hAngle += dx;
                    vAngle += dy;
                    vAngle = vAngle.clamp(-pi / 2, pi / 2);
                  });
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

class ScenePainter extends CustomPainter {
  ScenePainter({required this.scene, required this.camera});

  Scene scene;
  Camera camera;

  @override
  void paint(Canvas canvas, Size size) {
    scene.render(camera, canvas, viewport: Offset.zero & size);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
