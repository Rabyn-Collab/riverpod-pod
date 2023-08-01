import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:pod/constants/colors.dart';
import 'package:pod/constants/gap.dart';
import 'package:pod/providers/mode.dart';


class SignUpPage extends StatelessWidget {


  final mailController = TextEditingController();
  final nameController = TextEditingController();
  final passController = TextEditingController();

  final _form = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('SignUp Page'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(15),
          child: Consumer(
              builder: (context, ref, child) {
                final mode = ref.watch(modeProvider);
                return Form(
                  autovalidateMode: mode,
                  key: _form,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 50,),
                      TextFormField(
                        controller: nameController,
                        textInputAction: TextInputAction.next,
                        style: TextStyle(color: Colours.whiteColor),
                        validator: (val) {
                          if (val!.isEmpty) {
                            return 'please provide fullname';
                          } else if (val.length < 5) {
                            return 'must be greater than 5';
                          } else if (val.length > 30) {
                            return 'must be less than 30';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            hintText: 'Full Name',
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 15),
                            prefixIcon: Icon(Icons.lock),
                            errorStyle: TextStyle(color: Colors.amber)
                        ),
                      ),
                      Sizes.gapH16,
                      TextFormField(
                        style: TextStyle(color: Colours.whiteColor),
                        controller: mailController,
                        textInputAction: TextInputAction.next,
                        validator: (val) {
                          if (val!.isEmpty) {
                            return 'please provide email';
                          } else if (!RegExp(
                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(val)) {
                            return 'please provide valid email';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            hintText: 'email',
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 15),
                            prefixIcon: Icon(Icons.email),
                            errorStyle: TextStyle(color: Colors.amber)
                        ),
                      ),
                      Sizes.gapH16,
                      TextFormField(
                        obscureText: true,
                        controller: passController,
                        style: TextStyle(color: Colours.whiteColor),
                        validator: (val) {
                          if (val!.isEmpty) {
                            return 'please provide password';
                          } else if (val.length < 5) {
                            return 'must be greater than 5';
                          } else if (val.length > 20) {
                            return 'must be less than 20';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            hintText: 'password',
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 15),
                            prefixIcon: Icon(Icons.lock),
                            errorStyle: TextStyle(color: Colors.amber)
                        ),
                      ),
                      Sizes.gapH20,
                      Sizes.gapH20,
                      ElevatedButton(
                          onPressed: () {
                            _form.currentState!.save();
                            if (_form.currentState!.validate()) {
                            } else {
                              ref.read(modeProvider.notifier).changeMode();

                            }
                          }, child: Text('SignUp')
                      ),
                      Sizes.gapH10,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Already have an Account ?'),
                          TextButton(onPressed: (){
                            Get.back();
                          }, child: Text('Login'))
                        ],
                      )
                    ],
                  ),
                );
              }
          ),
        )
    );
  }
}
