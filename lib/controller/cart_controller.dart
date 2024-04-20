// import 'package:get/get.dart';
// import '../model/db_helper.dart';
//
// class FavoritePageController extends GetxController {
//   RxList<String> favoriteQuotes = <String>[].obs; // Use RxList
//
//   @override
//   void onInit() {
//     super.onInit();
//     fetchFavoriteQuotes();
//   }
//
//   Future<void> fetchFavoriteQuotes() async {
//     DbHelper dbHelper = DbHelper();
//     await dbHelper.initDb();
//     List<Map<String, dynamic>> quotesData = await dbHelper.GetProduct();
//     favoriteQuotes.assignAll(quotesData.map((quote) => quote['Product'] ));
//   }
//
//   Future<void> removeFromFavorites(String quote) async {
//     DbHelper dbHelper = DbHelper();
//     await dbHelper.initDb();
//     // await dbHelper.deleteData(quote);
//     await fetchFavoriteQuotes();
//   }
// }
// //





import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';


import '../model/db_helper.dart';

class HomeController extends GetxController {
  RxList<Map<String, String>> recipelist = <Map<String, String>>[].obs;

  @override // Add @override annotation
  void onInit() {
    super.onInit();
    fetchrecipe();
  }

  Future<void> fetchrecipe() async {
    DbHelper helper = DbHelper();
    await helper.initDb();
    List<Map<String, dynamic>> recipe = await helper.GetProduct();
    recipelist.assignAll(
      recipe.map(
            (e) {
          return {
            'name': e['name'].toString(),
            'description': e['description'].toString(),
            'image': e['image'].toString()
          };
        },
      ),
    );
    recipelist.refresh();
  }
  Future<void> removeFromFavorites(String quote) async {
    DbHelper dbHelper = DbHelper();
    await dbHelper.initDb();
    await dbHelper.deleteData(quote);
    await fetchrecipe();
  }
}
