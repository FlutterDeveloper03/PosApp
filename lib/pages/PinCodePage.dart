// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:pos_app/bloc/AuthBloc.dart';
import 'package:pos_app/helpers/localization.dart';
import 'package:pos_app/provider/GlobalVarsProvider.dart';
class PinCodePage extends StatelessWidget {
  const PinCodePage({super.key});

  @override
  Widget build(BuildContext context) {
    final trs = AppLocalizations.of(context);
    GlobalVarsProvider globalVarsProvider = Provider.of<GlobalVarsProvider>(context);
    TextEditingController pinController= TextEditingController();
    return PopScope(
        canPop:false,
        onPopInvoked: (didPop) {
          GoRouter.of(context).go('/loginPage');
        },
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: BlocConsumer<AuthBloc,AuthState>(
          listener: (context,state){
            if(state is AuthSuccess){
              globalVarsProvider.setUser=state.user;
              if(state.posType==1){
                GoRouter.of(context).go('/marketHome');
              }
              else{
                GoRouter.of(context).go('/restoHome');
              }
            }
        },
          builder: (context,state){
            if(state is AuthFailure){
              return Center(
                child: Column(
                  children: [
                    Text("${trs.translate("error_text") ?? "Error"}: ${state.errorStatus}"),
                    TextButton(
                        onPressed: () => context.read<AuthBloc>().logOut(),
                        child: Text(trs.translate('try_again')??"Try again"))
                  ],
                ),
              );
            }
            else if(state is AuthInProgress){
              return const Center(child: CircularProgressIndicator());
            }
            else if(state is AuthInitial){
              return Center(
                child: Padding(
                  padding: (MediaQuery.of(context).orientation==Orientation.portrait)? const EdgeInsets.only(right:10.0,left:10) :const EdgeInsets.only(right:25.0,left:25.0),
                  child: Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    color: Theme.of(context).primaryColor,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text("PIN CODE",style:Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize:20)),
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: TextFormField(
                              obscureText: true,
                              obscuringCharacter: "*",
                              controller: pinController,
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(20),
                              ],
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Theme.of(context).scaffoldBackgroundColor,
                                border: const UnderlineInputBorder(
                                  borderSide: BorderSide(width: 2.0),
                                ),
                                enabledBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(width: 2.0),
                                ),
                                focusedBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(width: 2.0),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width/4,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Theme.of(context).cardColor,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16)
                                  )),
                              onPressed: () {},
                              child: Text(
                                trs.translate("login")??"Login",
                                style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Theme.of(context).colorScheme.secondaryContainer),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
      }

        ),
      ),
    );
  }
}
