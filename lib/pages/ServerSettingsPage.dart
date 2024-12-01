// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pos_app/bloc/ServerSettingsCubit.dart';
import 'package:pos_app/bloc/SplashScreenPageCubit.dart';
import 'package:pos_app/helpers/localization.dart';

class ServerSettingsPage extends StatelessWidget {
  const ServerSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final trs = AppLocalizations.of(context);
    TextEditingController tcHost = TextEditingController();
    TextEditingController tcPort = TextEditingController();
    TextEditingController tcUName = TextEditingController();
    TextEditingController tcUPass = TextEditingController();
    TextEditingController tcDbName = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        foregroundColor: Theme.of(context).cardColor,
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(trs.translate('server_settings')??"Server settings",style: Theme.of(context).textTheme.labelLarge!.copyWith(fontWeight: FontWeight.bold,color: Theme.of(context).cardColor),),
        actions: [
          IconButton(
            color: Theme.of(context).iconTheme.color,
              icon: const Icon(Icons.save),
              tooltip: trs.translate('save') ?? 'Save',
              onPressed: () {
                context
                    .read<ServerSettingsCubit>()
                    .saveServerSettings(tcHost.text, int.parse(tcPort.text), tcUName.text, tcUPass.text, tcDbName.text);
                GoRouter.of(context).pushNamed('splashScreen');
                context.read<SplashScreenPageCubit>().loadSplashScreenPage();
              })
        ],
      ),
      body: BlocListener<ServerSettingsCubit, ServerSettingsState>(
        listener: (context, state) {
          if (state is ServerSettingsInitialState || state is ErrorSaveServerSettingsState || state is ServerSettingsSavedState){
            context.read<ServerSettingsCubit>().loadServerSettings();
          } else if (state is ServerSettingsLoadedState){
            tcHost.text = state.serverName;
            tcPort.text = state.serverPort.toString();
            tcUName.text = state.serverUName;
            tcUPass.text = state.serverUPass;
            tcDbName.text = state.dbName;
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: 15.0, vertical: 20),
          child: Container(
            width: MediaQuery.sizeOf(context).width,
            decoration: BoxDecoration(
                color: Theme
                    .of(context)
                    .colorScheme.onSecondaryContainer,
                borderRadius: BorderRadius.circular(5),
                boxShadow: [BoxShadow(
                    color: Theme
                        .of(context)
                        .dividerColor,
                    blurRadius: 2,
                    offset: const Offset(1, 1)
                )
                ]
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 8.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                          10, 25, 10, 0),
                      child: TextField(
                        cursorColor: const Color(0xffCDCDCD),
                        controller: tcHost,
                        onSubmitted: (value) {
                          tcHost.text = value;
                        },
                        decoration: InputDecoration(
                          label: Text(
                              trs.translate("lbl_server_name") ??
                                  "Server name"),
                          floatingLabelStyle: const TextStyle(
                              color: Color(0xffCDCDCD)),
                          alignLabelWithHint: true,
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color(0xffCDCDCD)),
                            borderRadius: BorderRadius.all(
                                Radius.circular(5.0)
                            ),
                          ),
                          focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xffCDCDCD)),
                              borderRadius: BorderRadius.all(
                                  Radius.circular(5.0))
                          ),
                          border: const OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xffCDCDCD)),
                              borderRadius: BorderRadius.all(
                                  Radius.circular(5.0))
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                          10, 25, 10, 0),
                      child: TextField(
                        cursorColor: const Color(0xffCDCDCD),
                        controller: tcPort,
                        onSubmitted: (value) {
                          tcPort.text = value;
                        },
                        decoration: InputDecoration(
                          label: Text(
                              trs.translate("lbl_port") ??
                                  "Port"),
                          floatingLabelStyle: const TextStyle(
                              color: Color(0xffCDCDCD)),
                          alignLabelWithHint: true,
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color(0xffCDCDCD)),
                            borderRadius: BorderRadius.all(
                                Radius.circular(5.0)
                            ),
                          ),
                          focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xffCDCDCD)),
                              borderRadius: BorderRadius.all(
                                  Radius.circular(5.0))
                          ),
                          border: const OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xffCDCDCD)),
                              borderRadius: BorderRadius.all(
                                  Radius.circular(5.0))
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 15),
                      child: TextField(
                        cursorColor: const Color(0xffCDCDCD),
                        controller: tcUName,
                        decoration: InputDecoration(
                          label: Text(
                              trs.translate("username") ??
                                  "Username"),
                          floatingLabelStyle: const TextStyle(
                              color: Color(0xffCDCDCD)),
                          alignLabelWithHint: true,
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color(0xffCDCDCD)),
                            borderRadius: BorderRadius.all(
                                Radius.circular(5.0)
                            ),
                          ),
                          focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xffCDCDCD)),
                              borderRadius: BorderRadius.all(
                                  Radius.circular(5.0))
                          ),
                          border: const OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xffCDCDCD)),
                              borderRadius: BorderRadius.all(
                                  Radius.circular(5.0))
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0),
                      child: TextField(
                        cursorColor: const Color(0xffCDCDCD),
                        controller: tcUPass,
                        obscureText: true,
                        obscuringCharacter: "*",
                        decoration: InputDecoration(
                          label: Text(
                              trs.translate("password") ??
                                  "Password"),
                          floatingLabelStyle: const TextStyle(
                              color: Color(0xffCDCDCD)),
                          alignLabelWithHint: true,
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color(0xffCDCDCD)),
                            borderRadius: BorderRadius.all(
                                Radius.circular(5.0)
                            ),
                          ),
                          focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xffCDCDCD)),
                              borderRadius: BorderRadius.all(
                                  Radius.circular(5.0))
                          ),
                          border: const OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xffCDCDCD)),
                              borderRadius: BorderRadius.all(
                                  Radius.circular(5.0))
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 20),
                      child: TextField(
                        cursorColor: const Color(0xffCDCDCD),
                        controller: tcDbName,
                        decoration: InputDecoration(
                          label: Text(
                              trs.translate("lbl_db_name") ??
                                  "Database name"),
                          floatingLabelStyle: const TextStyle(
                              color: Color(0xffCDCDCD)),
                          alignLabelWithHint: true,
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color(0xffCDCDCD)),
                            borderRadius: BorderRadius.all(
                                Radius.circular(5.0)
                            ),
                          ),
                          focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xffCDCDCD)),
                              borderRadius: BorderRadius.all(
                                  Radius.circular(5.0))
                          ),
                          border: const OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xffCDCDCD)),
                              borderRadius: BorderRadius.all(
                                  Radius.circular(5.0))
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
        // ListView(
        //   padding: const EdgeInsets.all(8),
        //   children: [
        //     const Divider(
        //       thickness: 2,
        //     ),
        //     Padding(
        //       padding: const EdgeInsets.only(top: 25, bottom: 15),
        //       child: Text(
        //         trs.translate('local')??"Local:",
        //         style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold)
        //       ),
        //     ),
        //     TextField(
        //       controller: tcHost,
        //       decoration: InputDecoration(
        //         filled: true,
        //         border: const UnderlineInputBorder(
        //           borderSide: BorderSide( width: 2.0),
        //         ),
        //         enabledBorder: const UnderlineInputBorder(
        //           borderSide: BorderSide(width: 2.0),
        //         ),
        //         focusedBorder: const UnderlineInputBorder(
        //           borderSide: BorderSide(width: 2.0),
        //         ),
        //         labelText: trs.translate('lbl_server_name')??'Server name',
        //         hintText: primaryFocus!.hasFocus ? '' : trs.translate('lbl_server_name')??'Server name',
        //       ),
        //     ),
        //     TextField(
        //       controller: tcPort,
        //       keyboardType: TextInputType.number,
        //       decoration: InputDecoration(
        //         filled: true,
        //         border: const UnderlineInputBorder(
        //           borderSide: BorderSide(width: 2.0),
        //         ),
        //         enabledBorder: const UnderlineInputBorder(
        //           borderSide: BorderSide( width: 2.0),
        //         ),
        //         focusedBorder: const UnderlineInputBorder(
        //           borderSide: BorderSide( width: 2.0),
        //         ),
        //         labelText: trs.translate('lbl_port') ?? "Port",
        //         hintText: primaryFocus!.hasFocus ? '' : trs.translate('lbl_port') ?? "Port",
        //       ),
        //     ),
        //     Padding(
        //       padding: const EdgeInsets.only(top: 15),
        //       child: TextField(
        //         controller: tcUName,
        //         decoration: InputDecoration(
        //           filled: true,
        //           border: const UnderlineInputBorder(
        //             borderSide: BorderSide( width: 2.0),
        //           ),
        //           enabledBorder: const UnderlineInputBorder(
        //             borderSide: BorderSide(width: 2.0),
        //           ),
        //           focusedBorder: const UnderlineInputBorder(
        //             borderSide: BorderSide(width: 2.0),
        //           ),
        //           labelText: trs.translate('username')??'Username',
        //           hintText: primaryFocus!.hasFocus ? '' : trs.translate('username')??'Username',
        //         ),
        //       ),
        //     ),
        //     Padding(
        //       padding: const EdgeInsets.only(top: 15, bottom: 15),
        //       child: TextField(
        //         controller: tcUPass,
        //         decoration: InputDecoration(
        //           filled: true,
        //           border: const UnderlineInputBorder(
        //             borderSide: BorderSide(width: 2.0),
        //           ),
        //           enabledBorder: const UnderlineInputBorder(
        //             borderSide: BorderSide(width: 2.0),
        //           ),
        //           focusedBorder: const UnderlineInputBorder(
        //             borderSide: BorderSide(width: 2.0),
        //           ),
        //           labelText: trs.translate('password')??'Password',
        //           hintText: primaryFocus!.hasFocus ? '' : trs.translate('password')??'Password',
        //         ),
        //       ),
        //     ),
        //     TextField(
        //       controller: tcDbName,
        //       decoration: InputDecoration(
        //         filled: true,
        //         border: const UnderlineInputBorder(
        //           borderSide: BorderSide( width: 2.0),
        //         ),
        //         enabledBorder: const UnderlineInputBorder(
        //           borderSide: BorderSide(width: 2.0),
        //         ),
        //         focusedBorder: const UnderlineInputBorder(
        //           borderSide: BorderSide(width: 2.0),
        //         ),
        //         labelText: trs.translate('lbl_db_name')??'Database name',
        //         hintText: primaryFocus!.hasFocus ? '' : trs.translate('lbl_db_name')??'Database name',
        //       ),
        //     ),
        //   ],
        // ),
      )
    );
  }
}
