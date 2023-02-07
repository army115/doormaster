import 'package:doormster/components/alertDialog/alert_dialog_onebutton_subtext.dart';
import 'package:doormster/components/snackbar/snackbar.dart';
import 'package:doormster/models/get_company.dart';
import 'package:doormster/models/regis_response.dart';
import 'package:doormster/service/connect_api.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class Add_Company extends StatefulWidget {
  const Add_Company({Key? key});

  @override
  State<Add_Company> createState() => _Add_CompanyState();
}

class _Add_CompanyState extends State<Add_Company> {
  final _formkey = GlobalKey<FormState>();
  TextEditingController username = TextEditingController();
  TextEditingController fname = TextEditingController();
  TextEditingController lname = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController passwordCon = TextEditingController();

  bool Checked = false;
  bool loading = false;
  bool redEye = true;
  bool redEyeCon = true;
  List<Data> listCompany = [];
  Future _getCompany() async {
    try {
      setState(() {
        loading = true;
      });
      var url = '${Connect_api().domain}/getcompanyactive';
      var response = await http.get(Uri.parse(url), headers: {
        'Connect-type': 'application/json',
        'Accept': 'application/json',
      });

      if (response.statusCode == 200) {
        getCompany company =
            getCompany.fromJson(convert.jsonDecode(response.body));
        setState(() {
          listCompany = company.data!;
          loading = false;
        });
      }
    } catch (error) {
      print(error);
      dialogOnebutton_Subtitle(
        context,
        'พบข้อผิดพลาด',
        'ไม่สามารถเชื่อมต่อได้',
        Icons.warning_amber_rounded,
        Colors.orange,
        'ตกลง',
        () {
          Navigator.popUntil(context, (route) => route.isFirst);
        },
      );
      setState(() {
        loading = false;
      });
    }
  }

  Future _register(Map<String, dynamic> values) async {
    try {
      setState(() {
        loading = true;
      });
      var url = '${Connect_api().domain}/registermobile';
      var response = await http.post(Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          body: convert.jsonEncode(values));
      var jsonRes = RegisResponse.fromJson(convert.jsonDecode(response.body));
      if (jsonRes.status == 200) {
        print('Register Success');
        print(values);
        print(jsonRes.status);
        // Navigator.of(context).pushAndRemoveUntil(
        //     MaterialPageRoute(builder: (BuildContext context) => Login_Page()),
        //     (Route<dynamic> route) => false);
        setState(() {
          loading = false;
        });
        snackbar(context, Theme.of(context).primaryColor, 'ลงทะเบียนสำเร็จ',
            Icons.check_circle_outline_rounded);
      } else {
        dialogOnebutton_Subtitle(
          context,
          'ลงทะเบียนไม่สำเร็จ',
          '${jsonRes.result}',
          Icons.highlight_off_rounded,
          Colors.red,
          'ตกลง',
          () {
            Navigator.of(context).pop();
          },
        );
        print('Register not Success!!');
        print(response.body);
        setState(() {
          loading = false;
        });
      }
    } catch (error) {
      print(error);
      dialogOnebutton_Subtitle(
        context,
        'พบข้อผิดพลาด',
        'ไม่สามารถเชื่อมต่อได้ กรุณาลองใหม่อีกครั้ง',
        Icons.warning_amber_rounded,
        Colors.orange,
        'ตกลง',
        () {
          Navigator.of(context).pop();
        },
      );
      // snackbar(context, Colors.orange, 'กรุณาเชื่อมต่ออินเตอร์เน็ต',
      //     Icons.warning_amber_rounded);
      setState(() {
        loading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getCompany();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('เพิ่มโครงการใหม่')),
    );
  }
}
