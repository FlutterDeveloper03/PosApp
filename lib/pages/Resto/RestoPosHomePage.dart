// ignore_for_file: use_build_context_synchronously, file_names

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:pos_app/bloc/RestoReservationsPageCubit.dart';
import 'package:pos_app/models/tbl_dk_res_category.dart';
import 'package:pos_app/models/tbl_dk_table.dart';
import 'package:pos_app/models/tbl_dk_event.dart';
import 'package:pos_app/provider/GlobalVarsProvider.dart';
import 'package:pos_app/helpers/enums.dart';
import 'package:pos_app/helpers/localization.dart';
import 'package:pos_app/bloc/RestoPosHomePageCubit.dart';
import 'package:pos_app/helpers/globals.dart' as globals;
import 'package:uuid/uuid.dart';

class RestoHomePage extends StatefulWidget {
  const RestoHomePage({super.key});

  @override
  State<RestoHomePage> createState() => _RestoHomePageState();
}

class _RestoHomePageState extends State<RestoHomePage>
    with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  Device _deviceType = Device.mobile;
  late TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabController(
        initialIndex: 0,
        length: context
            .read<GlobalVarsProvider>()
            .gettableCategories
            .length,
        vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  int buttonIndex = 1;

  @override
  Widget build(BuildContext context) {
    final trs = AppLocalizations.of(context);
    Size screenSize = MediaQuery
        .of(context)
        .size;
    _deviceType = (screenSize.width < 800) ? Device.mobile : Device.tablet;
    Orientation orientation = MediaQuery
        .of(context)
        .orientation;
    GlobalVarsProvider globalVarsProvider = Provider.of<GlobalVarsProvider>(
        context);
    if(globalVarsProvider.gettableCategories.isEmpty){
      _controller = TabController(length: 0, vsync: this);
    }
    else{
      _controller = TabController(
          initialIndex: 0,
          length: globalVarsProvider
              .gettableCategories
              .length,
          vsync: this);
    }
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) => handlePop(context),
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        key: _key,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50.0),
          child: AppBar(
            backgroundColor: Theme
                .of(context)
                .primaryColor,
            elevation: 0,
            bottom: TabBar(
              tabs: globalVarsProvider.gettableCategories.map<Tab>((
                  TblDkResCategory cat) {
                return Tab(text: cat.ResCatName);
              }).toList(),
              controller: _controller,
              // isScrollable: true,
              labelPadding: const EdgeInsets.symmetric(horizontal: 20),
              indicatorColor: Theme.of(context).indicatorColor,
              labelStyle: Theme
                  .of(context)
                  .textTheme
                  .labelMedium!
                  .copyWith(color: Theme.of(context).indicatorColor),
              indicator: UnderlineTabIndicator(
                borderSide: BorderSide(
                  width: 4.0,
                  color: Theme
                      .of(context)
                      .indicatorColor,
                ),
                borderRadius: BorderRadius.circular(16),
                insets: const EdgeInsets.only(top: 50),
              ),
              indicatorSize: TabBarIndicatorSize.label,
              unselectedLabelColor: Theme
                  .of(context)
                  .textTheme
                  .labelMedium!
                  .color,
              unselectedLabelStyle: Theme
                  .of(context)
                  .textTheme
                  .labelMedium,
            ),
          ),
        ),
        body: BlocListener<RestoReservationPageCubit,
            RestoReservationPageState>(
          listener: (context, state) {
            if (state is ReservedState) {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: SizedBox(
                      height: MediaQuery
                          .of(context)
                          .size
                          .height / 5,
                      child: Column(
                        children: [
                          Text(trs.translate("event_name_label") ??
                              "Event's name"),
                          Text(state.event.EventName),
                          Text(trs.translate("startTime") ??
                              "Event's start time"),
                          Text("${state.event.EventStartDate}"),
                          Text(trs.translate("endTime") ?? "Event's end time"),
                          Text("${state.event.EventEndDate}"),
                        ],
                      ),
                    ),
                  ));
              try {
                Timer(globalVarsProvider.getReservations
                    .firstWhere((element) =>
                element.EventStartDate!.compareTo(DateTime.now()) >= 0)
                    .EventStartDate!
                    .difference(DateTime.now()), () {
                  setState(() {});
                });
              } catch (e) {
                debugPrint("Sizde gerekli wagt aralygy yok!");
              }
            }
            else if (state is EventModifiedState) {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        trs.translate('eventModified') ?? 'Event modified!'),
                  ));
              try {
                Timer(globalVarsProvider.getReservations
                    .firstWhere((element) =>
                element.EventStartDate!.compareTo(DateTime.now()) >= 0)
                    .EventStartDate!
                    .difference(DateTime.now()), () {
                  setState(() {});
                });
              } catch (e) {
                debugPrint("Sizde gerekli wagt aralygy yok!");
              }
            }
            else if (state is CantReserveState) {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        "${trs.translate('error_text') ?? 'Error'}: ${state
                            .errorMsg}"),
                  ));
            }
          },
          child: BlocConsumer<RestoPosHomePageCubit, RestoPosHomePageState>(
            listener: (context, state) {
              if (state is RPHPCantConnectToServerState) {
                _showDialog(context);
              }
              else
              if (state is MergingFailedState || state is DividingFailedState) {
                globals.slctTblGuids.clear();
                globals.selectedTables.clear();
                globals.dividableTables.clear();
              }
              else if (state is RestoHomePageLoadedState) {
                globalVarsProvider.getReservations;
                globals.slctTblGuids.clear();
                globals.selectedTables.clear();
                globals.dividableTables.clear();
                try {
                  Timer(globalVarsProvider.getReservations
                      .firstWhere((element) =>
                  element.EventStartDate!.compareTo(DateTime.now()) >= 0)
                      .EventStartDate!
                      .difference(DateTime.now()), () {
                    setState(() {});
                  });
                } catch (e) {
                  debugPrint("Sizde gerekli wagt aralygy yok!");
                }
              }
              else if (state is EventModifiedState) {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          trs.translate('eventModified') ?? 'Event modified!'),
                    ));
              }
            },
            builder: (context, state) {
              if (state is LoadingRestoPosHomePageState) {
                return const Center(child: CircularProgressIndicator());
              }
              else if (state is MergingFailedState) {
                return Center(
                  child: Column(
                    children: [
                      Text("${trs.translate("error_text") ?? "Error"}: ${state
                          .errorMsg}"),
                      TextButton(
                          onPressed: () =>
                              context.read<RestoPosHomePageCubit>()
                                  .reloadData(),
                          child: Text(trs.translate('try_again') ??
                              "Try again"))
                    ],
                  ),
                );
              }
              else if (state is DividingFailedState) {
                return Center(
                  child: Column(
                    children: [
                      Text("${trs.translate("error_text") ?? "Error"}: ${state
                          .errorMsg}"),
                      TextButton(
                          onPressed: () =>
                              context.read<RestoPosHomePageCubit>()
                                  .reloadData(),
                          child: Text(trs.translate('try_again') ??
                              "Try again"))
                    ],
                  ),
                );
              }
              else if (state is RestoPosHomePageLoadErrorState) {
                return Center(
                  child: Column(
                    children: [
                      Text("${trs.translate("error_text") ?? "Error"}: ${state
                          .errorMsg}"),
                      TextButton(
                          onPressed: () => context.read<RestoPosHomePageCubit>()
                              .reloadData(),
                          child: Text(
                              trs.translate('try_again') ?? "Try again"))
                    ],
                  ),
                );
              }
              else if (state is RestoHomePageLoadedState) {
                return Row(
                  children: [
                    Expanded(
                      child: TabBarView(
                        controller: _controller,
                        children: globalVarsProvider.gettableCategories.map<
                            Widget>((TblDkResCategory category) {
                          return TablesTabBar(orientation, _deviceType,
                              tables: globalVarsProvider.getTables.where((
                                  element) =>
                              element.CatId == category.ResCatId).toList()
                          );
                        }).toList(),
                      ),
                    ),
                    (_deviceType == Device.tablet)
                        ? Ink(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width / 8,
                      color: Theme
                          .of(context)
                          .primaryColor,
                      child: ListView(
                        children: [
                          Material(
                            color: Theme
                                .of(context)
                                .primaryColor,
                            child: InkWell(
                              child: Ink(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.only(top: 8.0),
                                        child: Icon(
                                          Icons.merge_outlined,
                                          size: 30,
                                        ),
                                      ),
                                      Text(
                                          trs.translate("merge") ?? "Merge",
                                          style: Theme
                                              .of(context)
                                              .textTheme
                                              .labelSmall
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              onTap: () {},
                            ),
                          ),
                          Material(
                            color: Theme
                                .of(context)
                                .primaryColor,
                            child: InkWell(
                              child: Ink(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.only(top: 8.0),
                                        child: Icon(
                                          Icons.call_split_outlined,
                                          size: 30,
                                        ),
                                      ),
                                      Text(
                                          trs.translate("divide") ?? "Divide",
                                          style: Theme
                                              .of(context)
                                              .textTheme
                                              .labelSmall
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              onTap: () {},
                            ),
                          ),
                          Material(
                            color: Theme
                                .of(context)
                                .primaryColor,
                            child: InkWell(
                              child: Ink(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.only(top: 8.0),
                                        child: Icon(
                                          Icons.calendar_month,
                                          size: 30,
                                        ),
                                      ),
                                      Text(
                                          trs.translate("reserve") ??
                                              "To reserve",
                                          style: Theme
                                              .of(context)
                                              .textTheme
                                              .labelSmall
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              onTap: () {},
                            ),
                          ),
                        ],
                      ),
                    )
                        : Ink(
                      color: Theme
                          .of(context)
                          .primaryColor,
                      width: (orientation == Orientation.portrait) ? MediaQuery
                          .of(context)
                          .size
                          .width / 6 : MediaQuery
                          .of(context)
                          .size
                          .width / 8,
                      child: ListView(
                        scrollDirection: Axis.vertical,
                        children: [
                          Material(
                            color: Theme
                                .of(context)
                                .primaryColor,
                            child: InkWell(
                              child: Ink(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.only(top: 8.0),
                                        child: Icon(
                                          Icons.merge_outlined,
                                          size: 30,
                                        ),
                                      ),
                                      Text(
                                          trs.translate("merge") ?? "Merge",
                                          style: Theme
                                              .of(context)
                                              .textTheme
                                              .labelSmall
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              onTap: () {
                                if (globals.selectedTables.length > 1) {
                                  setState(() {
                                    mergeDialog(context);
                                  });
                                }
                                else if ((globals.selectedTables.length == 1 ||
                                    globals.selectedTables.isEmpty) &&
                                    globals.selectable == true) {
                                  setState(() {
                                    globals.selectable = false;
                                    globals.selectedTables.clear();
                                    globals.slctTblGuids.clear();
                                  });
                                }
                                else {
                                  setState(() {
                                    globals.selectable = true;
                                  });
                                }
                              },
                            ),
                          ),
                          Divider(thickness: 2,color: Theme.of(context).dividerColor),
                          Material(
                            color: Theme
                                .of(context)
                                .primaryColor,
                            child: InkWell(
                              child: Ink(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.only(top: 8.0),
                                        child: Icon(
                                          Icons.call_split_outlined,
                                          size: 30,
                                        ),
                                      ),
                                      Text(
                                          trs.translate("divide") ?? "Divide",
                                          style: Theme
                                              .of(context)
                                              .textTheme
                                              .labelSmall
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              onTap: () {
                                if (globals.dividableTables.isNotEmpty) {
                                  setState(() {
                                    divideDialog(context);
                                  });
                                }
                                else if ((globals.dividableTables.isEmpty) &&
                                    globals.selectable == true) {
                                  setState(() {
                                    globals.selectable = false;
                                    globals.selectedTables.clear();
                                    globals.dividableTables.clear();
                                    globals.slctTblGuids.clear();
                                  });
                                }
                                else {
                                  setState(() {
                                    globals.selectable = true;
                                  });
                                }
                              },
                            ),
                          ),
                          Divider(thickness: 2,color: Theme.of(context).dividerColor),
                          Material(
                            color: Theme
                                .of(context)
                                .primaryColor,
                            child: InkWell(
                              child: Ink(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.only(top: 8.0),
                                        child: Icon(
                                          Icons.calendar_month,
                                          size: 30,
                                        ),
                                      ),
                                      Text(
                                          trs.translate("reserve") ??
                                              "To reserve",
                                          style: Theme
                                              .of(context)
                                              .textTheme
                                              .labelSmall
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              onTap: () {
                                setState(() {
                                  globals.reservable = !globals.reservable;
                                });
                              },
                            ),
                          ),
                          Divider(thickness: 2,color: Theme.of(context).dividerColor),
                          Material(
                            color: Theme
                                .of(context)
                                .primaryColor,
                            child: InkWell(
                              child: Ink(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.only(top: 8.0),
                                        child: Icon(
                                          Icons.receipt,
                                          size: 30,
                                        ),
                                      ),
                                      Text(
                                          trs.translate("reservations") ??
                                              "Reservations",
                                          style: Theme
                                              .of(context)
                                              .textTheme
                                              .labelSmall
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              onTap: () {
                                GoRouter.of(context).go('/reservationsPage');
                              },
                            ),
                          ),
                          Divider(thickness: 2,color: Theme.of(context).dividerColor),
                          Material(
                            color: Theme
                                .of(context)
                                .primaryColor,
                            child: InkWell(
                              child: Ink(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.only(top: 8.0),
                                        child: Icon(
                                          Icons.print,
                                          size: 30,
                                        ),
                                      ),
                                      Text(
                                          "Print",
                                          style: Theme
                                              .of(context)
                                              .textTheme
                                              .labelSmall
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              onTap: () {
                                GoRouter.of(context).go('/printPage');
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }

  Future<bool> handlePop(BuildContext context) async {
    if (globals.selectable) {
      setState(() {
        globals.selectable = false;
        globals.selectedTables.clear();
        globals.dividableTables.clear();
        globals.slctTblGuids.clear();
      });
      return false;
    }
    else if (globals.reservable) {
      setState(() {
        globals.reservable = false;
      });
    }
    else {
      if (Platform.isAndroid) {
        SystemNavigator.pop();
      } else if (Platform.isIOS) {
        exit(0);
      }
      return true;
    }
    return true;
  }

  Future<void> _showDialog(BuildContext context) async {
    final trs = AppLocalizations.of(context);
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: SizedBox(
            height: MediaQuery
                .of(context)
                .size
                .height / 4,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text(trs.translate("no_internet_txt") ??
                      "Do you want to be in offline mode or go to server settings?",
                      style: Theme
                          .of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(fontSize: 17)),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            Column(
                children: [
                  TextButton(onPressed: () {
                    context.read<RestoPosHomePageCubit>().reloadData(
                        loadMode: DbConnectionMode.offlineMode.value);
                    Navigator.pop(context);
                  },
                      child: Text(
                          trs.translate("offline_mode") ?? "Offline mode",
                          style: Theme
                              .of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(fontSize: 17, color: Colors.blue))),

                  TextButton(onPressed: () {
                    GoRouter.of(context).go('/serverSettings');
                  },
                      child: Text(
                          trs.translate("server_settings") ?? "Server settings",
                          style: Theme
                              .of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(fontSize: 17, color: Colors.blue))),
                ]
            )
          ],
        );
      },
    );
  }

  Future<void> mergeDialog(BuildContext context) async {
    final trs = AppLocalizations.of(context);
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.onSecondary,
          content: SizedBox(
            height: MediaQuery
                .of(context)
                .size
                .height / 4,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text(trs.translate("merge_text") ??
                      "Tables below will be merged: ", style: Theme
                      .of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(fontSize: 17)),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      children: globals.selectedTables.map((TblDkTable table) {
                        return Text(table.TableName);
                      }).toList(),
                    ),
                  )
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                trs.translate('back') ?? 'Back',
                style: Theme.of(context).textTheme.labelMedium,
              ),
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  globals.selectable = false;
                  globals.selectedTables.clear();
                  globals.slctTblGuids.clear();
                });
              },
            ),
            TextButton(
                child: Text(
                    trs.translate("ok") ?? 'OK',
                    style: Theme.of(context).textTheme.labelMedium,
                ),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                    mergeDialog2(context);
                  });
                }
            ),
          ],
        );
      },
    );
  }

  Future<void> mergeDialog2(BuildContext context) async {
    final trs = AppLocalizations.of(context);
    GlobalVarsProvider globalVarsProvider = Provider.of<GlobalVarsProvider>(
        context, listen: false);
    TextEditingController nameCtrl = TextEditingController();
    TextEditingController countCtrl = TextEditingController();
    TextEditingController descCtrl = TextEditingController();
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.onSecondary,
          scrollable: true,
          content: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(trs.translate("fill_to_merge_txt") ??
                      "Fill in the fields to merge tables: ", style: Theme
                      .of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(fontSize: 17)),
                  Text(trs.translate("tb_name_label") ?? "Table's name:"),
                  TextField(
                    style: TextStyle(color: Theme.of(context).canvasColor),
                    controller: nameCtrl,
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Theme.of(context).cardColor,
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
                    keyboardType: TextInputType.name,
                  ),
                  Text(trs.translate("person_count") ?? "Person count:"),
                  TextField(
                    style: TextStyle(color: Theme.of(context).canvasColor),
                    controller: countCtrl,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Theme.of(context).cardColor,
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
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(2),
                    ],
                  ),
                  Text(trs.translate("desc_txt") ?? "Table's description:"),
                  TextFormField(
                    style: TextStyle(color: Theme.of(context).canvasColor),
                    controller: descCtrl,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Theme.of(context).cardColor,
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
                    keyboardType: TextInputType.text,
                    minLines: 3,
                    maxLines: 10,
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                trs.translate("back") ?? "Back",
                style: Theme.of(context).textTheme.labelMedium,
              ),
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  globals.selectable = false;
                });
              },
            ),
            TextButton(
                child: Text(
                    trs.translate("ok") ?? 'OK',
                    style: Theme.of(context).textTheme.labelMedium,
                ),
                onPressed: () {
                  int personCount = int.tryParse(countCtrl.text) ?? 8;
                  TblDkTable mergedTable = TblDkTable(TableId: 0,
                      TableGuid: const Uuid().v4(),
                      SaleCardId: 0,
                      CId: globalVarsProvider.getUser?.CId ?? 0,
                      DivId: globalVarsProvider.getUser?.DivId ?? 0,
                      WpId: 0,
                      TableStatusId: 2,
                      TableTypeId: 3,
                      CatId: globals.selectedTables[0].CatId,
                      TableName: nameCtrl.text,
                      TableDesc: descCtrl.text,
                      TablePersonCount: personCount,
                      TableGroupGuid: const Uuid().v4(),
                      AddInf1: globals.selectedTables[0].AddInf1,
                      AddInf2: globals.selectedTables[0].AddInf2,
                      AddInf3: globals.selectedTables[0].AddInf3,
                      AddInf4: "",
                      AddInf5: "",
                      AddInf6: "",
                      AddInf7: "",
                      AddInf8: "",
                      AddInf9: "",
                      AddInf10: "",
                      CreatedDate: null,
                      ModifiedDate: null,
                      CreatedUId: 0,
                      ModifiedUId: 0,
                      SyncDateTime: null,
                      EmpId: globalVarsProvider.getUser?.EmpId ?? 0,
                      MergedTablesCount: globals.selectedTables.length);
                  context.read<RestoPosHomePageCubit>().mergeTables(
                      globals.slctTblGuids, mergedTable);
                  setState(() {
                    globals.selectable = false;
                  });
                  Navigator.pop(context);
                }
            ),
          ],
        );
      },
    );
  }

  Future<void> divideDialog(BuildContext context) async {
    final trs = AppLocalizations.of(context);
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: SizedBox(
            height: MediaQuery
                .of(context)
                .size
                .height / 4,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text(trs.translate("divide_txt") ??
                      "Tables below will be divided: ", style: Theme
                      .of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(fontSize: 17)),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      children: globals.dividableTables.map((e) {
                        return Text(e.TableName);
                      }).toList(),
                    ),
                  )
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                trs.translate("back") ?? 'Back'
              ),
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  globals.selectable = false;
                  globals.dividableTables.clear();
                });
              },
            ),
            TextButton(
                child: Text(
                    trs.translate("ok") ?? 'OK'
                ),
                onPressed: () {
                  Navigator.pop(context);
                  context.read<RestoPosHomePageCubit>().divideTables(
                      globals.dividableTables);
                }
            ),
          ],
        );
      },
    );
  }
}

