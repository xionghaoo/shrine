import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shrine/test_animation.dart';
import 'package:shrine/theme/colors.dart';
import 'package:shrine/ui/home.dart';

class LoginPage extends StatefulWidget {

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        // list view children默认居中排列
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 24),
          children: <Widget>[
            SizedBox(height: 80),
            Column(
              children: <Widget>[
                Image.asset('assets/diamond.png'),
                SizedBox(height: 16),
                Text('SHRINE')
              ],
            ),
            SizedBox(height: 120),
            AccentColorOverride(
              color: kShrineBrown900,
              child: TextField(
                decoration: InputDecoration(
//                filled: true,
                    labelText: 'Username'
                ),
              ),
            ),
            SizedBox(height: 12),
            AccentColorOverride(
              color: kShrineBrown900,
              child: TextField(
                  decoration: InputDecoration(
//                filled: true,
                      labelText: 'Password'
                  )
              ),
            ),
            ButtonBar(
              children: <Widget>[
                FlatButton(
                  child: Text('CANCEL'),
                  shape: BeveledRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(7.0))
                  ),
                  onPressed: () {},
                ),
                RaisedButton(
                  child: Text('LOGIN'),
                  elevation: 0.0,
                  shape: BeveledRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(7.0))
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
                  },
                )
              ],
            ),
            // 测试页面
            Padding(
              padding: EdgeInsets.only(top: 20),
              child: RaisedButton(
                child: Text('测试'),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => TestAnimPage()));
                },
              ),
            )
          ],
        )
      ),
    );
  }
}

// 重写accent color
class AccentColorOverride extends StatelessWidget {
  const AccentColorOverride({Key key, this.color, this.child}) : super(key: key);

  final Color color;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Theme(
      child: child,
      data: Theme.of(context).copyWith(
        accentColor: color,
        brightness: Brightness.dark
      ),
    );
  }


}