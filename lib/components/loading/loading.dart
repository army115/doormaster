import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class Loading extends StatefulWidget {
  Loading({
    Key? key,
  });

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  @override
  void initState() {
    super.initState();
    configLoading();
    showDialogLoading();
  }

  @override
  void dispose() {
    EasyLoading.dismiss();
    super.dispose();
  }

  void configLoading() {
    EasyLoading.instance
      ..textAlign = TextAlign.center
      ..loadingStyle = EasyLoadingStyle.light
      ..contentPadding = EdgeInsets.fromLTRB(25, 25, 25, 20)
      ..fontSize = 16
      ..textStyle = TextStyle(height: 2)
      ..radius = 10.0;
  }

  Future<void> showDialogLoading() async {
    EasyLoading.show(
      dismissOnTap: false,
      status: 'Loading...',
      maskType: EasyLoadingMaskType.black,
      indicator: CircularProgressIndicator(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

// class Loading extends StatelessWidget {
//   const Loading({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black38,
//       body: Center(
//         child: Container(
//           decoration: BoxDecoration(
//               color: Colors.white, borderRadius: BorderRadius.circular(10)),
//           width: 150,
//           height: 150,
//           child: Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 CircularProgressIndicator(
//                   color: Theme.of(context).primaryColor,
//                 ),
//                 SizedBox(
//                   height: 15,
//                 ),
//                 Text('Loading...')
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }


