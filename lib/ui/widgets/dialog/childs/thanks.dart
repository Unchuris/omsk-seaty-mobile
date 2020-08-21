import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ThanksChild extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 210,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              height: 94, child: SvgPicture.asset('assets/seaty_logo.svg')),
          SizedBox(height: 10),
          Text(
            'asldhkasasdsadasdasdasdjhd',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Text('asjkdhkalsghdkhgasd'),
              GestureDetector(
                onTap: () {
                  print("I was tapped!");
                },
                child: Text("Hello world"),
              )
            ],
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}