class TablesTabBar extends StatefulWidget {
  final Device deviceType;
  final Orientation orientation;
  final List<TblDkTable> tables;

  const TablesTabBar(this.orientation, this.deviceType,
      {super.key, required this.tables});

  @override
  State<TablesTabBar> createState() => _TablesTabBarState();
}

class _TablesTabBarState extends State<TablesTabBar> {

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        backgroundColor: Theme.of(context).cardColor,
        onRefresh: () async {
          context.read<RestoPosHomePageCubit>().reloadData();
        },
        child: GridView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: (MediaQuery
                    .of(context)
                    .orientation == Orientation.portrait) ? 1.2 : 1.22,
                mainAxisSpacing: 5,
                crossAxisCount: (MediaQuery
                    .of(context)
                    .orientation == Orientation.portrait) ? 2 : 4),
            scrollDirection: Axis.vertical,
            padding: const EdgeInsets.all(10),
            itemCount: widget.tables.length,
            itemBuilder: (context, index) {
              if (globals.selectable == false && globals.reservable == false) {
                return CustomTablesRow(
                    price: 50.0, table: widget.tables[index],
                    orientation: widget.orientation,
                    onLongPress: makeSelectable);
              }
              else
              if (globals.reservable == false && globals.selectable == true) {
                return SlctCustomTablesRow(price: 50.0,
                    table: widget.tables[index],
                    orientation: widget.orientation);
              }
              else {
                return ReserveTablesRow(price: 50.0,
                    table: widget.tables[index],
                    orientation: widget.orientation);
              }
            }
        )
    );
  }

  void makeSelectable() {
    setState(() {
      globals.selectable = true;
    });
  }
}

