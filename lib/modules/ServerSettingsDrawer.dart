// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:pos_app/helpers/enums.dart';
import 'package:pos_app/helpers/localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/bloc/ServerSettingsCubit.dart';
import 'package:pos_app/pages/SplashScreenPage.dart';

class ServerSettingsDrawer extends StatefulWidget {
  final VoidCallback? goBack;

  const ServerSettingsDrawer({super.key, this.goBack});

  @override
  State<ServerSettingsDrawer> createState() => _ServerSettingsDrawerState();
}

class _ServerSettingsDrawerState extends State<ServerSettingsDrawer> {
  Device _deviceType = Device.mobile;

  @override
  Widget build(BuildContext context) {
    final trs = AppLocalizations.of(context);
    Size size = MediaQuery.of(context).size;
    Orientation orientation = MediaQuery.of(context).orientation;
    TextEditingController tcHost = TextEditingController();
    TextEditingController tcPort = TextEditingController();
    TextEditingController tcUName = TextEditingController();
    TextEditingController tcUPass = TextEditingController();
    TextEditingController tcDbName = TextEditingController();
    _deviceType = (MediaQuery.of(context).size.width < 800) ? Device.mobile : Device.tablet;
    return BlocBuilder<ServerSettingsCubit, ServerSettingsState>(
      builder: (context, state) {
        if (state is ServerSettingsInitialState || state is ErrorSaveServerSettingsState || state is ServerSettingsSavedState) {
          return Container(
            width: (size.width < 800)
                ? (orientation == Orientation.portrait)
                    ? size.width / 2
                    : 300
                : size.width / 3,
            clipBehavior: Clip.hardEdge,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(25), bottomLeft: Radius.circular(25)),
            ),
            child: Drawer(
              child: Padding(
                padding: const EdgeInsets.only(right: 30, left: 30),
                child: (_deviceType == Device.tablet)
                    ? Column(children: [
                        Container(
                            padding: const EdgeInsets.only(top: 30, bottom: 5),
                            child: Row(
                              children: [
                                TextButton(
                                    onPressed: widget.goBack,
                                    child: const Icon(
                                      Icons.arrow_back,
                                      size: 30,
                                    )),
                                Text(
                                  trs.translate('server_settings') ?? 'Server settings',
                                  style: const TextStyle(fontSize: 18),
                                ),
                                const Spacer(),
                                IconButton(
                                    iconSize: 30,
                                    icon: const Icon(Icons.save),
                                    tooltip: trs.translate('save') ?? 'Save',
                                    onPressed: () {
                                      context
                                          .read<ServerSettingsCubit>()
                                          .saveServerSettings(tcHost.text, int.parse(tcPort.text), tcUName.text, tcUPass.text, tcDbName.text);

                                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const SplashScreenPage()));
                                    })
                              ],
                            )),
                        const Divider(
                          height: 2,
                        ),
                        Center(
                          child: TextButton(
                              onPressed: () {
                                context.read<ServerSettingsCubit>().loadServerSettings();
                              },
                              child: Text(
                                trs.translate("load_data") ?? "Load data!",
                                style: const TextStyle(color: Colors.yellow),
                              )),
                        ),
                      ])
                    : (orientation == Orientation.portrait)
                        ? Column(children: [
                            Container(
                              padding: const EdgeInsets.only(top: 30, bottom: 5),
                              child: Row(
                                children: [
                                  Transform.translate(
                                    offset: const Offset(-25, 0),
                                    child: TextButton(
                                        onPressed: widget.goBack,
                                        child: const Icon(
                                          Icons.arrow_back,
                                          size: 25,
                                        )),
                                  ),
                                  Transform.translate(
                                      offset: const Offset(-35, 0),
                                      child: Text(
                                        trs.translate('server_settings') ?? 'Server settings',
                                        style: const TextStyle(fontSize: 17),
                                      )),
                                  Expanded(
                                    child: Transform.translate(
                                      offset: const Offset(-20, 0),
                                      child: IconButton(
                                          iconSize: 20,
                                          icon: const Icon(Icons.save),
                                          tooltip: trs.translate('save') ?? 'Save',
                                          onPressed: () {
                                            context.read<ServerSettingsCubit>().saveServerSettings(
                                                tcHost.text, int.parse(tcPort.text), tcUName.text, tcUPass.text, tcDbName.text);

                                            Navigator.of(context)
                                                .pushReplacement(MaterialPageRoute(builder: (context) => const SplashScreenPage()));
                                          }),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            const Divider(
                              height: 2,
                            ),
                            Center(
                              child: TextButton(
                                  onPressed: () {
                                    context.read<ServerSettingsCubit>().loadServerSettings();
                                  },
                                  child: Text(
                                    trs.translate("load_data") ?? "Load data!",
                                    style: const TextStyle(color: Colors.yellow),
                                  )),
                            ),
                          ])
                        : SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Column(children: [
                              Container(
                                padding: const EdgeInsets.only(top: 30, bottom: 5),
                                child: Row(
                                  children: [
                                    Transform.translate(
                                      offset: const Offset(-25, 0),
                                      child: TextButton(
                                          onPressed: widget.goBack,
                                          child: const Icon(
                                            Icons.arrow_back,
                                            size: 25,
                                          )),
                                    ),
                                    Transform.translate(
                                        offset: const Offset(-35, 0),
                                        child: Text(
                                          trs.translate('server_settings') ?? 'Server settings',
                                          style: const TextStyle(fontSize: 17),
                                        )),
                                    const SizedBox(width: 80),
                                    IconButton(
                                        iconSize: 20,
                                        icon: const Icon(Icons.save),
                                        tooltip: trs.translate('save') ?? 'Save',
                                        onPressed: () {
                                          context.read<ServerSettingsCubit>().saveServerSettings(
                                              tcHost.text, int.parse(tcPort.text), tcUName.text, tcUPass.text, tcDbName.text);

                                          Navigator.of(context)
                                              .pushReplacement(MaterialPageRoute(builder: (context) => const SplashScreenPage()));
                                        })
                                  ],
                                ),
                              ),
                              const Divider(
                                height: 2,
                              ),
                              Center(
                                child: TextButton(
                                    onPressed: () {
                                      context.read<ServerSettingsCubit>().loadServerSettings();
                                    },
                                    child: Text(
                                      trs.translate("load_data") ?? "Load data!",
                                      style: const TextStyle(color: Colors.yellow),
                                    )),
                              ),
                            ]),
                          ),
              ),
            ),
          );
        } else if (state is ServerSettingsLoadedState) {
          tcHost.text = state.serverName;
          tcPort.text = state.serverPort.toString();
          tcUName.text = state.serverUName;
          tcUPass.text = state.serverUPass;
          tcDbName.text = state.dbName;
          return Container(
            width: (size.width < 800)
                ? (orientation == Orientation.portrait)
                    ? size.width / 2
                    : 300
                : size.width / 3,
            clipBehavior: Clip.hardEdge,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(25), bottomLeft: Radius.circular(25)),
            ),
            child: Drawer(
              child: Padding(
                padding: const EdgeInsets.only(right: 30, left: 30),
                child: (_deviceType == Device.tablet)
                    ? Column(children: [
                        Container(
                            padding: const EdgeInsets.only(top: 30, bottom: 5),
                            child: Row(
                              children: [
                                TextButton(
                                    onPressed: widget.goBack,
                                    child: const Icon(
                                      Icons.arrow_back,
                                      size: 30,
                                    )),
                                Text(
                                  trs.translate('server_settings') ?? 'Server settings',
                                  style: const TextStyle(fontSize: 18),
                                ),
                                const Spacer(),
                                IconButton(
                                    iconSize: 30,
                                    icon: const Icon(Icons.save),
                                    tooltip: trs.translate('save') ?? 'Save',
                                    onPressed: () {
                                      context
                                          .read<ServerSettingsCubit>()
                                          .saveServerSettings(tcHost.text, int.parse(tcPort.text), tcUName.text, tcUPass.text, tcDbName.text);

                                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const SplashScreenPage()));
                                    })
                              ],
                            )),
                        const Divider(
                          height: 2,
                        ),
                        SizedBox(
                          height: 600,
                          child: ListView(
                            padding: const EdgeInsets.all(8),
                            children: [
                              Text(
                                trs.translate('local') ?? "Local:",
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: TextField(
                                  controller: tcHost,
                                  decoration: InputDecoration(
                                    filled: true,
                                    border: const UnderlineInputBorder(
                                      borderSide: BorderSide(width: 2.0),
                                    ),
                                    enabledBorder: const UnderlineInputBorder(
                                      borderSide: BorderSide(width: 2.0),
                                    ),
                                    focusedBorder: const UnderlineInputBorder(
                                      borderSide: BorderSide(width: 2.0),
                                    ),
                                    labelText: trs.translate('lbl_server_name') ?? 'Server name',
                                    hintText: primaryFocus!.hasFocus ? '' : trs.translate('lbl_server_name') ?? 'Server name',
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10.0),
                                child: TextField(
                                  controller: tcPort,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    filled: true,
                                    border: const UnderlineInputBorder(
                                      borderSide: BorderSide(width: 2.0),
                                    ),
                                    enabledBorder: const UnderlineInputBorder(
                                      borderSide: BorderSide(width: 2.0),
                                    ),
                                    focusedBorder: const UnderlineInputBorder(
                                      borderSide: BorderSide(width: 2.0),
                                    ),
                                    labelText: trs.translate('lbl_port') ?? "Port",
                                    hintText: primaryFocus!.hasFocus ? '' : trs.translate('lbl_port') ?? "Port",
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 15),
                                child: TextField(
                                  controller: tcUName,
                                  decoration: InputDecoration(
                                    filled: true,
                                    border: const UnderlineInputBorder(
                                      borderSide: BorderSide(width: 2.0),
                                    ),
                                    enabledBorder: const UnderlineInputBorder(
                                      borderSide: BorderSide(width: 2.0),
                                    ),
                                    focusedBorder: const UnderlineInputBorder(
                                      borderSide: BorderSide(width: 2.0),
                                    ),
                                    labelText: trs.translate('username') ?? 'Username',
                                    hintText: primaryFocus!.hasFocus ? '' : trs.translate('username') ?? 'Username',
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 15, bottom: 15),
                                child: TextField(
                                  controller: tcUPass,
                                  decoration: InputDecoration(
                                    filled: true,
                                    border: const UnderlineInputBorder(
                                      borderSide: BorderSide(width: 2.0),
                                    ),
                                    enabledBorder: const UnderlineInputBorder(
                                      borderSide: BorderSide(width: 2.0),
                                    ),
                                    focusedBorder: const UnderlineInputBorder(
                                      borderSide: BorderSide(width: 2.0),
                                    ),
                                    labelText: trs.translate('password') ?? 'Password',
                                    hintText: primaryFocus!.hasFocus ? '' : trs.translate('password') ?? 'Password',
                                  ),
                                ),
                              ),
                              TextField(
                                controller: tcDbName,
                                decoration: InputDecoration(
                                  filled: true,
                                  border: const UnderlineInputBorder(
                                    borderSide: BorderSide(width: 2.0),
                                  ),
                                  enabledBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(width: 2.0),
                                  ),
                                  focusedBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(width: 2.0),
                                  ),
                                  labelText: trs.translate('lbl_db_name') ?? "Database name",
                                  hintText: primaryFocus!.hasFocus ? '' : trs.translate('lbl_db_name') ?? "Database name",
                                ),
                              ),
                            ],
                          ),
                        )
                      ])
                    : (orientation == Orientation.portrait)
                        ? Column(children: [
                            Container(
                              padding: const EdgeInsets.only(top: 30, bottom: 5),
                              child: Row(
                                children: [
                                  Transform.translate(
                                    offset: const Offset(-25, 0),
                                    child: TextButton(
                                        onPressed: widget.goBack,
                                        child: const Icon(
                                          Icons.arrow_back,
                                          size: 25,
                                        )),
                                  ),
                                  Transform.translate(
                                      offset: const Offset(-35, 0),
                                      child: Text(
                                        trs.translate('server_settings') ?? 'Server settings',
                                        style: const TextStyle(fontSize: 17),
                                      )),
                                  Expanded(
                                    child: Transform.translate(
                                      offset: const Offset(-20, 0),
                                      child: IconButton(
                                          iconSize: 20,
                                          icon: const Icon(Icons.save),
                                          tooltip: trs.translate('save') ?? 'Save',
                                          onPressed: () {
                                            context.read<ServerSettingsCubit>().saveServerSettings(
                                                tcHost.text, int.parse(tcPort.text), tcUName.text, tcUPass.text, tcDbName.text);

                                            Navigator.of(context)
                                                .pushReplacement(MaterialPageRoute(builder: (context) => const SplashScreenPage()));
                                          }),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            const Divider(
                              height: 2,
                            ),
                            SizedBox(
                              height: 600,
                              child: ListView(
                                padding: const EdgeInsets.all(8),
                                children: [
                                  Text(
                                    trs.translate('local') ?? "Local:",
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: TextField(
                                      controller: tcHost,
                                      decoration: InputDecoration(
                                        filled: true,
                                        border: const UnderlineInputBorder(
                                          borderSide: BorderSide(width: 2.0),
                                        ),
                                        enabledBorder: const UnderlineInputBorder(
                                          borderSide: BorderSide(width: 2.0),
                                        ),
                                        focusedBorder: const UnderlineInputBorder(
                                          borderSide: BorderSide(width: 2.0),
                                        ),
                                        labelText: trs.translate('lbl_server_name') ?? 'Server name',
                                        hintText: primaryFocus!.hasFocus ? '' : trs.translate('lbl_server_name') ?? 'Server name',
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10.0),
                                    child: TextField(
                                      controller: tcPort,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        filled: true,
                                        border: const UnderlineInputBorder(
                                          borderSide: BorderSide(width: 2.0),
                                        ),
                                        enabledBorder: const UnderlineInputBorder(
                                          borderSide: BorderSide(width: 2.0),
                                        ),
                                        focusedBorder: const UnderlineInputBorder(
                                          borderSide: BorderSide(width: 2.0),
                                        ),
                                        labelText: trs.translate('lbl_port') ?? "Port",
                                        hintText: primaryFocus!.hasFocus ? '' : trs.translate('lbl_port') ?? "Port",
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 15),
                                    child: TextField(
                                      controller: tcUName,
                                      decoration: InputDecoration(
                                        filled: true,
                                        border: const UnderlineInputBorder(
                                          borderSide: BorderSide(width: 2.0),
                                        ),
                                        enabledBorder: const UnderlineInputBorder(
                                          borderSide: BorderSide(width: 2.0),
                                        ),
                                        focusedBorder: const UnderlineInputBorder(
                                          borderSide: BorderSide(width: 2.0),
                                        ),
                                        labelText: trs.translate('username') ?? 'Username',
                                        hintText: primaryFocus!.hasFocus ? '' : trs.translate('username') ?? 'Username',
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 15, bottom: 15),
                                    child: TextField(
                                      controller: tcUPass,
                                      decoration: InputDecoration(
                                        filled: true,
                                        border: const UnderlineInputBorder(
                                          borderSide: BorderSide(width: 2.0),
                                        ),
                                        enabledBorder: const UnderlineInputBorder(
                                          borderSide: BorderSide(width: 2.0),
                                        ),
                                        focusedBorder: const UnderlineInputBorder(
                                          borderSide: BorderSide(width: 2.0),
                                        ),
                                        labelText: trs.translate('password') ?? 'Password',
                                        hintText: primaryFocus!.hasFocus ? '' : trs.translate('password') ?? 'Password',
                                      ),
                                    ),
                                  ),
                                  TextField(
                                    controller: tcDbName,
                                    decoration: InputDecoration(
                                      filled: true,
                                      border: const UnderlineInputBorder(
                                        borderSide: BorderSide(width: 2.0),
                                      ),
                                      enabledBorder: const UnderlineInputBorder(
                                        borderSide: BorderSide(width: 2.0),
                                      ),
                                      focusedBorder: const UnderlineInputBorder(
                                        borderSide: BorderSide(width: 2.0),
                                      ),
                                      labelText: trs.translate('lbl_db_name') ?? "Database name",
                                      hintText: primaryFocus!.hasFocus ? '' : trs.translate('lbl_db_name') ?? "Database name",
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ])
                        : SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Column(children: [
                              Container(
                                padding: const EdgeInsets.only(top: 30, bottom: 5),
                                child: Row(
                                  children: [
                                    Transform.translate(
                                      offset: const Offset(-25, 0),
                                      child: TextButton(
                                          onPressed: widget.goBack,
                                          child: const Icon(
                                            Icons.arrow_back,
                                            size: 25,
                                          )),
                                    ),
                                    Transform.translate(
                                        offset: const Offset(-35, 0),
                                        child: Text(
                                          trs.translate('server_settings') ?? 'Server settings',
                                        )),
                                    const SizedBox(width: 80),
                                    IconButton(
                                        iconSize: 20,
                                        icon: const Icon(Icons.save),
                                        tooltip: trs.translate('save') ?? 'Save',
                                        onPressed: () {
                                          context.read<ServerSettingsCubit>().saveServerSettings(
                                              tcHost.text, int.parse(tcPort.text), tcUName.text, tcUPass.text, tcDbName.text);

                                          Navigator.of(context)
                                              .pushReplacement(MaterialPageRoute(builder: (context) => const SplashScreenPage()));
                                        })
                                  ],
                                ),
                              ),
                              const Divider(
                                height: 2,
                              ),
                              SizedBox(
                                height: 280,
                                child: ListView(
                                  scrollDirection: Axis.vertical,
                                  padding: const EdgeInsets.all(8),
                                  children: [
                                    Text(
                                      trs.translate('local') ?? "Local:",
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8),
                                      child: TextField(
                                        controller: tcHost,
                                        decoration: InputDecoration(
                                          filled: true,
                                          border: const UnderlineInputBorder(
                                            borderSide: BorderSide(width: 2.0),
                                          ),
                                          enabledBorder: const UnderlineInputBorder(
                                            borderSide: BorderSide(width: 2.0),
                                          ),
                                          focusedBorder: const UnderlineInputBorder(
                                            borderSide: BorderSide(width: 2.0),
                                          ),
                                          labelText: trs.translate('lbl_server_name') ?? 'Server name',
                                          hintText: primaryFocus!.hasFocus ? '' : trs.translate('lbl_server_name') ?? 'Server name',
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10.0),
                                      child: TextField(
                                        controller: tcPort,
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          filled: true,
                                          border: const UnderlineInputBorder(
                                            borderSide: BorderSide(width: 2.0),
                                          ),
                                          enabledBorder: const UnderlineInputBorder(
                                            borderSide: BorderSide(width: 2.0),
                                          ),
                                          focusedBorder: const UnderlineInputBorder(
                                            borderSide: BorderSide(width: 2.0),
                                          ),
                                          labelText: trs.translate('lbl_port') ?? "Port",
                                          hintText: primaryFocus!.hasFocus ? '' : trs.translate('lbl_port') ?? "Port",
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 15),
                                      child: TextField(
                                        controller: tcUName,
                                        decoration: InputDecoration(
                                          filled: true,
                                          border: const UnderlineInputBorder(
                                            borderSide: BorderSide(width: 2.0),
                                          ),
                                          enabledBorder: const UnderlineInputBorder(
                                            borderSide: BorderSide(width: 2.0),
                                          ),
                                          focusedBorder: const UnderlineInputBorder(
                                            borderSide: BorderSide(width: 2.0),
                                          ),
                                          labelText: trs.translate('username') ?? 'Username',
                                          hintText: primaryFocus!.hasFocus ? '' : trs.translate('username') ?? 'Username',
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 15, bottom: 15),
                                      child: TextField(
                                        controller: tcUPass,
                                        decoration: InputDecoration(
                                          filled: true,
                                          border: const UnderlineInputBorder(
                                            borderSide: BorderSide(width: 2.0),
                                          ),
                                          enabledBorder: const UnderlineInputBorder(
                                            borderSide: BorderSide(width: 2.0),
                                          ),
                                          focusedBorder: const UnderlineInputBorder(
                                            borderSide: BorderSide(width: 2.0),
                                          ),
                                          labelText: trs.translate('password') ?? 'Password',
                                          hintText: primaryFocus!.hasFocus ? '' : trs.translate('password') ?? 'Password',
                                        ),
                                      ),
                                    ),
                                    TextField(
                                      controller: tcDbName,
                                      decoration: InputDecoration(
                                        filled: true,
                                        border: const UnderlineInputBorder(
                                          borderSide: BorderSide(width: 2.0),
                                        ),
                                        enabledBorder: const UnderlineInputBorder(
                                          borderSide: BorderSide(width: 2.0),
                                        ),
                                        focusedBorder: const UnderlineInputBorder(
                                          borderSide: BorderSide(width: 2.0),
                                        ),
                                        labelText: trs.translate('lbl_db_name') ?? "Database name",
                                        hintText: primaryFocus!.hasFocus ? '' : trs.translate('lbl_db_name') ?? "Database name",
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ]),
                          ),
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
