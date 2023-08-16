import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:pod/common_widgets/snack_widget.dart';
import 'package:pod/constants/colors.dart';
import 'package:pod/constants/gap.dart';
import 'package:pod/providers/auth_provider.dart';
import 'package:pod/providers/mode.dart';


class ShippingForm extends ConsumerStatefulWidget {


  @override
  ConsumerState<ShippingForm> createState() => _ShippingFormState();
}

class _ShippingFormState extends ConsumerState<ShippingForm> {
  final addressController = TextEditingController();

  final cityController = TextEditingController();

  final _form = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    ref.listen(authProvider, (previous, next) {
      if(next.isError){
        CommonSnack.errrorSnack(context: context,msg:  next.errText);
      }else if(next.isSuccess){
        Get.back();
        CommonSnack.successSnack(context: context,msg:  'successfully updated');
      }
    });
    final auth = ref.watch(authProvider);
    return Scaffold(
        appBar: AppBar(
          title: Text('Shipping Page'),
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
                        style: TextStyle(color: Colours.whiteColor),
                        controller: addressController,
                        textInputAction: TextInputAction.next,
                        validator: (val) {
                          if (val!.isEmpty) {
                            return 'please provide email';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            hintText: 'Address',
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 15),
                            prefixIcon: Icon(Icons.local_airport_rounded),
                            errorStyle: TextStyle(color: Colors.amber)
                        ),
                      ),
                      Sizes.gapH16,
                      TextFormField(
                        controller: cityController,
                        style: TextStyle(color: Colours.whiteColor),
                        validator: (val) {
                          if (val!.isEmpty) {
                            return 'please provide password';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            hintText: 'City',
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 15),
                            prefixIcon: Icon(Icons.location_city),
                            errorStyle: TextStyle(color: Colors.amber)
                        ),
                      ),
                      Sizes.gapH20,
                      Sizes.gapH20,
                      ElevatedButton(
                          onPressed:auth.isLoad ? null: () {
                            FocusScope.of(context).unfocus();
                            _form.currentState!.save();
                            if (_form.currentState!.validate()) {
                              ref.read(authProvider.notifier).userUpdate(
                                shippingAddress: {
                                  'address': addressController.text.trim(),
                                  'city': cityController.text.trim(),
                                  'isEmpty': false
                                },
                                  token: auth.user!.token,
                              );
                            } else {
                              ref.read(modeProvider.notifier).changeMode();

                            }
                          }, child: auth.isLoad ? Center(child: CircularProgressIndicator()) : Text('Submit')
                      ),
                      Sizes.gapH10,

                    ],
                  ),
                );
              }
          ),
        )
    );
  }
}
