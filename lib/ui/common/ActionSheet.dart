import 'package:farmsmart_flutter/ui/common/LargeRoundedButtonStyle.dart';
import 'package:farmsmart_flutter/ui/common/headerAndFooterListView.dart';
import 'package:farmsmart_flutter/ui/common/roundedButton.dart';
import 'package:flutter/material.dart';
import 'listDivider.dart';

class CustomSheetAction {
  String text;
  IconData icon;
  IconData selection;
  bool isHighlighted;
  Function action;

  CustomSheetAction(this.text, this.action, this.isHighlighted, {this.icon, this.selection});
}

class ActionSheetViewModel {
    List<CustomSheetAction> actions;
    String buttonTitle;

    ActionSheetViewModel(this.actions, this.buttonTitle);
}

abstract class ActionSheetStyle {
  final Color cornerColor;
  final Color backgroundColor;
  final Color dropLineColor;
  final Color transparentColor;

  final TextStyle mainTextStyle;
  final TextStyle highlightTextStyle;

  final EdgeInsets cardEdge;
  final EdgeInsets dropLineEdge;

  final Radius borderRadius;
  final Radius dropLineRadius;

  final double dropLineHeight;
  final double cardHeight;
  final double iconLineSpace;
  final double cardElevation;

  final int maxLines;

  ActionSheetStyle(this.cornerColor, this.backgroundColor, this.dropLineColor, this.transparentColor,
      this.mainTextStyle, this.highlightTextStyle, this.cardEdge,
      this.dropLineEdge, this.borderRadius, this.dropLineRadius,
      this.dropLineHeight, this.cardHeight, this.iconLineSpace, this.cardElevation, this.maxLines);


}

class DefaultStyle implements ActionSheetStyle {
  static const Color titleColor = Color(0xFF1a1b46);
  static const Color highlightColor = Color(0xFFff6060);

  final Color cornerColor = const Color(0xFF737373);
  final Color backgroundColor = const Color(0xFFffffff);
  final Color dropLineColor = const Color(0xFFe0e1ee);
  final Color transparentColor = const Color(0x00000000);

  final TextStyle mainTextStyle = const TextStyle(fontSize: 17, fontWeight: FontWeight.normal, color: titleColor);
  final TextStyle highlightTextStyle = const TextStyle(fontSize: 17, fontWeight: FontWeight.normal, color: highlightColor);

  final EdgeInsets cardEdge = const EdgeInsets.only(left: 32, right: 32);
  final EdgeInsets dropLineEdge = const EdgeInsets.only(top: 8);
  
  final Radius borderRadius = const Radius.circular(40);
  final Radius dropLineRadius = const Radius.circular(2.5);

  final double dropLineHeight = 5;
  final double cardHeight = 70;
  final double iconLineSpace = 21.5;
  final double cardElevation = 0;

  final int maxLines = 1;

  const DefaultStyle();
}

class ActionSheet {
  static Widget build(BuildContext context, {ActionSheetStyle actionStyle = const DefaultStyle()}) {

    CustomSheetAction recordSale = CustomSheetAction("Record a new Sale", null, false, icon: Icons.clear);
    CustomSheetAction recordCost = CustomSheetAction("Record a new Cost", null, false, selection:  Icons.style);
    CustomSheetAction testing = CustomSheetAction("Record a test", null, true);
    ActionSheetViewModel viewModel = ActionSheetViewModel([recordSale, recordCost, testing], "Cancel");

    return Container(
      color: actionStyle.cornerColor, // This line set the transparent background
        child: Container(
          padding: actionStyle.dropLineEdge,
          decoration: BoxDecoration(
              color: actionStyle.backgroundColor,
              borderRadius: BorderRadius.only(
                  topLeft: actionStyle.borderRadius,
                  topRight: actionStyle.borderRadius
              )
          ),
          child: HeaderAndFooterListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: viewModel.actions.length,
              itemBuilder: (BuildContext context, int index) =>
            buildActionCell(actionStyle, viewModel.actions[index], viewModel.actions.length, index),
            header: buildDropLine(actionStyle),
            footer: RoundedButton.build(style: LargeRoundedButtonStyle() ,context: context, title: viewModel.buttonTitle)
          )
    ));
  }

  static Widget buildDropLine(ActionSheetStyle actionStyle) {
    return Container(
      height: actionStyle.dropLineHeight,
      margin: EdgeInsets.only(left: 160, right: 160, top: 8, bottom: 50),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(actionStyle.dropLineRadius),
        color: actionStyle.dropLineColor,
      ),
    );
  }

  static Widget buildActionCell(ActionSheetStyle actionStyle, CustomSheetAction action, int numberOfActions, int currentAction) {
    return Column(
      children: <Widget>[
        Card(
          elevation: actionStyle.cardElevation,
          color: actionStyle.transparentColor,
          child: InkWell(
            onTap: () => print(action.text),
            child: Container(
              padding: actionStyle.cardEdge,
              alignment: Alignment.center,
              height: actionStyle.cardHeight,
              child: Row(
                children: _buildActionContent(actionStyle, action),
              ),
            ),
          ),
        ),
        currentAction == numberOfActions-1 ?  Row() : ListDivider.build(),
      ],
    );
  }

  static List<Widget> _buildActionContent(ActionSheetStyle actionStyle, CustomSheetAction action) {
    List<Widget> listBuilder = [];
    if (action.icon != null) {
      listBuilder.add(Icon(action.icon));
      listBuilder.add(SizedBox(width: actionStyle.iconLineSpace));
      listBuilder.add(Text(action.text, style: action.isHighlighted ? actionStyle.highlightTextStyle : actionStyle.mainTextStyle));
    } else if (action.selection != null) {
      listBuilder.add(Text(action.text, style: action.isHighlighted ? actionStyle.highlightTextStyle : actionStyle.mainTextStyle));
      listBuilder.add(SizedBox(width: actionStyle.iconLineSpace));
      listBuilder.add(Icon(action.selection));
    } else {
      listBuilder.add(Text(action.text, style: action.isHighlighted ? actionStyle.highlightTextStyle : actionStyle.mainTextStyle));
    }
    return listBuilder;
  }

}

