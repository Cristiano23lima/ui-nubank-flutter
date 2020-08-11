import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:nubank/pages/home/widgets/my_app_bar.dart';
import 'package:nubank/pages/home/widgets/my_dots_app.dart';
import 'package:nubank/pages/home/widgets/page_view_app.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _showMenu;
  int _currentIndex;
  double _yPosition;
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this._showMenu = false;
    this._currentIndex = 0;
  }


  @override
  Widget build(BuildContext context) {
    double _screenHeight = MediaQuery.of(context).size.height;

    if(_yPosition == null){
      _yPosition = _screenHeight * 0.24;
    }

    return Scaffold(
      backgroundColor: Colors.purple[800],
      body: Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          MyAppBar(
            showMenu: this._showMenu, 
            onTap: () {
              setState(() {
                this._showMenu = !this._showMenu;
                _yPosition = !this._showMenu ? _screenHeight * 0.75 : _screenHeight * 0.24;
              });
            }),
          PageViewApp(
            showMenu: _showMenu,
            top: _yPosition,
            onChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            onPanUpdate: (details){
              double positionBottomLimit =  _screenHeight * 0.75;
              double positionTopLimit =  _screenHeight * 0.24;
              double midlePosition = positionBottomLimit - positionTopLimit;
              midlePosition /= 2;

              setState(() {
                _yPosition += details.delta.dy;

                _yPosition = _yPosition < positionTopLimit ? positionTopLimit : _yPosition;
                _yPosition = _yPosition > positionBottomLimit ? positionBottomLimit : _yPosition;

                if(_yPosition != positionBottomLimit && details.delta.dy > 0){
                  _yPosition = _yPosition > (midlePosition + positionTopLimit - 50) ? positionBottomLimit : _yPosition;
                }

                if(_yPosition != positionTopLimit && details.delta.dy < 0){
                  _yPosition = _yPosition < (positionBottomLimit - midlePosition) ? positionTopLimit : _yPosition;
                }
                

                if(_yPosition == positionBottomLimit){
                  _showMenu = true;
                } else if(_yPosition == positionTopLimit){
                  _showMenu = false;
                }
              });
            },
          ),
          MyDotsApp(
            top: _screenHeight * 0.70,
            currentIndex: _currentIndex,
          )
        ],
      ),
    );
  }
}