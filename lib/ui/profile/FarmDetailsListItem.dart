import 'package:farmsmart_flutter/ui/common/recommendation_detail_listitem/recommendation_detail_listitem.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class _Strings {
  static final String yourName = Intl.message("Your Name");
  static final String country = Intl.message("Country");
  static final String landSize = Intl.message("Land Size");
  static final String season = Intl.message("Season");
  static final String motivation = Intl.message("Motivation");
  static final String soilType = Intl.message("Soil Type");
  static final String farmDetailsTitle = Intl.message("Your Farm Details");
}

class _Constants {
  static final EdgeInsets edgePadding = EdgeInsets.symmetric(
    horizontal: 32,
    vertical: 10,
  );

  static final double wrapSpacing = 5;
  static final double wrapRunSpacing = 5;
  static final double circleSize = 12;
  static final double circleSpacing = 7.5;

  static final int flexHighPriority = 1;
  static final int flexLowPriority = 2;

  static final BorderRadius circleBorderRadius = BorderRadius.all(
    Radius.circular(30),
  );
}

class FarmDetailsListItemViewModel {
  String title;
  String detail;
  Color color;

  FarmDetailsListItemViewModel({
    this.title,
    this.detail,
    this.color,
  });
}

class FarmDetailsListItemStyle {
  final TextStyle titleTextStyle;
  final TextStyle detailTextStyle;
  final int maxLines;

  const FarmDetailsListItemStyle({
    this.titleTextStyle,
    this.detailTextStyle,
    this.maxLines,
  });

  FarmDetailsListItemStyle copyWith({
    TextStyle titleTextStyle,
    TextStyle detailTextStyle,
    int maxLines,
  }) {
    return FarmDetailsListItemStyle(
      titleTextStyle: titleTextStyle ?? this.titleTextStyle,
      detailTextStyle: detailTextStyle ?? this.detailTextStyle,
      maxLines: maxLines ?? this.maxLines,
    );
  }
}

class _DefaultStyle extends FarmDetailsListItemStyle {
  final TextStyle titleTextStyle = const TextStyle(
    color: Color(0xff1a1b46),
    fontSize: 17,
    fontWeight: FontWeight.w400,
  );

  final TextStyle detailTextStyle = const TextStyle(
    color: Color(0xff767690),
    fontSize: 15,
    fontWeight: FontWeight.w400,
  );

  final int maxLines = 1;

  const _DefaultStyle(
      {TextStyle titleTextStyle, TextStyle detailTextStyle, int maxLines});
}

const FarmDetailsListItemStyle _defaultStyle = const _DefaultStyle();

class FarmDetailsListItem extends StatelessWidget {
  final FarmDetailsListItemViewModel _viewModel;
  final FarmDetailsListItemStyle _style;

  const FarmDetailsListItem({
    Key key,
    FarmDetailsListItemViewModel viewModel,
    FarmDetailsListItemStyle style = _defaultStyle,
  })  : this._viewModel = viewModel,
        this._style = style,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: _Constants.edgePadding,
      title: _buildTitle(),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          _viewModel.color != null ? _buildCirclesWrap() : Wrap(),
          SizedBox(width: _Constants.circleSpacing),
          _buildDetail(),
        ],
      ),
    );
  }

  Widget _buildDetail() {
    return Flexible(
      flex: _Constants.flexLowPriority,
      child: Text(
        _viewModel.detail,
        textAlign: TextAlign.right,
        maxLines: _style.maxLines,
        overflow: TextOverflow.ellipsis,
        style: _style.detailTextStyle,
      ),
    );
  }

  Text _buildTitle() {
    return Text(
      _viewModel.title,
      style: _style.titleTextStyle,
    );
  }

  _buildCirclesWrap() {
    return Flexible(
      flex: _Constants.flexHighPriority,
      child: Wrap(
        direction: Axis.vertical,
        verticalDirection: VerticalDirection.down,
        spacing: _Constants.wrapSpacing,
        runSpacing: _Constants.wrapRunSpacing,
        children: <Widget>[
          _buildCircles(_viewModel.color),
        ],
      ),
    );
  }

  Widget _buildCircles(Color color) {
    return Container(
      height: _Constants.circleSize,
      width: _Constants.circleSize,
      decoration: BoxDecoration(
        color: color,
        borderRadius: _Constants.circleBorderRadius,
      ),
    );
  }
}
