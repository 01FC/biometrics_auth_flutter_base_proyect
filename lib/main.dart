import 'dart:io';

import 'package:biometric_auth/confidential.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/home_bloc.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      title: 'URL and Image loading',
      home: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text("URL and Image loading"),
        ),
        child: HomePage(),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({
    Key key,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HomeBloc _homeBloc;
  TextEditingController _textController = TextEditingController();

  File _choosenImage;

  @override
  void dispose() {
    _homeBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: BlocProvider(
          create: (context) {
            _homeBloc = HomeBloc();
            return _homeBloc;
          },
          child: BlocListener<HomeBloc, HomeState>(
            listener: (context, state) {
              if (state is AuthenticationFailure) {
                showCupertinoDialog(
                  context: context,
                  builder: (context) => CupertinoAlertDialog(
                    title: Text("Error de autenticacion"),
                    content: Text("${state.message}"),
                    actions: <Widget>[
                      FlatButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text("Aceptar"),
                      ),
                    ],
                  ),
                );
              }
            },
            child: BlocBuilder<HomeBloc, HomeState>(
              builder: (context, state) {
                if (state is AuthenticationDone) {
                  return Center(
                    child: Container(
                      height: 250,
                      width: 250,
                      child: FlareActor(
                        "assets/check.flr",
                        alignment: Alignment.center,
                        fit: BoxFit.contain,
                        animation: "go",
                        callback: (_) async {
                          await Navigator.of(context).push(
                            CupertinoPageRoute(
                              builder: (context) => Confidential(),
                            ),
                          );
                          _homeBloc.add(DoneEvent());
                        },
                      ),
                    ),
                  );
                }
                if (state is LoadedImage) {
                  _choosenImage = state.image;
                  _homeBloc.add(DoneEvent());
                }
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text("Ingresar URL"),
                    SizedBox(height: 12),
                    // search
                    CupertinoTextField(
                      controller: _textController,
                      prefix: Icon(CupertinoIcons.search),
                    ),
                    SizedBox(height: 12),
                    CupertinoButton(child: Text("Ir"), onPressed: () {}),
                    SizedBox(height: 24),
                    // Image
                    _choosenImage == null
                        ? Placeholder(
                            fallbackHeight: 150,
                            fallbackWidth: 150,
                          )
                        : Image.file(
                            _choosenImage,
                            height: 150,
                            fit: BoxFit.cover,
                          ),
                    SizedBox(height: 12),
                    CupertinoButton(
                      child: Text("Cargar imagen"),
                      onPressed: () {
                        _homeBloc.add(LoadImageEvent());
                      },
                    ),
                    SizedBox(height: 48),
                    CupertinoButton(
                      child: Text(
                        "Confidencial",
                        style: TextStyle(
                          color: CupertinoColors.white,
                        ),
                      ),
                      color: CupertinoColors.black,
                      onPressed: () {
                        _homeBloc.add(AuthenticationEvent());
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