class Chair extends StatelessWidget {
  final bool underContainer;
  final Orientation orientation;
  final double width;
  final double height;

  const Chair(
      {required this.orientation, required this.underContainer, super.key, required this.width, required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
          color: Theme
              .of(context)
              .colorScheme
              .secondaryContainer,
          borderRadius: underContainer
              ? const BorderRadius.only(
              bottomRight: Radius.circular(10), bottomLeft: Radius.circular(10))
              : const BorderRadius.only(
              topRight: Radius.circular(10), topLeft: Radius.circular(10))),
    );
  }
}

class ManyChair extends StatelessWidget {
  final Orientation orientation;

  const ManyChair({super.key, required this.orientation});

  @override
  Widget build(BuildContext context) {
    return (orientation == Orientation.portrait) ?
    SizedBox(
        width: MediaQuery
            .sizeOf(context)
            .width / 12,
        height: MediaQuery
            .sizeOf(context)
            .height / 40,
        child: Stack(
          children: [
            Container(
                width: MediaQuery
                    .sizeOf(context)
                    .width / 12,
                height: MediaQuery
                    .sizeOf(context)
                    .height / 40,
                decoration: BoxDecoration(
                    color: Theme
                        .of(context)
                        .colorScheme
                        .secondaryContainer,
                    borderRadius: const BorderRadius.only(
                        bottomRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10)),
                    border: Border.all(color: Theme
                        .of(context)
                        .primaryColor)
                )
            ),
            Align(
                alignment: Alignment.topLeft,
                child: Container(
                    width: MediaQuery
                        .sizeOf(context)
                        .width / 15,
                    height: MediaQuery
                        .sizeOf(context)
                        .height / 51,
                    decoration: BoxDecoration(
                        color: Theme
                            .of(context)
                            .colorScheme
                            .secondaryContainer,
                        borderRadius: const BorderRadius.only(
                            bottomRight: Radius.circular(7),
                            bottomLeft: Radius.circular(7)),
                        border: Border.all(color: Theme
                            .of(context)
                            .primaryColor)
                    )
                )
            ),
            Align(
                alignment: Alignment.topLeft,
                child: Container(
                    width: MediaQuery
                        .sizeOf(context)
                        .width / 20,
                    height: MediaQuery
                        .sizeOf(context)
                        .height / 67,
                    decoration: BoxDecoration(
                        color: Theme
                            .of(context)
                            .colorScheme
                            .secondaryContainer,
                        borderRadius: const BorderRadius.only(
                            bottomRight: Radius.circular(4),
                            bottomLeft: Radius.circular(4)),
                        border: Border.all(color: Theme
                            .of(context)
                            .primaryColor)
                    )
                )
            )
          ],
        )
    )
        : SizedBox(
        width: MediaQuery
            .sizeOf(context)
            .width / 22,
        height: MediaQuery
            .sizeOf(context)
            .height / 22,
        child: Stack(
          children: [
            Container(
                width: MediaQuery
                    .sizeOf(context)
                    .width / 22,
                height: MediaQuery
                    .sizeOf(context)
                    .height / 22,
                decoration: BoxDecoration(
                    color: Theme
                        .of(context)
                        .colorScheme
                        .secondaryContainer,
                    borderRadius: const BorderRadius.only(
                        bottomRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10)),
                    border: Border.all(color: Theme
                        .of(context)
                        .primaryColor)
                )
            ),
            Align(
                alignment: Alignment.topLeft,
                child: Container(
                    width: MediaQuery
                        .sizeOf(context)
                        .width / 24,
                    height: MediaQuery
                        .sizeOf(context)
                        .height / 28,
                    decoration: BoxDecoration(
                        color: Theme
                            .of(context)
                            .colorScheme
                            .secondaryContainer,
                        borderRadius: const BorderRadius.only(
                            bottomRight: Radius.circular(7),
                            bottomLeft: Radius.circular(7)),
                        border: Border.all(color: Theme
                            .of(context)
                            .primaryColor)
                    )
                )
            ),
            Align(
                alignment: Alignment.topLeft,
                child: Container(
                    width: MediaQuery
                        .sizeOf(context)
                        .width / 30,
                    height: MediaQuery
                        .sizeOf(context)
                        .height / 33,
                    decoration: BoxDecoration(
                        color: Theme
                            .of(context)
                            .colorScheme
                            .secondaryContainer,
                        borderRadius: const BorderRadius.only(
                            bottomRight: Radius.circular(4),
                            bottomLeft: Radius.circular(4)),
                        border: Border.all(color: Theme
                            .of(context)
                            .primaryColor)
                    )
                )
            )
          ],
        )
    );
  }
}

