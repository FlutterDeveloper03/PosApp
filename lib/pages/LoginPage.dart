// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:pos_app/bloc/AuthBloc.dart';
import 'package:pos_app/helpers/localization.dart';
import 'package:pos_app/provider/GlobalVarsProvider.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final trs = AppLocalizations.of(context);
    TextEditingController tecUName = TextEditingController();
    TextEditingController tecUPass = TextEditingController();
    GlobalVarsProvider globalVarsProvider = Provider.of<GlobalVarsProvider>(context);
    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: BlocConsumer<AuthBloc,AuthState>(
          listener:(context,state){
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
          builder:(context,state){
            if(state is AuthFailure){
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("${trs.translate("error_text") ?? "Error"}: ${state.errorStatus}"),
                    TextButton(
                        onPressed: () {
                          context.read<AuthBloc>().logOut();
                        },
                        child: Text(trs.translate('try_again')??"Try again"))
                  ],
                ),
              );
            }
            else if(state is AuthInProgress){
              return const Center(child: CircularProgressIndicator());
            }
            else if(state is AuthInitial){
              return Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color:Theme.of(context).scaffoldBackgroundColor,
                ),
                child: (MediaQuery.of(context).orientation == Orientation.portrait)
                    ? Padding(
                  padding: const EdgeInsets.only(top: 80.0),
                  child: ListView(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
                          Text(trs.translate("login")??"Login", style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 40)),
                          Padding(
                              padding: const EdgeInsets.only(top: 15),
                              child: Text(trs.translate("greeting")?? "Welcome to Sap Pos!", style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 18)))
                        ]),
                      ),
                      Container(
                          decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: const BorderRadius.all(Radius.circular(60))),
                          child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: SingleChildScrollView(
                                child: Column(children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 30.0),
                                    child: Container(
                                        padding: const EdgeInsets.all(20),
                                        decoration: BoxDecoration(
                                            color: Theme.of(context).cardColor,
                                            borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Column(children: [
                                          Container(
                                            decoration: BoxDecoration(
                                                border: Border(bottom: BorderSide(color: Theme.of(context).colorScheme.secondaryContainer))),
                                            child: TextField(
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyLarge!.copyWith(color: Theme.of(context).colorScheme.secondaryContainer),
                                                controller: tecUName,
                                                decoration: InputDecoration(
                                                  hintText: trs.translate(('username'))?? "Username",
                                                  hintStyle: Theme.of(context)
                                                      .textTheme
                                                      .bodyLarge!.copyWith(color: Theme.of(context).colorScheme.secondaryContainer),
                                                  border: InputBorder.none,
                                                )),
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                                border: Border(bottom: BorderSide(color: Theme.of(context).colorScheme.secondaryContainer))),
                                            child: TextField(
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyLarge!.copyWith(color: Theme.of(context).colorScheme.secondaryContainer),
                                                controller: tecUPass,
                                                decoration: InputDecoration(
                                                  hintText: trs.translate(('password'))?? "Password",
                                                  hintStyle: Theme.of(context)
                                                      .textTheme
                                                      .bodyLarge!.copyWith(color: Theme.of(context).colorScheme.secondaryContainer),
                                                  border: InputBorder.none,
                                                )),
                                          )
                                        ])),
                                  ),
                                  Padding(
                                      padding: const EdgeInsets.only(top: 45),
                                      child: TextButton(
                                        child: Text(trs.translate("pin_label")??"Do you want to enter with pin code?", style: Theme.of(context).textTheme.bodyLarge),
                                        onPressed: () {
                                          GoRouter.of(context).go('/pinCodePage');
                                        },
                                      )),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width / 3,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Theme.of(context).cardColor,
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                                      onPressed: () {
                                        context.read<AuthBloc>().login(tecUName.text, tecUPass.text);
                                      },
                                      child: Text(
                                        trs.translate("login")??"Login",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge!.copyWith(color: Theme.of(context).colorScheme.secondaryContainer),
                                      ),
                                    ),
                                  )
                                ]),
                              )))
                    ],
                  ),
                )
                    : Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: ListView(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
                          Text(trs.translate("login")??"Login", style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 40)),
                          Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Text(trs.translate("greeting")?? "Welcome to Sap Pos!", style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 18)))
                        ]),
                      ),
                      Container(
                          decoration: BoxDecoration(
                              color: Theme.of(context).primaryColorLight,
                              borderRadius: const BorderRadius.only(topLeft: Radius.circular(60), topRight: Radius.circular(60))),
                          child: Padding(
                              padding: const EdgeInsets.fromLTRB(20, 5, 20, 0),
                              child: SingleChildScrollView(
                                child: Column(children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10.0),
                                    child: Container(
                                        padding: const EdgeInsets.all(20),
                                        decoration: BoxDecoration(
                                            color: Theme.of(context).primaryColor,
                                            borderRadius: BorderRadius.circular(10),
                                            boxShadow: [
                                              BoxShadow(
                                                  color: Theme.of(context).colorScheme.secondaryContainer,
                                                  blurRadius: 20,
                                                  offset: const Offset(0, 10))
                                            ]),
                                        child: Column(children: [
                                          Container(
                                            decoration: BoxDecoration(
                                                border: Border(bottom: BorderSide(color: Theme.of(context).colorScheme.secondaryContainer))),
                                            child: TextField(
                                                controller: tecUName,
                                                decoration: InputDecoration(
                                                    hintText: trs.translate(('username'))?? "Username",
                                                    hintStyle: Theme.of(context)
                                                        .textTheme
                                                        .bodyLarge,
                                                    border: InputBorder.none,
                                                    enabledBorder: InputBorder.none,
                                                    disabledBorder: InputBorder.none,
                                                    constraints: const BoxConstraints())),
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                                border: Border(bottom: BorderSide(color: Theme.of(context).colorScheme.secondaryContainer))),
                                            child: TextField(
                                                controller: tecUPass,
                                                decoration: InputDecoration(
                                                  hintText: trs.translate(('password'))?? "Password",
                                                  hintStyle: Theme.of(context)
                                                      .textTheme
                                                      .bodyLarge,
                                                  border: InputBorder.none,
                                                )),
                                          )
                                        ])),
                                  ),
                                  Padding(
                                      padding: const EdgeInsets.only(top: 5),
                                      child: TextButton(
                                        child: Text(trs.translate("pin_label")??"Do you want to enter with pin code?", style: Theme.of(context).textTheme.bodyLarge),
                                        onPressed: () {
                                          GoRouter.of(context).go('/pinCodePage');
                                        },
                                      )),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width / 3,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Theme.of(context).primaryColor,
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                                      onPressed: () {
                                        context.read<AuthBloc>().login(tecUName.text, tecUPass.text);
                                      },
                                      child: Text(
                                        trs.translate("login")??"Login",
                                        style: Theme.of(context).textTheme.bodyMedium,
                                      ),
                                    ),
                                  )
                                ]),
                              )))
                    ],
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          }
        ));
  }
}
