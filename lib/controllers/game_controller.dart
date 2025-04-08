import 'dart:math';
import 'package:get/get.dart';
import '../models/tile_model.dart';

class GameController extends GetxController {
  final List<String> emojis = ['🍋', '🥑', '🍳', '🧀', '🍇', '🌶️'];

  var gridSize = 6;
  var matchedTiles = 0.obs;
  var matchStatus = ''.obs;
  var score = 0.obs; // ✅ Score added
var selectedTileIndex = RxnInt(); // null by default

  final List<String> matchMessages = ['Sweet!', 'Awesome!', 'Great!', 'Boom!', 'Yummy!'];
  RxList<TileModel> tiles = <TileModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    generateBoard();
  }

void handleTileTap(int index) {
  if (selectedTileIndex.value == null) {
    selectedTileIndex.value = index;
  } else {
    int prev = selectedTileIndex.value!;
    if (_areAdjacent(index, prev)) {
      swap(prev, index);
    }
    selectedTileIndex.value = null; // reset selection
  }
}

bool _areAdjacent(int i1, int i2) {
  int row1 = i1 ~/ gridSize, col1 = i1 % gridSize;
  int row2 = i2 ~/ gridSize, col2 = i2 % gridSize;
  return (row1 == row2 && (col1 - col2).abs() == 1) ||
         (col1 == col2 && (row1 - row2).abs() == 1);
}
  void generateBoard() {
    tiles.clear();
    score.value = 0; // ✅ Reset score
    final rand = Random();
    for (int i = 0; i < gridSize * gridSize; i++) {
      tiles.add(TileModel(
        emoji: emojis[rand.nextInt(emojis.length)],
        id: i,
      ));
    }
  }
void swap(int index1, int index2) async {
  final temp = tiles[index1].emoji;
  tiles[index1].emoji = tiles[index2].emoji;
  tiles[index2].emoji = temp;
  tiles.refresh();

  // Check if they are the same fruit (valid match)
  bool isSameEmoji = tiles[index1].emoji == tiles[index2].emoji;
  bool matched = await checkSwapForMatch(index1, index2);

  if (matched && isSameEmoji) {
    await handleMatchAt([index1, index2]);
  } else {
    await Future.delayed(Duration(milliseconds: 200));
    // Revert if not a match
    tiles[index1].emoji = tiles[index2].emoji;
    tiles[index2].emoji = temp;
    tiles.refresh();

    // ❌ Wrong match -5
    score.value = (score.value - 5).clamp(0, 9999);
    matchStatus.value = 'Wrong! -5';

    // 💀 Game Over
    if (score.value == 0) {
      matchStatus.value = 'Game Over 💀';
    }
  }
}


  Future<void> handleMatchAt(List<int> indices) async {
    bool matched = false;

    for (int i in indices) {
      int row = i ~/ gridSize;
      int col = i % gridSize;

      if (col < gridSize - 1 && tiles[i].emoji == tiles[i + 1].emoji) {
        tiles[i].isMatched = true;
        tiles[i + 1].isMatched = true;
        matched = true;
      }
      if (col > 0 && tiles[i].emoji == tiles[i - 1].emoji) {
        tiles[i].isMatched = true;
        tiles[i - 1].isMatched = true;
        matched = true;
      }
      if (row < gridSize - 1 && tiles[i].emoji == tiles[i + gridSize].emoji) {
        tiles[i].isMatched = true;
        tiles[i + gridSize].isMatched = true;
        matched = true;
      }
      if (row > 0 && tiles[i].emoji == tiles[i - gridSize].emoji) {
        tiles[i].isMatched = true;
        tiles[i - gridSize].isMatched = true;
        matched = true;
      }
    }

    if (matched) {
      tiles.refresh();
      matchStatus.value = matchMessages[Random().nextInt(matchMessages.length)];
      await Future.delayed(Duration(milliseconds: 300));

      for (var tile in tiles) {
        if (tile.isMatched) {
          tile.emoji = randomEmoji();
          tile.isMatched = false;
          matchedTiles++;
          score.value += 10; // ✅ Add 10 points per match
        }
      }

      tiles.refresh();
    } else {
      matchStatus.value = '';
    }
  }

  Future<bool> checkSwapForMatch(int i1, int i2) async {
    int gridSize = this.gridSize;
    List<int> toCheck = [i1, i2];

    for (int i in toCheck) {
      int row = i ~/ gridSize;
      int col = i % gridSize;
      String emoji = tiles[i].emoji;

      if (col < gridSize - 1 && tiles[i + 1].emoji == emoji) return true;
      if (col > 0 && tiles[i - 1].emoji == emoji) return true;
      if (row < gridSize - 1 && tiles[i + gridSize].emoji == emoji) return true;
      if (row > 0 && tiles[i - gridSize].emoji == emoji) return true;
    }

    return false;
  }

  String randomEmoji() {
    return emojis[Random().nextInt(emojis.length)];
  }
}
