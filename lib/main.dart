import 'package:flutter/material.dart';
import 'package:flutter_chess_board/src/chess_board.dart';
import 'package:flutter_chess_board/src/chess_board_controller.dart' as cbc;

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Xadrez Turbo',
      theme: new ThemeData(
        primarySwatch: Colors.brown,
      ),
      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  var chessBoardController = new cbc.ChessBoardController();
  Future<bool> resetBool;
  bool pressed = false;
  bool first = true;
  bool game = false;
  String msgResetGame;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[100],
      appBar: AppBar(
        title: const Text("Xadrez Turbo"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FlatButton(
              color: Colors.brown,
              textColor: Colors.white,
              onPressed: () {
                if (first == true) {
                  setState(() {
                    pressed = true;
                  });
                  first = false;
                  game = true;
                } else {
                  if (game == true) {
                    msgResetGame = "Deseja reiniciar o jogo?";
                  } else {
                    msgResetGame = "Deseja iniciar um novo jogo?";
                  }
                  resetBool = resetGameDialog(context, msgResetGame).then((resetBool) {
                    if (resetBool == true) {
                      chessBoardController.resetBoard();
                      game = true;
                    }
                  });
                }
              },
              child: Text(
                "Novo Jogo",
              ),
            ),
            pressed == true ? ChessBoard(
              chessBoardController: chessBoardController,
              boardType: BoardType.brown,
              whiteSideTowardsUser: true,
              onMove: (move) {
                //print(move);
              },
              onCheckMate: (color) {
                if (game == true) {
                  checkMateDialog(context, color);
                  game = false;
                }
              },
              onDraw: () {
                if (game == true) {
                  DrawDialog(context);
                  game = false;
                }
              },
              size: MediaQuery.of(context).size.width,
              enableUserMoves: true,
            ) : SizedBox()
          ],
        ),
      ),
    );
  }
}

Future<bool> resetGameDialog(BuildContext context, String msgResetGame) {
  return showDialog<bool>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text(msgResetGame),
          actions: <Widget>[
            new FlatButton(
              child: const Text('Sim'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
            new FlatButton(
              child: const Text('Não'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
          ],
        );
      });
}

Future<bool> checkMateDialog(BuildContext context, color) {

  String colorS;

  if (color == cbc.PieceColor.Black) {
    colorS = "Brancas";
  } else {
    colorS = "Negras";
  }

  return showDialog<bool>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text('Check Mate! ' + colorS.toString() + ' vencem!'),
          actions: <Widget>[
            new FlatButton(
              child: const Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      });
}

Future<bool> DrawDialog(BuildContext context) {
  return showDialog<bool>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text('Empate!'),
          actions: <Widget>[
            new FlatButton(
              child: const Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      });
}