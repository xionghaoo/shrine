import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shrine/model/product.dart';
import 'package:shrine/model/products_repository.dart';
import 'package:shrine/supplemental/asymmetric_view.dart';
import 'package:shrine/theme/colors.dart';
import 'package:shrine/ui/backdrop.dart';
import 'package:shrine/ui/category_menu_page.dart';

class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<Card> _buildCards(int count) {
    List<Product> products = ProductsRepository.loadProducts(Category.all);
    if (products == null || products.isEmpty) {
      return <Card>[];
    }

    final ThemeData theme = Theme.of(context);
    final NumberFormat formatter = NumberFormat.simpleCurrency(
        locale: Localizations.localeOf(context).toString());
    return products.map((product) => Card(
      clipBehavior: Clip.antiAlias,
      elevation: 0.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          AspectRatio(
            aspectRatio: 18.0/11.0,
            child: Image.asset(
              product.assetName,
              package: product.assetPackage,
              fit: BoxFit.fitWidth,
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text(
                  product.name,
                  style: theme.textTheme.title,
                  softWrap: false,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                SizedBox(height: 4.0),
                Text(
                  formatter.format(product.price),
                  style: theme.textTheme.caption,
                )
              ],
            ),
          )
        ],
      ),
    )).toList(growable: false);
  }

  Category _currentCategory = Category.all;

  void _onCategoryTap(Category category) {
    setState(() {
      _currentCategory = category;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Backdrop(
      currentCategory: _currentCategory,
      frontLayer: AsymmetricView(products: ProductsRepository.loadProducts(_currentCategory)),
      backLayer: CategoryMenuPage(currentCategory: _currentCategory, onCategoryTop: _onCategoryTap),
      frontTitle: Text('SHRINE'),
      backTitle: Text('MENU'),
    );
  }
}