class CustomTable extends StatefulWidget {
  final Orientation orientation;
  final GlobalVarsProvider globalProvider;
  final TblDkTable table;
  final Color? borderColor;

  const CustomTable(
      {super.key, required this.orientation, required this.table, this.borderColor, required this.globalProvider});

  @override
  State<CustomTable> createState() => _CustomTableState();
}

class _CustomTableState extends State<CustomTable> {
  double sum = 0;
  String formattedPrice = '';

  @override
  void initState() {
    if(widget.globalProvider.getCartItems.where((element) => element.TableId==widget.table.TableId).isNotEmpty) {
      for (var item in widget.globalProvider
          .getCartItems
          .where((element) => element.TableId == widget.table.TableId)) {
        sum += item.ItemPriceTotal;
      }
    }
    else{
      sum = 0;
    }
    formattedPrice = sum.toStringAsFixed(2);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    GlobalVarsProvider globalVarsProvider = Provider.of<GlobalVarsProvider>(
        context);
    DateTime now = DateTime.now();
    return (widget.orientation == Orientation.portrait) ?
    (widget.table.TableTypeId == 3) ?
    Padding(
        padding: const EdgeInsets.all(10),
        child: SizedBox(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 3.5),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: (widget.table.TablePersonCount > 8) ? List
                        .generate(
                        (widget.table.TablePersonCount % 2 == 0) ? (widget.table
                            .TablePersonCount / 2).round() : (widget.table
                            .TablePersonCount / 2).round() - 1, (index) {
                      return (
                          (widget.table.TablePersonCount / 2).round() < 3) ?
                      Chair(orientation: widget.orientation,
                          underContainer: false, width: MediaQuery
                              .sizeOf(context)
                              .width / 12, height: MediaQuery
                              .sizeOf(context)
                              .height / 50)
                          : Chair(orientation: widget.orientation,
                          underContainer: false,
                          width: MediaQuery
                              .sizeOf(context)
                              .width / 18,
                          height: MediaQuery
                              .sizeOf(context)
                              .height / 50);
                    }).sublist(0, 4)
                        : List.generate(
                        (widget.table.TablePersonCount % 2 == 0) ? (widget.table
                            .TablePersonCount / 2).round() : (widget.table
                            .TablePersonCount / 2).round() - 1, (index) {
                      return ((widget.table.TablePersonCount / 2).round() < 3) ?
                      Chair(orientation: widget.orientation,
                          underContainer: false, width: MediaQuery
                              .sizeOf(context)
                              .width / 12, height: MediaQuery
                              .sizeOf(context)
                              .height / 50)
                          : Chair(orientation: widget.orientation,
                          underContainer: false,
                          width: MediaQuery
                              .sizeOf(context)
                              .width / 18,
                          height: MediaQuery
                              .sizeOf(context)
                              .height / 50);
                    })
                ),
              ),
              Expanded(
                child: Stack(
                  children: [
                    Container(
                      constraints: const BoxConstraints(),
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                          color: globalVarsProvider.getReservations.where((e) =>
                          (e.TableId == widget.table.TableId
                              && e.TableId == widget.table.TableId &&
                              e.EventStartDate!.year == now.year &&
                              e.EventStartDate!.month == now.month &&
                              e.EventStartDate!.day == now.day &&
                              e.EventStartDate!.hour == now.hour &&
                              e.EventStartDate!.minute <= now.minute
                              && e.EventEndDate!.year == now.year &&
                              e.EventEndDate!.month == now.month &&
                              e.EventEndDate!.day == now.day &&
                              e.EventEndDate!.hour >= now.hour &&
                              e.EventEndDate!.minute >= now.minute)).isNotEmpty
                              ?
                          Theme
                              .of(context)
                              .indicatorColor
                              : Theme
                              .of(context)
                              .colorScheme
                              .secondaryContainer,
                          border: Border.all(color: widget.borderColor ?? Theme
                              .of(context)
                              .indicatorColor, width: 2),
                          borderRadius: const BorderRadius.all(
                              Radius.circular(10))
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 8.0),
                      child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(widget.table.TableName, style: Theme
                              .of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(fontSize: 17, color: Colors.white),
                            softWrap: false,)
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      child: Padding(
                          padding: const EdgeInsets.only(
                              left: 8.0, bottom: 3),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment
                                  .start,
                              children: [
                                Text("Jemi", style: Theme
                                    .of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(
                                    fontSize: 17, color: Colors.white)),
                                Text("$formattedPrice TMT",
                                    style: Theme
                                        .of(context)
                                        .textTheme
                                        .bodySmall!
                                        .copyWith(
                                        fontSize: 13, color: Colors.white)),
                              ]
                          )
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        decoration: BoxDecoration(
                            color: Theme
                                .of(context)
                                .colorScheme
                                .secondary,
                            borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(10),
                                bottomRight: Radius.circular(
                                    10))
                        ),
                        width: MediaQuery
                            .of(context)
                            .size
                            .width / 23,
                      ),
                    ),
                    Visibility(
                      visible: globalVarsProvider.getReservations.where((e) =>
                      (e.TableId == widget.table.TableId &&
                          e.EventStartDate!.year == now.year &&
                          e.EventStartDate!.month == now.month &&
                          e.EventStartDate!.day == now.day &&
                          e.EventStartDate!.hour >= now.hour
                          && e.EventEndDate!.year == now.year && e.EventEndDate!
                          .month == now.month && e.EventEndDate!.day ==
                          now.day &&
                          e.EventEndDate!.hour >= now.hour &&
                          e.EventEndDate!.minute >= now.minute)).isNotEmpty,
                      child: const Align(
                          alignment: Alignment.topRight,
                          child: Padding(
                            padding: EdgeInsets.only(right: 21.0),
                            child: Icon(Icons.access_time, color: Colors.white),
                          )
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 3.5),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: (widget.table.TablePersonCount > 8) ? List
                        .generate(
                      (widget.table.TablePersonCount / 2).round(), (index) {
                      return ((widget.table.TablePersonCount / 2).round() < 3) ?
                      Chair(orientation: widget.orientation,
                          underContainer: true, width: MediaQuery
                              .sizeOf(context)
                              .width / 12, height: MediaQuery
                              .sizeOf(context)
                              .height / 50)
                          : ((widget.table.TablePersonCount / 2).round() > 4 &&
                          index == 3) ?
                      ManyChair(orientation: widget.orientation)
                          : Chair(orientation: widget.orientation,
                          underContainer: true,
                          width: MediaQuery
                              .sizeOf(context)
                              .width / 18,
                          height: MediaQuery
                              .sizeOf(context)
                              .height / 50);
                    },
                    ).sublist(0, 4)
                        : List.generate(
                      (widget.table.TablePersonCount / 2).round(), (index) {
                      return ((widget.table.TablePersonCount / 2).round() < 3) ?
                      Chair(orientation: widget.orientation,
                          underContainer: true, width: MediaQuery
                              .sizeOf(context)
                              .width / 12, height: MediaQuery
                              .sizeOf(context)
                              .height / 50)
                          : ((widget.table.TablePersonCount / 2).round() > 4 &&
                          index == 3) ?
                      ManyChair(orientation: widget.orientation)
                          : Chair(orientation: widget.orientation,
                          underContainer: true,
                          width: MediaQuery
                              .sizeOf(context)
                              .width / 18,
                          height: MediaQuery
                              .sizeOf(context)
                              .height / 50);
                    },
                    )
                ),
              ),
            ],
          ),
        ))
        : Padding(
        padding: const EdgeInsets.all(10),
        child: SizedBox(
          height: MediaQuery
              .of(context)
              .size
              .height / 6,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 3.5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment
                      .spaceAround,
                  children: [
                    Chair(orientation: widget.orientation,
                        underContainer: false, width: MediaQuery
                            .sizeOf(context)
                            .width / 12, height: MediaQuery
                            .sizeOf(context)
                            .height / 50),
                    Chair(orientation: widget.orientation,
                        underContainer: false, width: MediaQuery
                            .sizeOf(context)
                            .width / 12, height: MediaQuery
                            .sizeOf(context)
                            .height / 50),
                  ],
                ),
              ),
              Expanded(
                child: Stack(
                  children: [
                    Container(
                      constraints: const BoxConstraints(),
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                          color: globalVarsProvider.getReservations.where((e) =>
                          (e.TableId == widget.table.TableId
                              && e.TableId == widget.table.TableId &&
                              e.EventStartDate!.year == now.year &&
                              e.EventStartDate!.month == now.month &&
                              e.EventStartDate!.day == now.day &&
                              e.EventStartDate!.hour == now.hour &&
                              e.EventStartDate!.minute <= now.minute
                              && e.EventEndDate!.year == now.year &&
                              e.EventEndDate!.month == now.month &&
                              e.EventEndDate!.day == now.day &&
                              e.EventEndDate!.hour >= now.hour &&
                              e.EventEndDate!.minute >= now.minute)).isNotEmpty
                              ?
                          Theme
                              .of(context)
                              .indicatorColor
                              : Theme
                              .of(context)
                              .colorScheme
                              .secondaryContainer,
                          borderRadius: const BorderRadius.all(
                              Radius.circular(10)),
                          border: Border.all(color: widget.borderColor ?? Theme
                              .of(context)
                              .shadowColor)
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 8.0),
                      child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(widget.table.TableName, style: Theme
                              .of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(fontSize: 17, color: Colors.white),
                              softWrap: false)
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      child: Padding(
                          padding: const EdgeInsets.only(
                              left: 8.0, bottom: 3),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment
                                  .start,
                              children: [
                                Text("Jemi", style: Theme
                                    .of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(
                                    fontSize: 17, color: Colors.white)),
                                Text("$formattedPrice TMT",
                                    style: Theme
                                        .of(context)
                                        .textTheme
                                        .bodySmall!
                                        .copyWith(
                                        fontSize: 13, color: Colors.white)),
                              ]
                          )
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        decoration: BoxDecoration(
                            color: Theme
                                .of(context)
                                .colorScheme
                                .secondary,
                            borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(10),
                                bottomRight: Radius.circular(
                                    10))
                        ),
                        width: MediaQuery
                            .of(context)
                            .size
                            .width / 23,
                      ),
                    ),
                    Visibility(
                      visible: globalVarsProvider.getReservations.where((e) =>
                      (e.TableId == widget.table.TableId &&
                          e.EventStartDate!.year == now.year &&
                          e.EventStartDate!.month == now.month &&
                          e.EventStartDate!.day == now.day &&
                          e.EventStartDate!.hour >= now.hour
                          && e.EventEndDate!.year == now.year && e.EventEndDate!
                          .month == now.month && e.EventEndDate!.day ==
                          now.day &&
                          e.EventEndDate!.hour >= now.hour &&
                          e.EventEndDate!.minute >= now.minute)).isNotEmpty,
                      child: const Align(
                          alignment: Alignment.topRight,
                          child: Padding(
                            padding: EdgeInsets.only(right: 21.0),
                            child: Icon(Icons.access_time, color: Colors.white),
                          )
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 3.5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment
                      .spaceAround,
                  children: [
                    Chair(orientation: widget.orientation,
                        underContainer: true, width: MediaQuery
                            .sizeOf(context)
                            .width / 12, height: MediaQuery
                            .sizeOf(context)
                            .height / 50),
                    Chair(orientation: widget.orientation,
                        underContainer: true, width: MediaQuery
                            .sizeOf(context)
                            .width / 12, height: MediaQuery
                            .sizeOf(context)
                            .height / 50),
                  ],
                ),
              ),
            ],
          ),
        )
    )
        : (widget.table.TableTypeId == 3) ?
    Padding(
        padding: const EdgeInsets.all(10),
        child: SizedBox(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 3.5),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: (widget.table.TablePersonCount > 8) ? List
                        .generate(
                        (widget.table.TablePersonCount % 2 == 0) ? (widget.table
                            .TablePersonCount / 2).round() : (widget.table
                            .TablePersonCount / 2).round() - 1, (index) {
                      return (
                          (widget.table.TablePersonCount / 2).round() < 3) ?
                      Chair(orientation: widget.orientation,
                          underContainer: false, width: MediaQuery
                              .sizeOf(context)
                              .width / 22, height: MediaQuery
                              .sizeOf(context)
                              .height / 24)
                          : Chair(orientation: widget.orientation,
                          underContainer: false,
                          width: MediaQuery
                              .sizeOf(context)
                              .width / 28,
                          height: MediaQuery
                              .sizeOf(context)
                              .height / 33);
                    }).sublist(0, 4)
                        : List.generate(
                        (widget.table.TablePersonCount % 2 == 0) ? (widget.table
                            .TablePersonCount / 2).round() : (widget.table
                            .TablePersonCount / 2).round() - 1, (index) {
                      return ((widget.table.TablePersonCount / 2).round() < 3) ?
                      Chair(orientation: widget.orientation,
                          underContainer: false, width: MediaQuery
                              .sizeOf(context)
                              .width / 22, height: MediaQuery
                              .sizeOf(context)
                              .height / 22)
                          : Chair(orientation: widget.orientation,
                          underContainer: false,
                          width: MediaQuery
                              .sizeOf(context)
                              .width / 28,
                          height: MediaQuery
                              .sizeOf(context)
                              .height / 33);
                    })
                ),
              ),
              Expanded(
                child: Stack(
                  children: [
                    Container(
                      constraints: const BoxConstraints(),
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                          color: globalVarsProvider.getReservations.where((e) =>
                          (e.TableId == widget.table.TableId
                              && e.TableId == widget.table.TableId &&
                              e.EventStartDate!.year == now.year &&
                              e.EventStartDate!.month == now.month &&
                              e.EventStartDate!.day == now.day &&
                              e.EventStartDate!.hour == now.hour &&
                              e.EventStartDate!.minute <= now.minute
                              && e.EventEndDate!.year == now.year &&
                              e.EventEndDate!.month == now.month &&
                              e.EventEndDate!.day == now.day &&
                              e.EventEndDate!.hour >= now.hour &&
                              e.EventEndDate!.minute >= now.minute)).isNotEmpty
                              ?
                          Theme
                              .of(context)
                              .indicatorColor
                              : Theme
                              .of(context)
                              .colorScheme
                              .secondaryContainer,
                          border: Border.all(color: widget.borderColor ?? Theme
                              .of(context)
                              .indicatorColor, width: 2),
                          borderRadius: const BorderRadius.all(
                              Radius.circular(10))
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 8.0),
                      child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(widget.table.TableName, style: Theme
                              .of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(fontSize: 17, color: Colors.white),
                              softWrap: false)
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      child: Padding(
                          padding: const EdgeInsets.only(
                              left: 8.0, bottom: 3),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment
                                  .start,
                              children: [
                                Text("Jemi", style: Theme
                                    .of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(
                                    fontSize: 17, color: Colors.white)),
                                Text("$formattedPrice TMT",
                                    style: Theme
                                        .of(context)
                                        .textTheme
                                        .bodySmall!
                                        .copyWith(
                                        fontSize: 13, color: Colors.white)),
                              ]
                          )
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        decoration: BoxDecoration(
                            color: Theme
                                .of(context)
                                .colorScheme
                                .secondary,
                            borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(10),
                                bottomRight: Radius.circular(
                                    10))
                        ),
                        width: MediaQuery
                            .of(context)
                            .size
                            .width / 36,
                      ),
                    ),
                    Visibility(
                      visible: globalVarsProvider.getReservations.where((e) =>
                      (e.TableId == widget.table.TableId &&
                          e.EventStartDate!.year == now.year &&
                          e.EventStartDate!.month == now.month &&
                          e.EventStartDate!.day == now.day &&
                          e.EventStartDate!.hour >= now.hour
                          && e.EventEndDate!.year == now.year && e.EventEndDate!
                          .month == now.month && e.EventEndDate!.day ==
                          now.day &&
                          e.EventEndDate!.hour >= now.hour &&
                          e.EventEndDate!.minute >= now.minute)).isNotEmpty,
                      child: const Align(
                          alignment: Alignment.topRight,
                          child: Padding(
                            padding: EdgeInsets.only(right: 21.0),
                            child: Icon(Icons.access_time, color: Colors.white),
                          )
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 3.5),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: (widget.table.TablePersonCount > 8) ? List
                        .generate(
                      (widget.table.TablePersonCount / 2).round(), (index) {
                      return ((widget.table.TablePersonCount / 2).round() < 3) ?
                      Chair(orientation: widget.orientation,
                          underContainer: true, width: MediaQuery
                              .sizeOf(context)
                              .width / 22, height: MediaQuery
                              .sizeOf(context)
                              .height / 22)
                          : ((widget.table.TablePersonCount / 2).round() > 4 &&
                          index == 3) ?
                      ManyChair(orientation: widget.orientation)
                          : Chair(orientation: widget.orientation,
                          underContainer: true,
                          width: MediaQuery
                              .sizeOf(context)
                              .width / 28,
                          height: MediaQuery
                              .sizeOf(context)
                              .height / 33);
                    },
                    ).sublist(0, 4)
                        : List.generate(
                      (widget.table.TablePersonCount / 2).round(), (index) {
                      return ((widget.table.TablePersonCount / 2).round() < 3) ?
                      Chair(orientation: widget.orientation,
                          underContainer: true, width: MediaQuery
                              .sizeOf(context)
                              .width / 22, height: MediaQuery
                              .sizeOf(context)
                              .height / 22)
                          : ((widget.table.TablePersonCount / 2).round() > 4 &&
                          index == 3) ?
                      ManyChair(orientation: widget.orientation)
                          : Chair(orientation: widget.orientation,
                          underContainer: true,
                          width: MediaQuery
                              .sizeOf(context)
                              .width / 28,
                          height: MediaQuery
                              .sizeOf(context)
                              .height / 33);
                    },
                    )
                ),
              ),
            ],
          ),
        ))
        : Padding(
        padding: const EdgeInsets.all(10),
        child: SizedBox(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 3.5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment
                      .spaceAround,
                  children: [
                    Chair(orientation: widget.orientation,
                        underContainer: false, width: MediaQuery
                            .sizeOf(context)
                            .width / 22, height: MediaQuery
                            .sizeOf(context)
                            .height / 22),
                    Chair(orientation: widget.orientation,
                        underContainer: false, width: MediaQuery
                            .sizeOf(context)
                            .width / 22, height: MediaQuery
                            .sizeOf(context)
                            .height / 22),
                  ],
                ),
              ),
              Expanded(
                child: Stack(
                  children: [
                    Container(
                      constraints: const BoxConstraints(),
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                          color: globalVarsProvider.getReservations.where((e) =>
                          (e.TableId == widget.table.TableId
                              && e.TableId == widget.table.TableId &&
                              e.EventStartDate!.year == now.year &&
                              e.EventStartDate!.month == now.month &&
                              e.EventStartDate!.day == now.day &&
                              e.EventStartDate!.hour == now.hour &&
                              e.EventStartDate!.minute <= now.minute
                              && e.EventEndDate!.year == now.year &&
                              e.EventEndDate!.month == now.month &&
                              e.EventEndDate!.day == now.day &&
                              e.EventEndDate!.hour >= now.hour &&
                              e.EventEndDate!.minute >= now.minute)).isNotEmpty
                              ?
                          Theme
                              .of(context)
                              .indicatorColor
                              : Theme
                              .of(context)
                              .colorScheme
                              .secondaryContainer,
                          borderRadius: const BorderRadius.all(
                              Radius.circular(10)),
                          border: Border.all(color: widget.borderColor ?? Theme
                              .of(context)
                              .shadowColor)
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 8.0),
                      child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(widget.table.TableName, style: Theme
                              .of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(fontSize: 17, color: Colors.white),
                              softWrap: false)
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      child: Padding(
                          padding: const EdgeInsets.only(
                              left: 8.0, bottom: 3),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment
                                  .start,
                              children: [
                                Text("Jemi", style: Theme
                                    .of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(
                                    fontSize: 17, color: Colors.white)),
                                Text("$formattedPrice TMT",
                                    style: Theme
                                        .of(context)
                                        .textTheme
                                        .bodySmall!
                                        .copyWith(
                                        fontSize: 13, color: Colors.white)),
                              ]
                          )
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        decoration: BoxDecoration(
                            color: Theme
                                .of(context)
                                .colorScheme
                                .secondary,
                            borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(10),
                                bottomRight: Radius.circular(
                                    10))
                        ),
                        width: MediaQuery
                            .of(context)
                            .size
                            .width / 36,
                      ),
                    ),
                    Visibility(
                      visible: globalVarsProvider.getReservations.where((e) =>
                      (e.TableId == widget.table.TableId &&
                          e.EventStartDate!.year == now.year &&
                          e.EventStartDate!.month == now.month &&
                          e.EventStartDate!.day == now.day &&
                          e.EventStartDate!.hour >= now.hour
                          && e.EventEndDate!.year == now.year && e.EventEndDate!
                          .month == now.month && e.EventEndDate!.day ==
                          now.day &&
                          e.EventEndDate!.hour >= now.hour &&
                          e.EventEndDate!.minute >= now.minute)).isNotEmpty,
                      child: const Align(
                          alignment: Alignment.topRight,
                          child: Padding(
                            padding: EdgeInsets.only(right: 21.0),
                            child: Icon(Icons.access_time, color: Colors.white),
                          )
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 3.5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment
                      .spaceAround,
                  children: [
                    Chair(orientation: widget.orientation,
                        underContainer: true, width: MediaQuery
                            .sizeOf(context)
                            .width / 22, height: MediaQuery
                            .sizeOf(context)
                            .height / 22),
                    Chair(orientation: widget.orientation,
                        underContainer: true, width: MediaQuery
                            .sizeOf(context)
                            .width / 22, height: MediaQuery
                            .sizeOf(context)
                            .height / 22),
                  ],
                ),
              ),
            ],
          ),
        )
    );
  }
}

