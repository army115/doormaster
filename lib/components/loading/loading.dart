import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:doormster/components/alertDialog/alert_dialog_onebutton_subtext.dart';
import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black38,
      body: Center(
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(10)),
          width: 150,
          height: 150,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  color: Theme.of(context).primaryColor,
                ),
                SizedBox(
                  height: 15,
                ),
                Text('Loading...')
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Load extends StatefulWidget {
  Load({
    Key? key,
  });

  @override
  State<Load> createState() => _LoadState();
}

class _LoadState extends State<Load> {
  @override
  void initState() {
    super.initState();
    // Timer.run(() => showDialogLoading());
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      showDialogLoading();
    });
    // Future.delayed(Duration.zero, () => showDialogLoading());
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> showDialogLoading() async {
    return showDialog(
      barrierColor: Colors.black38,
      context: context,
      builder: (BuildContext context) {
        return Center(
            child: Container(
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(10)),
          width: 150,
          height: 150,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  color: Theme.of(context).primaryColor,
                ),
                SizedBox(
                  height: 15,
                ),
                Text('Loading...')
              ],
            ),
          ),
        ));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
