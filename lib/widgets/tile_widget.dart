import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/game_controller.dart';

class TileWidget extends StatelessWidget {
  final int index;
  final GameController controller = Get.find();

  TileWidget({required this.index});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final tile = controller.tiles[index];
      return GestureDetector(
        onTap: () {
          controller.handleTileTap(index); // ✅ Tap logic here
        },
        child: AnimatedScale(
          scale: tile.isMatched ? 0 : 1,
          duration: const Duration(milliseconds: 300),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(color: Colors.grey.shade300, blurRadius: 4),
              ],
              border: Border.all(
                color: controller.selectedTileIndex.value == index
                    ? Colors.deepPurple
                    : Colors.transparent,
                width: 3,
              ),
            ),
            child: Center(
              child: Text(
                tile.emoji,
                style: const TextStyle(fontSize: 28),
              ),
            ),
          ),
        ),
      );
    });
  }
}