class CustomTablesRow extends StatefulWidget {
  const CustomTablesRow(
      {super.key, required this.price, required this.orientation, required this.table, required this.onLongPress});
  final double price;
  final Orientation orientation;
  final TblDkTable table;
  final VoidCallback onLongPress;

  @override
  State<CustomTablesRow> createState() => _CustomTablesRowState();
}

class _CustomTablesRowState extends State<CustomTablesRow> {

  @override
  build(context) {
    return SizedBox(
        child: GestureDetector(
          onTap: () {
            GoRouter.of(context).go('/productsPage', extra: widget.table);
          },
          onLongPress: widget.onLongPress,
          child: CustomTable(orientation: widget.orientation,
              globalProvider: Provider.of<GlobalVarsProvider>(context),
              table: widget.table),
        )
    );
  }
}

class SlctCustomTablesRow extends StatefulWidget {
  const SlctCustomTablesRow(
      {super.key, required this.price, required this.orientation, required this.table});
  final double price;
  final Orientation orientation;
  final TblDkTable table;

  @override
  State<SlctCustomTablesRow> createState() => _SlctCustomTablesRowState();
}

class _SlctCustomTablesRowState extends State<SlctCustomTablesRow> {
  bool selected = false;

  @override
  build(context) {
    return Stack(
        alignment: Alignment.center,
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                selected = !selected;
                changeTable(selected, widget.table);
              });
            },
            child: CustomTable(orientation: widget.orientation,
                globalProvider: Provider.of<GlobalVarsProvider>(context),
                table: widget.table),
          ),
          Align(
              alignment: Alignment.topLeft,
              child: Checkbox(
                checkColor: Colors.white,
                value: selected,
                shape: const CircleBorder(),
                onChanged: (bool? value) {
                  setState(() {
                    selected = value!;
                    changeTable(selected, widget.table);
                  });
                },
              )
          )
        ]
    );
  }

  void changeTable(bool isSelected, TblDkTable table) {
    if (isSelected == true) {
      globals.selectedTables.add(table);
      globals.slctTblGuids.add(table.TableGuid);
    }
    else {
      globals.selectedTables.remove(table);
      globals.slctTblGuids.remove(table.TableGuid);
    }
    if (isSelected == true && table.TableTypeId == 3) {
      globals.dividableTables.add(table);
    }
    else if (isSelected == false && table.TableTypeId == 3) {
      globals.dividableTables.remove(table);
    }
  }
}

