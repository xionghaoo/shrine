import 'package:flutter/material.dart';
import 'package:shrine/model/product.dart';
import 'package:shrine/theme/colors.dart';

class CategoryMenuPage extends StatelessWidget {

  final Category currentCategory;
  final ValueChanged<Category> onCategoryTop;
  final List<Category> _categories = Category.values;

  const CategoryMenuPage({
    Key key,
    @required this.currentCategory,
    @required this.onCategoryTop
  }) : assert(currentCategory != null),
        assert(onCategoryTop != null),
        super(key: key);

  Widget _buildCategory(Category category, BuildContext context) {
    final categoryString = category.toString().replaceAll('Category.', '').toUpperCase();
    final ThemeData theme = Theme.of(context);

    return GestureDetector(
      onTap: () => onCategoryTop(category),
      child: category == currentCategory
          ? Column(
              children: <Widget>[
                SizedBox(height: 16.0),
                Text(
                  categoryString,
                  style: theme.textTheme.body2,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 14.0,),
                Container(
                  width: 70.0,
                  height: 2.0,
                  color: kShrinePink400,
                ),
              ],
            )
          : Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                categoryString,
                style: theme.textTheme.body2.copyWith(
                  color: kShrineBrown900.withAlpha(153)
                ),
                textAlign: TextAlign.center,
              ),
            )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.only(top: 40),
        color: kShrinePink100,
        child: ListView(
          children: _categories.map((category) => _buildCategory(category, context)).toList(),
        ),
      ),
    );
  }
}