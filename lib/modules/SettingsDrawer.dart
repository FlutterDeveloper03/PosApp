// ignore_for_file: file_names

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pos_app/helpers/enums.dart';
import 'package:pos_app/helpers/localization.dart';
import 'package:pos_app/widgets/ChangeThemeButtonWidget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pos_app/bloc/LanguageBloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsDrawer extends StatefulWidget {
  final bool visible;
  final VoidCallback? goBack;
  final VoidCallback? synch;
  final VoidCallback? profile;
  final VoidCallback? server;

  const SettingsDrawer({super.key, this.goBack, required this.visible, this.synch, this.profile, this.server});

  @override
  State<SettingsDrawer> createState() => _SettingsDrawerState();
}

class _SettingsDrawerState extends State<SettingsDrawer> {
  late int i;
  String? appVersion;
  String? buildNumber;
  Device _deviceType = Device.mobile;

  Future<void> initPackageInfo() async {
    final packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      appVersion = packageInfo.version;
      buildNumber = packageInfo.buildNumber;
    });
  }

  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmController = TextEditingController();
  late String passWord;
  late String confirm;

  @override
  void initState() {
    super.initState();
    initPackageInfo();
  }

  bool isVisible = false;
  Widget lockIcon = const Icon(Icons.lock_open_outlined);

  Future<void> change() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey("password") && prefs.containsKey("confirm")) {
      lockIcon = const Icon(Icons.lock_outline_sharp);
      setState(() {});
      i = 0;
    } else {
      lockIcon = const Icon(Icons.lock_open_outlined);
      setState(() {});
      i = 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    change();
    final trs = AppLocalizations.of(context);
    _deviceType = (MediaQuery.of(context).size.width < 800) ? Device.mobile : Device.tablet;
    Size size = MediaQuery.of(context).size;
    Orientation orientation = MediaQuery.of(context).orientation;
    var items = [
      trs.translate('tk') ?? 'Turkmen',
      trs.translate('ru') ?? 'Russian',
      trs.translate('en') ?? 'English',
    ];
    String dropdownvalue = trs.translate('tk') ?? 'Turkmen';
    return Container(
      width: (size.width < 800)
          ? (orientation == Orientation.portrait)
              ? size.width / 1.3
              : size.width / 2
          : size.width / 3,
      clipBehavior: Clip.hardEdge,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(25), bottomLeft: Radius.circular(25)),
      ),
      child: Drawer(
        child: Padding(
          padding: const EdgeInsets.only(right: 30, left: 30),
          child: (_deviceType == Device.tablet)
              ? Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 30, bottom: 5),
                      child: Row(
                        children: [
                          Visibility(
                              visible: widget.visible,
                              child: TextButton(
                                  onPressed: widget.goBack,
                                  child: const Icon(
                                    Icons.arrow_back,
                                    size: 30,
                                  ))),
                          Text(
                            trs.translate('settings') ?? "Settings",
                            style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize:24)
                          ),
                          const Spacer(),
                          IconButton(
                            onPressed: () async {
                              i++;
                              if (i == 1) {
                                final prefs = await SharedPreferences.getInstance();
                                if (prefs.containsKey("password") && prefs.containsKey("confirm")) {
                                  clearData();
                                }
                              } else if (i == 2) {
                                setState(() {
                                  _displayTextInputDialog(context);
                                });
                              }
                            },
                            icon: lockIcon,
                            iconSize: 30,
                          ),
                          const Icon(
                            Icons.settings,
                            size: 30,
                          )
                        ],
                      ),
                    ),
                    const Divider(height: 2),
                    Expanded(
                      child: ListView(
                        children: [
                          ListTile(
                            onTap: widget.profile,
                            title: Text(trs.translate('profile') ?? "My profile"),
                            leading: const Icon(Icons.person_outline_sharp),
                            trailing: IconButton(onPressed: widget.profile, icon: const Icon(Icons.arrow_forward_ios_sharp)),
                          ),
                          ListTile(
                            title: Text(trs.translate('theme') ?? "Theme of the program"),
                            leading: const Icon(Icons.mode),
                            trailing: const ChangeThemeButtonWidget(),
                          ),
                          ListTile(
                              title: Text(trs.translate('language') ?? "Interface language"),
                              leading: const Icon(Icons.language),
                              onTap: () {
                                setState(() {
                                  isVisible = !isVisible;
                                });
                              }),
                          Visibility(
                            visible: isVisible,
                            child: DropdownButton(
                              padding: const EdgeInsets.only(left: 20, right: 30),
                              value: dropdownvalue,
                              isExpanded: true,
                              iconSize: 35,
                              icon: const Icon(Icons.keyboard_arrow_down),
                              items: items.map((String items) {
                                return DropdownMenuItem(
                                  value: items,
                                  child: Text(items),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  dropdownvalue = newValue!;
                                  BlocProvider.of<LanguageBloc>(context).add(LanguageSelected(newValue));
                                });
                              },
                            ),
                          ),
                          ListTile(
                            title: Text(trs.translate('version') ?? "Program version"),
                            leading: const Icon(Icons.phone_android),
                            trailing: Text(
                              "$appVersion+$buildNumber",
                            ),
                          ),
                          ListTile(
                            onTap: widget.server,
                            title: Text(trs.translate('server_settings') ?? "Server settings"),
                            leading: const Icon(Icons.network_locked_outlined),
                            trailing: IconButton(
                              onPressed: widget.server,
                              icon: const Icon(
                                Icons.arrow_forward_ios_sharp,
                              ),
                            ),
                          ),
                          ListTile(
                            onTap: widget.synch,
                            title: Text(
                              trs.translate('sync') ?? "Synchronization",
                            ),
                            leading: const Icon(
                              Icons.cached_outlined,
                            ),
                            trailing: TextButton(
                              onPressed: widget.synch,
                              child: const Icon(Icons.arrow_forward_ios_sharp),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              : (orientation == Orientation.portrait)
                  ? Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.only(top: 30, bottom: 5),
                          child: Row(
                            children: [
                              Visibility(
                                  visible: widget.visible,
                                  child: Transform.translate(
                                    offset: const Offset(-22, 0),
                                    child: TextButton(
                                        onPressed: widget.goBack,
                                        child: const Icon(
                                          Icons.arrow_back,
                                          size: 30,
                                        )),
                                  )),
                              widget.visible
                                  ? Transform.translate(
                                      offset: const Offset(-22, 0),
                                      child: Text(
                                        trs.translate('settings') ?? "Settings",
                                        ))
                                  : Text(
                                      trs.translate('settings') ?? "Settings",
                                    ),
                              SizedBox(
                                width: widget.visible ? 0 : 40,
                              ),
                              IconButton(
                                onPressed: () async {
                                  i++;
                                  if (i == 1) {
                                    final prefs = await SharedPreferences.getInstance();
                                    if (prefs.containsKey("password") && prefs.containsKey("confirm")) {
                                      clearData();
                                    }
                                  } else if (i == 2) {
                                    setState(() {
                                      _displayTextInputDialog(context);
                                    });
                                  }
                                },
                                icon: lockIcon,
                                iconSize: 25,
                              ),
                              const SizedBox(width: 5),
                              const Icon(
                                Icons.settings,
                                size: 25,
                              )
                            ],
                          ),
                        ),
                        const Divider(height: 2),
                        SizedBox(
                          height: 600,
                          child: ListView(
                            children: [
                              ListTile(
                                onTap: widget.profile,
                                title: Text(
                                  trs.translate('profile') ?? "My profile",
                                ),
                                leading: const Icon(Icons.person_outline_sharp),
                                trailing: IconButton(
                                    onPressed: widget.profile, icon: const Icon(Icons.arrow_forward_ios_sharp)),
                              ),
                              ListTile(
                                title: Text(
                                  trs.translate('theme') ?? "Theme of the program",
                                ),
                                leading: const Icon(
                                  Icons.mode,
                                ),
                                trailing: const ChangeThemeButtonWidget(),
                              ),
                              ListTile(
                                  title: Text(
                                    trs.translate('language') ?? "Interface language",
                                  ),
                                  leading: const Icon(
                                    Icons.language,
                                  ),
                                  onTap: () {
                                    setState(() {
                                      isVisible = !isVisible;
                                    });
                                  }),
                              Visibility(
                                visible: isVisible,
                                child: DropdownButton(
                                  padding: const EdgeInsets.only(left: 20, right: 30),
                                  value: dropdownvalue,
                                  isExpanded: true,
                                  iconSize: 35,
                                  icon: const Icon(
                                    Icons.keyboard_arrow_down,
                                  ),
                                  items: items.map((String items) {
                                    return DropdownMenuItem(
                                      value: items,
                                      child: Text(
                                        items,
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      dropdownvalue = newValue!;
                                      BlocProvider.of<LanguageBloc>(context).add(LanguageSelected(newValue));
                                    });
                                  },
                                ),
                              ),
                              ListTile(
                                title: Text(
                                  trs.translate('version') ?? "Program version",
                                ),
                                leading: const Icon(
                                  Icons.phone_android,
                                ),
                                trailing: Text(
                                  "$appVersion+$buildNumber",
                                ),
                              ),
                              ListTile(
                                onTap: widget.server,
                                title: Text(
                                  trs.translate('server_settings') ?? "Server settings",
                                ),
                                leading: const Icon(
                                  Icons.network_locked_outlined,
                                ),
                                trailing: IconButton(
                                  onPressed: widget.server,
                                  icon: const Icon(
                                    Icons.arrow_forward_ios_sharp,
                                  ),
                                ),
                              ),
                              ListTile(
                                onTap: widget.synch,
                                title: Text(
                                  trs.translate('sync') ?? "Synchronization",
                                ),
                                leading: const Icon(
                                  Icons.cached_outlined,
                                ),
                                trailing: TextButton(
                                  onPressed: widget.synch,
                                  child: const Icon(
                                    Icons.arrow_forward_ios_sharp,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  : SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.only(top: 30, bottom: 5),
                            child: Row(
                              children: [
                                Visibility(
                                    visible: widget.visible,
                                    child: Transform.translate(
                                      offset: const Offset(-22, 0),
                                      child: TextButton(
                                          onPressed: widget.goBack,
                                          child: const Icon(
                                            Icons.arrow_back,
                                            size: 30,
                                          )),
                                    )),
                                widget.visible
                                    ? Transform.translate(
                                        offset: const Offset(-22, 0),
                                        child: Text(
                                          trs.translate('settings') ?? "Settings",
                                        ))
                                    : Text(
                                        trs.translate('settings') ?? "Settings",
                                      ),
                                SizedBox(
                                  width: widget.visible ? 85 : 140,
                                ),
                                IconButton(
                                  onPressed: () async {
                                    i++;
                                    if (i == 1) {
                                      final prefs = await SharedPreferences.getInstance();
                                      if (prefs.containsKey("password") && prefs.containsKey("confirm")) {
                                        clearData();
                                      }
                                    } else if (i == 2) {
                                      setState(() {
                                        _displayTextInputDialog(context);
                                      });
                                    }
                                  },
                                  icon: lockIcon,
                                  iconSize: 25,
                                ),
                                const Spacer(),
                                const Icon(
                                  Icons.settings,
                                  size: 25,
                                )
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
                              children: [
                                ListTile(
                                  onTap: widget.profile,
                                  title: Text(
                                    trs.translate('profile') ?? "My profile",
                                    ),
                                  leading: const Icon(Icons.person_outline_sharp),
                                  trailing: IconButton(
                                      onPressed: widget.profile,
                                      icon: const Icon(Icons.arrow_forward_ios_sharp),),
                                ),
                                ListTile(
                                  title: Text(
                                    trs.translate('theme') ?? "Theme of the program",
                                  ),
                                  leading: const Icon(
                                    Icons.mode,
                                  ),
                                  trailing: const ChangeThemeButtonWidget(),
                                ),
                                ListTile(
                                    title: Text(
                                      trs.translate('language') ?? "Interface language",
                                      ),
                                    leading: const Icon(
                                      Icons.language,
                                    ),
                                    onTap: () {
                                      setState(() {
                                        isVisible = !isVisible;
                                      });
                                    }),
                                Visibility(
                                  visible: isVisible,
                                  child: DropdownButton(
                                    padding: const EdgeInsets.only(left: 20, right: 30),
                                    value: dropdownvalue,
                                    isExpanded: true,
                                    iconSize: 35,
                                    icon: const Icon(
                                      Icons.keyboard_arrow_down,
                                    ),
                                    items: items.map((String items) {
                                      return DropdownMenuItem(
                                        value: items,
                                        child: Text(
                                          items,
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        dropdownvalue = newValue!;
                                        BlocProvider.of<LanguageBloc>(context).add(LanguageSelected(newValue));
                                      });
                                    },
                                  ),
                                ),
                                ListTile(
                                  title: Text(
                                    trs.translate('version') ?? "Program version",
                                  ),
                                  leading: const Icon(
                                    Icons.phone_android,
                                  ),
                                  trailing: Text(
                                    "$appVersion+$buildNumber",
                                  ),
                                ),
                                ListTile(
                                  onTap: widget.server,
                                  title: Text(
                                    trs.translate('server_settings') ?? "Server settings",
                                  ),
                                  leading: const Icon(
                                    Icons.network_locked_outlined,
                                  ),
                                  trailing: IconButton(
                                    onPressed: widget.server,
                                    icon: const Icon(
                                      Icons.arrow_forward_ios_sharp,
                                    ),
                                  ),
                                ),
                                ListTile(
                                  onTap: widget.synch,
                                  title: Text(
                                    trs.translate('sync') ?? "Synchronization",
                                  ),
                                  leading: const Icon(
                                    Icons.cached_outlined,
                                  ),
                                  trailing: TextButton(
                                    onPressed: widget.synch,
                                    child: const Icon(
                                      Icons.arrow_forward_ios_sharp,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
        ),
      ),
    );
  }

  Future<void> _displayTextInputDialog(BuildContext context) async {
    final trs = AppLocalizations.of(context);
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          title: Text(trs.translate('user_pass') ?? "User's password"),
          content: SizedBox(
            height: 140,
            child: Column(
              children: [
                TextField(
                  controller: passwordController,
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
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: true,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: TextField(
                    controller: confirmController,
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
                      labelText: trs.translate('confirm') ?? 'Confirmation',
                      hintText: primaryFocus!.hasFocus ? '' : trs.translate('confirm') ?? 'Confirmation',
                    ),
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: true,
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                trs.translate('back') ?? 'BACK',
              ),
              onPressed: () {
                i = 1;
                setState(() {});
                Navigator.pop(context);
              },
            ),
            TextButton(
                child: const Text(
                  'OK',
                ),
                onPressed: () {
                  SharedPreferences.getInstance().then(
                    (prefs) async {
                      if (passwordController.text == "" || confirmController.text == "") {
                        null;
                      } else if ((passwordController.text == confirmController.text)) {
                        i = 0;
                        String? pass = prefs.getString("password");
                        String? conf = prefs.getString("confirm");
                        if (kDebugMode) {
                          print("Password:$pass, confirm:$conf");
                        }
                        Navigator.pop(context);
                        await saveInputs(passwordController.text, confirmController.text);
                        lockIcon = const Icon(Icons.lock_outline_sharp);
                        setState(() {});
                      } else {
                        null;
                      }
                    },
                  );
                }),
          ],
        );
      },
    );
  }

  Future<void> saveInputs(String password, String confirm) async {
    SharedPreferences.getInstance().then((prefs) {
      prefs.setString("password", password);
      prefs.setString("confirm", confirm);
    });
  }

  Future<void> clearData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
