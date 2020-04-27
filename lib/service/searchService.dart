import 'package:client_bos_final/common/globals.dart';
import 'package:client_bos_final/common/removeAccent.dart';
import 'package:client_bos_final/model/data.dart';
import 'package:client_bos_final/screens/product/products.dart';
import 'package:client_bos_final/screens/product/showProduct.dart';

Future<List<Data>> search(String query) async {
  try {
    var _categories = await getAllCategories();
    var _products = await getAllProducts();
    var _shops = await getShops();

    List<Data> _datas = [];

    for (var item in _shops) {
      if (removeDiacritics(item.name)
              .toLowerCase()
              .contains(removeDiacritics(query).toLowerCase()) ||
          removeDiacritics(item.description)
              .toLowerCase()
              .contains(removeDiacritics(query).toLowerCase())) {
        _datas.add(Data(
            title: item.name,
            description: item.description,
            parent: 'Boutiques',
            photo: item.photo,
            redirection: ProductsPage(
              shop: item,
            )));
      }
    }

    for (var item in _categories) {
      if (removeDiacritics(item.name)
              .toLowerCase()
              .contains(removeDiacritics(query).toLowerCase()) ||
          removeDiacritics(item.description)
              .toLowerCase()
              .contains(removeDiacritics(query).toLowerCase())) {
        _datas.add(Data(
            title: item.name,
            description: item.description,
            parent: 'Categories',
            photo: item.photo,
            redirection: ProductsPage(
              category: item,
            )));
      }
    }
    
    for (var item in _products) {
      if (removeDiacritics(item.name)
              .toLowerCase()
              .contains(removeDiacritics(query).toLowerCase()) ||
          removeDiacritics(item.description)
              .toLowerCase()
              .contains(removeDiacritics(query).toLowerCase()) ||
          item.oldPrice == query ||
          item.newPrice == query) {
        _datas.add(Data(
            title: item.name,
            description: item.description,
            parent: 'Produits',
            oldPrice: item.oldPrice,
            newPrice: item.newPrice,
            details: item.shopName,
            photo: item.photo,
            redirection: ShowProductPage(code: item.code)));
      }
    }

    return _datas;
  } catch (e) {
    throw Error();
  }
}
