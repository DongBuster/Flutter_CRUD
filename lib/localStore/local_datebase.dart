import 'package:localstore/localstore.dart';

import '../model/user.dart';

class LocalStoreService {
  Future loadItems() async {
    var db = Localstore.getInstance(useSupportDir: true);
    var mapItems = await db.collection('items').get();
    if (mapItems != null && mapItems.isNotEmpty) {
      var items =
          List<User>.from(mapItems.entries.map((e) => User.fromJson(e.value)));
      return items;
    }
    return null;
  }

  Future addItem(User user) async {
    var db = Localstore.getInstance(useSupportDir: true);
    await db.collection('items').doc(user.id).set(user.toMap());
  }

  Future removeItem(String id) async {
    var db = Localstore.getInstance(useSupportDir: true);
    await db.collection('items').doc(id).delete();
  }

  Future updateItem(User user) async {
    var db = Localstore.getInstance(useSupportDir: true);
    await db
        .collection('items')
        .doc(user.id)
        .set(user.toMap(), SetOptions(merge: true));
  }
}
