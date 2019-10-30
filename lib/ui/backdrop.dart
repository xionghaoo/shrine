import 'package:flutter/material.dart';
import 'package:shrine/model/product.dart';
import 'package:shrine/ui/login.dart';

class Backdrop extends StatefulWidget {
  final Category currentCategory;
  final Widget frontLayer;
  final Widget backLayer;
  final Widget frontTitle;
  final Widget backTitle;

  const Backdrop({
    @required this.currentCategory,
    @required this.frontLayer,
    @required this.backLayer,
    @required this.frontTitle,
    @required this.backTitle
  }): assert(currentCategory != null),
      assert(frontLayer != null),
      assert(backLayer != null),
      assert(frontTitle != null),
      assert(backTitle != null);

  @override
  _BackdropState createState() => _BackdropState();
}

const double _kFlingVelocity = 2.0;

class _BackdropState extends State<Backdrop> with SingleTickerProviderStateMixin {

  final GlobalKey _backdropKey = GlobalKey(debugLabel: 'Backdrop');

  AnimationController _animationController;

  bool get _frontLayerVisible {
    final status = _animationController.status;
    return status == AnimationStatus.completed || status == AnimationStatus.forward;
  }

  void _toggleBackdropLayerVisibility() {
    print('_frontLayerVisible: $_frontLayerVisible');
    _animationController.fling(
      // If velocity is positive, the animation will complete, otherwise it will dismiss.
      velocity: _frontLayerVisible ? -_kFlingVelocity : _kFlingVelocity
    );
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(microseconds: 300),
      value: 1.0,
      vsync: this
    );
  }


  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }


  @override
  void didUpdateWidget(Backdrop oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.currentCategory != widget.currentCategory) {
      _toggleBackdropLayerVisibility();
    } else if (!_frontLayerVisible) {
      _animationController.fling(velocity: _kFlingVelocity);
    }
  }

  Widget _buildStack(BuildContext context, BoxConstraints constraints) {
    const double layerTitleHeight = 48.0;
    final Size layerSize = constraints.biggest;
    final double layerTop = layerSize.height - layerTitleHeight;

    Animation<RelativeRect> layerAnimation = RelativeRectTween(
      begin: RelativeRect.fromLTRB(0.0, layerTop, 0.0, layerTop - layerSize.height),
      end: RelativeRect.fromLTRB(0.0, 0.0, 0.0, 0.0)
    ).animate(_animationController.view);

    return Stack(
      key: _backdropKey,
      children: <Widget>[
        ExcludeSemantics(
          child: widget.backLayer,
          excluding: _frontLayerVisible,
        ),
        PositionedTransition(
          rect: layerAnimation,
          child: _FrontLayer(child: widget.frontLayer),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var appbar = AppBar(
      brightness: Brightness.light,
      elevation: 0.0,
      titleSpacing: 0.0,
      title: _BackdropTitle(
          listenable: _animationController.view,
          onPress: () {_toggleBackdropLayerVisibility();},
          frontTitle: widget.frontTitle,
          backTitle: widget.backTitle
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.search,
            semanticLabel: 'login',
          ),
          onPressed: () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
          },
        ),
        IconButton(
          icon: Icon(
            Icons.tune,
            semanticLabel: 'filter',
          ),
          onPressed: () {},
        )
      ],
    );
    return Scaffold(
      appBar: appbar,
      body: LayoutBuilder(builder: _buildStack),
    );
  }
}

class _FrontLayer extends StatelessWidget {

  const _FrontLayer({
    Key key,
    this.child
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 16.0,
      shape: BeveledRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(46.0))
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: child,
          )
        ],
      ),
    );
  }
}



class _BackdropTitle extends AnimatedWidget {

  final Function onPress;
  final Widget frontTitle;
  final Widget backTitle;

  const _BackdropTitle({
    Key key,
    Listenable listenable,
    this.onPress,
    @required this.frontTitle,
    @required this.backTitle
  }) : assert(frontTitle != null),
        assert(backTitle != null),
        super(key: key, listenable: listenable);

  @override
  Widget build(BuildContext context) {
    final Animation<double> animation = this.listenable;
    return DefaultTextStyle(
      style: Theme.of(context).primaryTextTheme.title,
      softWrap: false,
      overflow: TextOverflow.ellipsis,
      child: Row(children: <Widget>[
        SizedBox(
          width: 72.0,
          child: IconButton(
            padding: EdgeInsets.only(right: 8.0),
            onPressed: this.onPress,
            icon: Stack(children: <Widget>[
              Opacity(
                opacity: animation.value,
                child: ImageIcon(AssetImage('assets/slanted_menu.png')),
              ),
              FractionalTranslation(
                // Tween Transition没有应用到具体的属性上，通过FractionalTranslation包装，应用到ImageIcon对象
                translation: Tween<Offset>(
                  begin: Offset.zero,
                  end: Offset(1.0, 0.0)
                ).evaluate(animation),
                child: ImageIcon(AssetImage('assets/diamond.png')),
              )
            ]),
          )
        ),
        Stack(
          children: <Widget>[
            Opacity(
              opacity: CurvedAnimation(
                parent: ReverseAnimation(animation),
                curve: Interval(0.5, 1.0)
              ).value,
              child: FractionalTranslation(
                // 消失时向右滑动，出现反之
                translation: Tween<Offset>(
                  begin: Offset.zero,
                  end: Offset(0.5, 0.0)
                ).evaluate(animation),
                child: backTitle,
              ),
            ),
            Opacity(
              opacity: CurvedAnimation(
                parent: animation,
                curve: Interval(0.5, 1.0)
              ).value,
              child: FractionalTranslation(
                // 出现时向右滑动，出现反之
                translation: Tween<Offset>(
                  begin: Offset(-0.25, 0.0),
                  end: Offset.zero
                ).evaluate(animation),
                child: frontTitle,
              ),
            )
          ],
        )
      ]),
    );
  }
}
