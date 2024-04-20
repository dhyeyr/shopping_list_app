import 'package:get/get.dart';
import '../model/db_helper.dart';

class FavoritePageController extends GetxController {
  RxList<String> favoriteQuotes = <String>[].obs; // Use RxList

  @override
  void onInit() {
    super.onInit();
    fetchFavoriteQuotes();
  }

  Future<void> fetchFavoriteQuotes() async {
    DbHelper dbHelper = DbHelper();
    await dbHelper.initDb();
    List<Map<String, dynamic>> quotesData = await dbHelper.getData();
    favoriteQuotes.assignAll(quotesData.map((quote) => quote['content'] as String));
  }

  Future<void> removeFromFavorites(String quote) async {
    DbHelper dbHelper = DbHelper();
    await dbHelper.initDb();
    await dbHelper.deleteData(quote);
    await fetchFavoriteQuotes();
  }
}