class ReserveTablesRow extends StatefulWidget {
  const ReserveTablesRow(
      {super.key, required this.price, required this.orientation, required this.table});
  final double price;
  final Orientation orientation;
  final TblDkTable table;

  @override
  State<ReserveTablesRow> createState() => _ReserveTablesRowState();
}

class _ReserveTablesRowState extends State<ReserveTablesRow> {
  bool isWholeDay = false;
  int wholeDay = 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        child: GestureDetector(
          onTap: () {
            reserveDialog(context, widget.table);
          },
          child: CustomTable(orientation: widget.orientation,
              globalProvider: Provider.of<GlobalVarsProvider>(context),
              table: widget.table,
              borderColor: Colors.white),
        )
    );
  }

  Future<void> reserveDialog(BuildContext context, TblDkTable table) async {
    DateTimeRange dateRange = DateTimeRange(
      start: DateTime.now(),
      end: DateTime.now(),
    );
    TimeOfDay? startTime = TimeOfDay.now();
    TimeOfDay? endTime = TimeOfDay.now();
    final trs = AppLocalizations.of(context);
    GlobalVarsProvider globalVarsProvider = Provider.of<GlobalVarsProvider>(
        context, listen: false);
    TextEditingController nameCtrl = TextEditingController();
    TextEditingController titleCtrl = TextEditingController();
    TextEditingController countCtrl = TextEditingController();
    TextEditingController descCtrl = TextEditingController();
    return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
            builder: (context, set) {
              return AlertDialog(
                backgroundColor: Theme.of(context).colorScheme.onSecondary,
                scrollable: true,
                content: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(trs.translate('fill_to_reserve_txt') ??
                            "Fill in the fields to reserve: ", style: Theme
                            .of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(fontSize: 17)),
                        Text(trs.translate('event_name_label') ??
                            "Event's name:"),
                        TextField(
                          style: TextStyle(color: Theme.of(context).canvasColor),
                          controller: nameCtrl,
                          decoration: InputDecoration(
                              fillColor: Theme.of(context).cardColor,
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
                          ),
                          keyboardType: TextInputType.name,
                        ),
                        Text(trs.translate('event_title_label') ??
                            "Event's title:"),
                        TextField(
                          style: TextStyle(color: Theme.of(context).canvasColor),
                          controller: titleCtrl,
                          decoration: InputDecoration(
                            fillColor: Theme.of(context).cardColor,
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
                          ),
                          keyboardType: TextInputType.name,
                        ),
                        Text(trs.translate('person_count') ??
                            "Person count:"),
                        TextField(
                          style: TextStyle(color: Theme.of(context).canvasColor),
                          controller: countCtrl,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Theme.of(context).cardColor,
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
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(2),
                          ],
                        ),
                        Text(trs.translate('event_desc') ??
                            "Event's description:"),
                        TextFormField(
                          style: TextStyle(color: Theme.of(context).canvasColor),
                          controller: descCtrl,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Theme.of(context).cardColor,
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
                          keyboardType: TextInputType.text,
                          minLines: 3,
                          maxLines: 10,
                        ),
                        CheckboxListTile(
                          title: Text(
                              trs.translate('whole_day') ?? "Whole day"),
                          value: isWholeDay,
                          onChanged: (value) {
                            set(() {
                              isWholeDay = !isWholeDay;
                            });
                            wholeDay = (value == false) ? 0 : 1;
                          },
                        ),
                        Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                                trs.translate('date_range') ?? "Date range",
                                style: Theme
                                    .of(context)
                                    .textTheme
                                    .bodyMedium)),
                        InkWell(
                          onTap: () async {
                            DateTimeRange? newDateRange = await showDateRangePicker(
                              context: context,
                              initialDateRange: dateRange,
                              firstDate: DateTime(
                                  2023,
                                  1,
                                  1,
                                  0,
                                  0,
                                  0,
                                  0),
                              lastDate: DateTime(
                                  2050,
                                  12,
                                  7,
                                  23,
                                  59,
                                  59,
                                  59),
                            );
                            await showTimePicker(
                                helpText: trs.translate("startTime") ??
                                    "startTime",
                                context: context,
                                initialTime: TimeOfDay
                                    .now()).then((value) {
                              if (value != null) {
                                setState(() {
                                  startTime = value;
                                });
                              }
                            });
                            await showTimePicker(
                                helpText: trs.translate("endTime") ??
                                    "endTime",
                                context: context,
                                initialTime: TimeOfDay
                                    .now()).then((value) {
                              if (value != null) {
                                setState(() {
                                  endTime = value;
                                });
                              }
                            });
                            set(() {
                              dateRange = newDateRange ?? dateRange;
                              if (newDateRange == null) return;
                              set(() => dateRange = newDateRange);
                            });
                          },
                          child: Row(
                              children: [
                                Icon(Icons.date_range, color: Theme.of(context).secondaryHeaderColor,),
                                Column(
                                  children: [
                                    Text("${dateRange.start.day}-${dateRange
                                        .start.month}-${dateRange.start
                                        .year}ý. ${startTime!.format(
                                        context)}", style: Theme
                                        .of(context)
                                        .textTheme
                                        .bodyMedium),
                                    Text("${dateRange.end.day}-${dateRange.end
                                        .month}-${dateRange.end
                                        .year}ý. ${endTime!.format(context)}",
                                        style: Theme
                                            .of(context)
                                            .textTheme
                                            .bodyMedium)
                                  ],
                                ),
                              ]
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    child: Text(
                      trs.translate('back') ?? 'Back',
                        style: Theme
                            .of(context)
                            .textTheme
                            .labelMedium
                    ),
                    onPressed: () {
                      globals.reservable = false;
                      Navigator.pop(context);
                    },
                  ),
                  TextButton(
                      child: Text(
                          trs.translate('ok') ?? 'OK',
                          style: Theme
                              .of(context)
                              .textTheme
                              .labelMedium
                      ),
                      onPressed: () {
                        int personCount = int.tryParse(countCtrl.text) ?? 8;
                        TblDkEvent reserveEvent = TblDkEvent(EventId: 0,
                            EventGuid: const Uuid().v1(),
                            EventTypeId: 2,
                            ResCatId: 0,
                            ColorId: 0,
                            LocId: 0,
                            TableId: table.TableId,
                            TableGroupGuid: table.TableGroupGuid,
                            SaleCardId: 0,
                            RpAccId: 0,
                            CId: globalVarsProvider.getUser?.CId ?? 0,
                            DivId: globalVarsProvider.getUser?.DivId ?? 0,
                            WpId: 0,
                            EmpId: globalVarsProvider.getUser?.EmpId ?? 0,
                            OwnerEventId: 0,
                            EventName: nameCtrl.text,
                            EventDesc: descCtrl.text,
                            EventTitle: titleCtrl.text,
                            EventStartDate: dateRange.start.copyWith(
                                hour: startTime?.hour ?? 0,
                                minute: startTime?.minute ?? 0),
                            EventEndDate: dateRange.end.copyWith(
                                hour: endTime?.hour ?? 0,
                                minute: endTime?.minute ?? 0),
                            WholeDay: wholeDay,
                            NumberOfGuests: personCount,
                            TagsInfo: "",
                            RecurrenceInfo: "",
                            ReminderInfo: "",
                            AddInf1: "",
                            AddInf2: "",
                            AddInf3: "",
                            AddInf4: "",
                            AddInf5: "",
                            AddInf6: "",
                            AddInf7: "",
                            AddInf8: "",
                            AddInf9: "",
                            AddInf10: "",
                            CreatedDate: null,
                            ModifiedDate: null,
                            CreatedUId: 0,
                            ModifiedUId: 0,
                            SyncDateTime: null);
                        context.read<RestoReservationPageCubit>()
                            .addNewReservation(reserveEvent);
                        globals.reservable = false;
                        Navigator.pop(context);
                      }
                  ),
                ],
              );
            }
        );
      },
    );
  }
}
