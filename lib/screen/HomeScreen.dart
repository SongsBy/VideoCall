import 'package:flutter/material.dart';
import 'package:videocall/screen/call_Screen.dart';

class Homescreen extends StatelessWidget {
  const Homescreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[100],
      body: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            SizedBox(height: 100),
            _Top(),
            _Middle(),
            _Bottom()
          ],
        ),
      ),
    );
  }
}
class _Top extends StatelessWidget {
  const _Top({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 170,
      height: 170,
      child: Image.asset('assets/img/logo.png',fit: BoxFit.fill,),
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: Colors.red,
                blurRadius:150,
                spreadRadius: 10
            )
          ]
      ),
    );
  }
}
class _Middle extends StatelessWidget {
  const _Middle({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Image.asset(
        'assets/img/home_img.png',
      ),
    );
  }
}
class _Bottom extends StatelessWidget {
  const _Bottom({
    super.key,
});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          onPressed: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (_) => CallScreen()));
          },
          child: Text('입장하기'),
        ),
      ),
    );
  }
}


