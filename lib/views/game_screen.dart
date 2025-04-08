import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/game_controller.dart';
import '../widgets/tile_widget.dart';

class GameScreen extends StatelessWidget {
  final GameController controller = Get.put(GameController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFDFD),
      body: SafeArea(
        child: Column(
          children: [
            // Top Row: Title and Score
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Manguland 🍒',
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                  Obx(() => Text(
                        'Score: ${controller.score}',
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      )),
                ],
              ),
            ),

            // Match status message (if any)
            Obx(() {
              if (controller.matchStatus.value.isEmpty) {
                return const SizedBox(height: 30);
              }
              return Text(
                controller.matchStatus.value,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepOrange,
                ),
              );
            }),

            // GridView of tiles
            Expanded(
              child: Obx(() => GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: controller.gridSize,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemCount: controller.tiles.length,
                    itemBuilder: (context, index) {
                      return TileWidget(index: index);
                    },
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
