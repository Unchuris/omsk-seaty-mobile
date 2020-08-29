import 'package:flutter/material.dart';

import 'list_provider.dart';

class DialogWithChild extends StatelessWidget {
  final String title;
  final Widget child;
  final String buttonText;
  final DialogButtonType buttonType;
  final Function onTap;
  DialogWithChild(
      {this.title, this.child, this.buttonText, this.buttonType, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 10,
      backgroundColor: Theme.of(context).backgroundColor,
      child: _dialogContent(context),
    );
  }

  Widget _dialogContent(BuildContext context) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
              padding: EdgeInsets.only(top: 16, bottom: 16),
              child: _createTitle(context)),
          child,
          _createBottomButton(context)
        ],
      ),
    );
  }

  Widget _createTitle(BuildContext context) {
    return Container(
        width: double.infinity,
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headline4,
        ));
  }

  Widget _createBottomButton(BuildContext context) {
    const bottomBorder = BorderRadius.vertical(bottom: Radius.circular(10));

    return SizedBox(
      width: double.infinity,
      height: 50,
      child: Center(
        child: Stack(
          children: <Widget>[
            SizedBox(height: 50),
            Container(
                decoration: BoxDecoration(
                    color: Colors.orange, borderRadius: bottomBorder)),
            Center(
                child: Text(buttonText,
                    style: TextStyle(fontSize: 18, color: Colors.white))),
            SizedBox.expand(
                child: Material(
                    type: MaterialType.transparency,
                    child: InkWell(borderRadius: bottomBorder, onTap: onTap))),
          ],
        ),
      ),
    );
  }
}

enum DialogButtonType { LIST, COMPLAIN, CLOSE }
