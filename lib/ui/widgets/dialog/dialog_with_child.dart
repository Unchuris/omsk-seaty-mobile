import 'package:flutter/material.dart';

import 'list_provider.dart';

class DialogWithChild extends StatelessWidget {
  final String title;
  final Widget child;
  final String buttonText;
  final DialogButtonType buttonType;

  DialogWithChild({this.title, this.child, this.buttonText, this.buttonType});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 10,
      backgroundColor: Theme.of(context).primaryColor,
      child: _dialogContent(context),
    );
  }

  Widget _dialogContent(BuildContext context) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 10),
          _createTitle(),
          SizedBox(height: 10),
          child,
          _createBottomButton(context)
        ],
      ),
    );
  }

  Widget _createTitle() {
    return Container(
        width: 210,
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20),
        ));
  }

  Widget _createBottomButton(BuildContext context) {
    const bottomBorder = BorderRadius.vertical(bottom: Radius.circular(10));

    return SizedBox(
      width: 280,
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
                    child: InkWell(
                        borderRadius: bottomBorder,
                        onTap: () {
                          switch (buttonType) {
                            case DialogButtonType.list:
                              {
                                var provider = ListProvider.of(context);
                                print('List: ${provider.list}');
                              }
                              break;
                            case DialogButtonType.complain:
                              {
                                print('complain');
                              }
                              break;
                            case DialogButtonType.close:
                              {
                                print('close');
                              }
                              break;
                            default:
                              {
                                print('Wrong choise');
                              }
                              break;
                          }
                        }))),
          ],
        ),
      ),
    );
  }
}

enum DialogButtonType { list, complain, close }
