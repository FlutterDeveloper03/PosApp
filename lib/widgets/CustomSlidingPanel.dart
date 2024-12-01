// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:pos_app/bloc/CartItemsBloc.dart';
import 'package:pos_app/bloc/ImageLoaderBloc.dart';
import 'package:pos_app/helpers/localization.dart';
import 'package:pos_app/models/tbl_dk_cart_item.dart';
import 'package:pos_app/models/tbl_dk_table.dart';
import 'package:pos_app/models/tbl_mg_mat_attributes.dart';
import 'package:pos_app/provider/GlobalVarsProvider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class CustomSlidingPanel extends StatefulWidget {
  final double headerHeight;
  final TblDkTable table;

  const CustomSlidingPanel({
    super.key,
    required this.headerHeight,
    required this.table,
  });

  @override
  State<CustomSlidingPanel> createState() => _CustomSlidingPanelState();
}

class _CustomSlidingPanelState extends State<CustomSlidingPanel> {
  PanelController panelController = PanelController();
  bool isOpened = false;
  double sumFich = 0;
  double sumCart = 0;
  List<int> selectedLines = [];
  String txt = '';
  String speCode = "";
  String securityCode = "";
  String groupCode = "";
  String invDesc = "";
  DateTime date = DateTime.now();
  TimeOfDay? crtTime = TimeOfDay.now();
  String formattedDate = "";
  String serviceName = "Stolda";
  String firstNumber = "65102030";

  showTextFieldDialog(BuildContext context, Function func, AppLocalizations trs,
      String defaultText, bool isPassword) {
    showDialog(
      context: context,
      builder: (context1) {
        TextEditingController textController = TextEditingController();
        TextEditingController invDescTextController = TextEditingController();
        TextEditingController speCodeTextController = TextEditingController();
        TextEditingController groupCodeTextController = TextEditingController();
        TextEditingController securityCodeTextController = TextEditingController();

        invDescTextController.text = (widget.table.TableDesc.isNotEmpty)
            ? widget.table.TableDesc
            : invDesc;
        // speCodeTextController.text = (widget.table.isNotEmpty) ? widget.table.speCode : speCode;
        // groupCodeTextController.text = (widget.table.groupCode.isNotEmpty) ? widget.table.groupCode : groupCode;
        // securityCodeTextController.text = (widget.table.securityCode.isNotEmpty) ? widget.table.securityCode : securityCode;

        BorderRadius borderRadius = BorderRadius.circular(15);
        textController.text = (isPassword) ? '' : defaultText;
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius,
          ),
          insetPadding: const EdgeInsets.all(20),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onSecondary,
              borderRadius: borderRadius,
            ),
            padding: const EdgeInsets.all(8.0),
            height: (isPassword) ? 115 : 340,
            width: 350,
            child: Column(
              children: [
                (!isPassword)
                    ? Container(
                        margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                        decoration: BoxDecoration(
                          borderRadius: borderRadius,
                          color: Theme.of(context).cardColor,
                        ),
                        child: TextField(
                          style: TextStyle(color: Theme.of(context).canvasColor),
                          autofocus: true,
                          obscureText: false,
                          controller: invDescTextController,
                          decoration: InputDecoration(
                            hintText: trs.translate('invDescription') ??
                                'Invoice description',
                            hintStyle: TextStyle(
                              color: Theme.of(context).canvasColor,
                              fontSize: 16,
                            ),
                            prefixIcon: Icon(Icons.info_outline,
                                color: Theme.of(context).canvasColor),
                            contentPadding: const EdgeInsets.all(8.0),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).primaryColorLight),
                              borderRadius: borderRadius,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).primaryColorLight),
                              borderRadius: borderRadius,
                            ),
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
                (!isPassword)
                    ? Container(
                        margin: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                        decoration: BoxDecoration(
                          borderRadius: borderRadius,
                          color: Theme.of(context).cardColor,
                        ),
                        child: TextField(
                          style: TextStyle(color: Theme.of(context).canvasColor),
                          keyboardType: TextInputType.phone,
                          autofocus: true,
                          obscureText: false,
                          controller: speCodeTextController,
                          decoration: InputDecoration(
                            hintText:
                                trs.translate('invSpeCodeAsPhone1') ?? 'Phone1',
                            hintStyle: TextStyle(
                              color: Theme.of(context).canvasColor,
                              fontSize: 16,
                            ),
                            prefixIcon: Icon(
                              Icons.phone_android_outlined,
                              color: Theme.of(context).canvasColor,
                            ),
                            contentPadding: const EdgeInsets.all(8.0),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).primaryColorLight),
                              borderRadius: borderRadius,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).primaryColorLight),
                              borderRadius: borderRadius,
                            ),
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
                (!isPassword)
                    ? Container(
                        margin: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                        decoration: BoxDecoration(
                          borderRadius: borderRadius,
                          color: Theme.of(context).cardColor,
                        ),
                        child: TextField(
                          style: TextStyle(color: Theme.of(context).canvasColor),
                          autofocus: true,
                          obscureText: false,
                          controller: groupCodeTextController,
                          decoration: InputDecoration(
                            hintText: trs.translate('invGroupCodeAsPhone2') ??
                                'Phone2',
                            hintStyle: TextStyle(
                              color: Theme.of(context).canvasColor,
                              fontSize: 16,
                            ),
                            prefixIcon: Icon(
                              Icons.phone,
                              color: Theme.of(context).canvasColor,
                            ),
                            contentPadding: const EdgeInsets.all(8.0),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).primaryColorLight),
                              borderRadius: borderRadius,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).primaryColorLight),
                              borderRadius: borderRadius,
                            ),
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
                (!isPassword)
                    ? Container(
                        margin: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                        decoration: BoxDecoration(
                          borderRadius: borderRadius,
                          color: Theme.of(context).cardColor,
                        ),
                        child: StatefulBuilder(
                          builder: (context, setState) => Row(
                            children: [
                              Expanded(
                                child: ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  title: Text(trs.translate('orderTypeTable') ??
                                      'Table'),
                                  leading: Radio(
                                    value: trs.translate('orderTypeTable') ??
                                        'Table',
                                    groupValue: securityCodeTextController.text,
                                    onChanged: (String? value) => setState(() =>
                                        securityCodeTextController.text =
                                            (value ?? '')),
                                  ),
                                  onTap: () {
                                    setState(() =>
                                        securityCodeTextController.text =
                                            (trs.translate('orderTypeTable') ??
                                                ''));
                                  },
                                ),
                              ),
                              Expanded(
                                child: ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  title: Text(
                                      trs.translate('orderTypeDelivery') ??
                                          'Delivery'),
                                  leading: Radio(
                                    value: trs.translate('orderTypeDelivery') ??
                                        'Delivery',
                                    groupValue: securityCodeTextController.text,
                                    onChanged: (String? value) => setState(() =>
                                        securityCodeTextController.text =
                                            (value ?? '')),
                                  ),
                                  onTap: () {
                                    setState(() => securityCodeTextController
                                            .text =
                                        (trs.translate('orderTypeDelivery') ??
                                            ''));
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: borderRadius,
                    color: Theme.of(context).cardColor,
                  ),
                  child: TextField(
                    style: TextStyle(color: Theme.of(context).canvasColor),
                    autofocus: true,
                    obscureText: isPassword,
                    controller: textController,
                    onSubmitted: (String text) {
                      func(text);
                      Navigator.pop(context);
                    },
                    decoration: InputDecoration(
                      hintText: (isPassword)
                          ? trs.translate('password')
                          : trs.translate('lineDescription') ??
                              'LineDescription',
                      hintStyle: TextStyle(
                        color: Theme.of(context).canvasColor,
                        fontSize: 16,
                      ),
                      prefixIcon: Icon(
                        (isPassword) ? Icons.password : Icons.info_outline,
                        color: Theme.of(context).canvasColor,
                      ),
                      contentPadding: const EdgeInsets.all(8.0),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Theme.of(context).primaryColorLight),
                        borderRadius: borderRadius,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Theme.of(context).primaryColorLight),
                        borderRadius: borderRadius,
                      ),
                    ),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).cardColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    side: BorderSide(
                      style: BorderStyle.solid,
                      color: Theme.of(context).primaryColorLight,
                    ),
                  ),
                  onPressed: () {
                    try {
                      if (!isPassword) {
                        txt = textController.text;
                        speCode = speCodeTextController.text;
                        groupCode = groupCodeTextController.text;
                        securityCode = securityCodeTextController.text;
                        invDesc = invDescTextController.text;
                        func(
                            invDescTextController.text,
                            speCodeTextController.text,
                            groupCodeTextController.text,
                            securityCodeTextController.text,
                            textController.text);
                      } else {
                        func(textController.text);
                      }
                    } catch (e) {
                      debugPrint("PrintError: $e");
                    }
                    Navigator.pop(context);
                  },
                  child: Text(trs.translate('ok') ?? 'ok'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }


  showAttributesDialog(BuildContext context, TblDkCartItem cartItem, Function func, AppLocalizations trs) {
    showDialog(
      context: context,
      builder: (context1) {
        final attributesTEC = TextEditingController();
        BorderRadius borderRadius = BorderRadius.circular(15);
        List<TblMgMatAttributes> modifiableAttributes = List.from(cartItem.matAttributes);
        String extraAttribs = '';
        if (cartItem.matAttributes.isNotEmpty) {
          for (TblMgMatAttributes attribute in cartItem.matAttributes) {
            extraAttribs = (cartItem.matAttributes.contains(attribute)) ? '' : '${attribute.mat_attribute_name},';
          }
        }
        attributesTEC.text = extraAttribs;
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius,
          ),
          insetPadding: const EdgeInsets.all(20),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onSecondary,
              borderRadius: borderRadius,
            ),
            padding: const EdgeInsets.all(8.0),
            height: MediaQuery.of(context).size.height / 1.3,
            width: MediaQuery.of(context).size.width / 1.2,
            child: Column(
              children: [
                TextField(
                  cursorColor: Theme.of(context).secondaryHeaderColor,
                  decoration: InputDecoration(
                      labelStyle: TextStyle(color: Theme.of(context).secondaryHeaderColor),
                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).secondaryHeaderColor)),
                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).secondaryHeaderColor)),
                      border: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).secondaryHeaderColor)), labelText: trs.translate('attributes') ?? 'Attributes'),
                  controller: attributesTEC,
                ),
                (cartItem.matAttributes.isNotEmpty)
                    ? Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(5),
                    decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(15))),
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        return StatefulBuilder(
                          builder: (context, setState) => CheckboxListTile(
                            title: Text(cartItem.matAttributes[index].mat_attribute_name.toString()),
                            selected: cartItem.matAttributes
                                .any((element) => element.mat_attribute_name == cartItem.matAttributes[index].mat_attribute_name),
                            value: cartItem.matAttributes
                                .any((element) => element.mat_attribute_name == cartItem.matAttributes[index].mat_attribute_name),
                            activeColor: Theme.of(context).colorScheme.primary,
                            checkColor: Theme.of(context).cardColor,
                            onChanged: (value) {
                              if (value ?? false) {
                                cartItem.matAttributes.add(cartItem.matAttributes[index]);
                                setState(
                                      () => {},
                                );
                              } else {
                                cartItem.matAttributes.removeWhere(
                                        (element) => element.mat_attribute_id == cartItem.matAttributes[index].mat_attribute_id);
                                setState(
                                      () => {},
                                );
                              }
                            },
                            secondary: const Icon(Icons.apartment),
                          ),
                        );
                      },
                      itemCount: cartItem.matAttributes.length,
                    ),
                  ),
                )
                    : Expanded(
                    child: Center(
                      child: Text(trs.translate('noAttributes') ?? 'Product doesn\'t have any additional attributes'),
                    )),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).cardColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    side: BorderSide(
                      style: BorderStyle.solid,
                      color: Theme.of(context).primaryColorLight,
                    ),
                  ),
                  onPressed: () {
                    String attrStr = attributesTEC.text;
                    if (modifiableAttributes.isNotEmpty) {
                      modifiableAttributes.removeWhere((element) =>
                      element.mat_attribute_id.isEmpty);
                    }
                    if (attrStr.isNotEmpty) {
                      if (attrStr.endsWith(',')) {
                        attrStr = attrStr.substring(0, attributesTEC.text.length - 1);
                      }
                      modifiableAttributes.add(TblMgMatAttributes(
                          mat_attribute_id: '',
                          mat_attribute_name: attrStr,
                          mat_attribute_desc: attrStr,
                          mat_attribute_type_id: '',
                          material_id_guid: '',
                          material_id: 0,
                          spe_code: '',
                          group_code: '',
                          security_code: '',
                          image_path: '',
                          linked_material_code: ''));
                    }
                    cartItem.matAttributes = modifiableAttributes; // Update the original list
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(25, 10, 25, 10),
                    child: Text(trs.translate('ok') ?? 'OK'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> inputDialog(BuildContext context) async {
    final trs = AppLocalizations.of(context);
    TextEditingController firstNumberController = TextEditingController();
    TextEditingController secondNumberController = TextEditingController();
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          scrollable: true,
          content: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Theme.of(context).colorScheme.secondaryContainer),
                  controller: firstNumberController,
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
                    labelStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Theme.of(context).colorScheme.secondaryContainer),
                    prefixStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Theme.of(context).colorScheme.secondaryContainer),
                    labelText: trs.translate("phone_number") ?? "Phone number",
                    prefixText: '+993 ',
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(6),
                  ],
                ),
                TextField(
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Theme.of(context).colorScheme.secondaryContainer),
                  controller: secondNumberController,
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
                    labelText: trs.translate("phone_number") ?? 'Phone number',
                    prefixText: '+993 ',
                    labelStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Theme.of(context).colorScheme.secondaryContainer),
                    hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Theme.of(context).colorScheme.secondaryContainer),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(6),
                  ],
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                trs.translate('back') ?? 'Back'
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
                child: Text(trs.translate("ok") ?? 'OK'),
                onPressed: () {
                  setState(() {
                    firstNumber = firstNumberController.text;
                  });
                  Navigator.pop(context);
                }),
          ],
        );
      },
    );
  }

  Future<void> serviceDialog(BuildContext context) async {
    final trs = AppLocalizations.of(context);
    return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, set) {
          return AlertDialog(
            alignment: Alignment.center,
            title: Text(trs.translate('service') ?? "Service"),
            backgroundColor: Theme.of(context).dialogBackgroundColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  RadioListTile(
                      value: "Stolda",
                      groupValue: serviceName,
                      title: const Text("Stolda"),
                      activeColor: Theme.of(context).colorScheme.secondary,
                      onChanged: (val) {
                        setState(() {
                          serviceName = val!;
                        });
                        set(() {
                          serviceName = val!;
                        });
                      }),
                  RadioListTile(
                      value: "Dostawka",
                      groupValue: serviceName,
                      title: const Text("Dostawka"),
                      activeColor: Theme.of(context).colorScheme.secondary,
                      onChanged: (val) {
                        setState(() {
                          serviceName = val!;
                        });
                        set(() {
                          serviceName = val!;
                        });
                      }),
                  RadioListTile(
                      value: "Kafeda",
                      groupValue: serviceName,
                      title: const Text("Kafeda"),
                      activeColor: Theme.of(context).colorScheme.secondary,
                      onChanged: (val) {
                        setState(() {
                          serviceName = val!;
                        });
                        set(() {
                          serviceName = val!;
                        });
                      }),
                  RadioListTile(
                      value: "Tiz hyzmat",
                      groupValue: serviceName,
                      title: const Text("Tiz hyzmat"),
                      activeColor: Theme.of(context).colorScheme.secondary,
                      onChanged: (val) {
                        setState(() {
                          serviceName = val!;
                        });
                        set(() {
                          serviceName = val!;
                        });
                      }),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text(
                  trs.translate('back') ?? 'Back'
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              TextButton(
                  child: Text(trs.translate("ok") ?? 'OK'),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
            ],
          );
        });
      },
    );
  }

  Future<bool> askToConfirmDialog(String text) async {
    final trs = AppLocalizations.of(context);
    return (await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.onSecondary,
        content: Text(
          trs.translate(text) ?? text,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        actions: [
          TextButton(
            child: Text(
              trs.translate('no') ?? 'no',
              style: const TextStyle(color: Colors.red),
            ),
            onPressed: () {
              Navigator.pop(context, false);
            },
          ),
          TextButton(
            child: Text(
              trs.translate('yes') ?? 'yes',
              style: TextStyle(color: Theme.of(context).cardColor),
            ),
            onPressed: () {
              Navigator.pop(context, true);
            },
          )
        ],
      ),
    )) ??
        false;
  }

  @override
  void initState() {
    super.initState();
    formattedDate = DateFormat('dd.MM.yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final trs = AppLocalizations.of(context);
    final double width = MediaQuery.of(context).size.width;
    GlobalVarsProvider globalProvider = Provider.of<GlobalVarsProvider>(context);

    // Widget buildFichLines(
    //     List<CustomFichLine> fichLines,
    //     TblMgSalesman salesman,
    //     ) {
    //   if (selectedLines.isEmpty) {
    //     selectedLines = fichLines.map((e) => 0).toList();
    //   }
    //   return SliverToBoxAdapter(
    //     child: Container(
    //       height: fichLines.length * 70,
    //       child: Column(
    //         children: fichLines.map((fichLine) {
    //           int index = fichLines.indexOf(fichLine);
    //           bool selected = selectedLines[index] == 1;
    //           return Container(
    //             height: (fichLine.spe_code1.isNotEmpty) ? 65 : 50,
    //             margin: const EdgeInsets.all(5),
    //             decoration: BoxDecoration(
    //               borderRadius: BorderRadius.circular(15),
    //               color: selected ? Colors.grey[500] : Theme.of(context).primaryColorLight,
    //             ),
    //             child: Column(
    //               children: [
    //                 Row(
    //                   children: [
    //                     Container(
    //                       height: 40,
    //                       width: 40,
    //                       margin: const EdgeInsets.only(left: 5),
    //                       alignment: Alignment.centerLeft,
    //                       decoration: BoxDecoration(
    //                         shape: BoxShape.circle,
    //                         image: fichLine.imagePict.isNotEmpty
    //                             ? DecorationImage(
    //                           image: MemoryImage(fichLine.imagePict),
    //                           fit: BoxFit.cover,
    //                         )
    //                             : const DecorationImage(
    //                           image: AssetImage('assets/images/NoImage.svg'),
    //                           fit: BoxFit.cover,
    //                         ),
    //                       ),
    //                     ),
    //                     Expanded(
    //                       flex: 4,
    //                       child: Padding(
    //                         padding: const EdgeInsets.symmetric(horizontal: 4.0),
    //                         child: Text(
    //                           "",
    //                           style: const TextStyle(color: Colors.white),
    //                         ),
    //                       ),
    //                     ),
    //                     Expanded(
    //                       flex: 2,
    //                       child: Text(
    //                         "",
    //                         style: TextStyle(color: Colors.blue[200]),
    //                       ),
    //                     ),
    //                     const Expanded(
    //                       flex: 1,
    //                       child: Padding(
    //                         padding: EdgeInsets.symmetric(horizontal: 8.0),
    //                         child: Text('x', style: TextStyle(color: Colors.white)),
    //                       ),
    //                     ),
    //                     Expanded(
    //                       flex: 1,
    //                       child: Text(
    //                         "",
    //                         style: TextStyle(color: Colors.green[200]),
    //                       ),
    //                     ),
    //                     const Expanded(
    //                       flex: 1,
    //                       child: Padding(
    //                         padding: EdgeInsets.symmetric(horizontal: 8.0),
    //                         child: Text('=', style: TextStyle(color: Colors.white)),
    //                       ),
    //                     ),
    //                     Expanded(
    //                       flex: 2,
    //                       child: Text(
    //                         "",
    //                         style: TextStyle(color: Colors.red[200]),
    //                       ),
    //                     ),
    //                     IconButton(
    //                       onPressed: () {
    //                         setState(() {
    //                           if (selectedLines[index] == 0) {
    //                             selectedLines[index] = 1;
    //                             rejects.add(fichLine);
    //                           } else {
    //                             selectedLines[index] = 0;
    //                             rejects.removeAt(index);
    //                           }
    //                         });
    //                       },
    //                       icon: Icon(
    //                         selected ? Icons.remove : Icons.delete,
    //                         color: Colors.white,
    //                       ),
    //                     ),
    //                   ],
    //                 ),
    //               ],
    //             ),
    //           );
    //         }).toList(),
    //       ),
    //     ),
    //   );
    // }

    return BlocListener<CartItemBloc, CartItemState>(
      listener: (BuildContext context, CartItemState state) {
        if (state is CartItemCountChanged) {
          globalProvider.setCartItems = state.getCartItems;
        } else if (state is CartItemLoaded) {
          globalProvider.setCartItems = state.getCartItems;
        }
      },
      child: SlidingUpPanel(
        onPanelClosed: () {
          setState(() {
            if (isOpened) isOpened = false;
          });
        },
        onPanelOpened: () {
          setState(() {
            if (!isOpened) isOpened = true;
          });
        },
        controller: panelController,
        borderRadius: BorderRadius.circular(15),
        minHeight: widget.headerHeight,
        maxHeight: 600,
        header: Container(
          height: widget.headerHeight,
          width: width,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                margin: const EdgeInsets.fromLTRB(8.0, 2.0, 2.0, 2.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  shape: BoxShape.circle,
                ),
                child: TextButton(
                  onPressed: () async{
                    bool result = await askToConfirmDialog('confirm_order');
                    if(result==true){

                    }
                  },
                  child: Column(
                    children: [
                      Icon(
                        Icons.restaurant,
                        color: Theme.of(context).primaryColor,
                        size: 25,
                      ),
                      SizedBox(
                        height: 9,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            trs.translate('order') ?? 'Order',
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: 50,
                height: 50,
                margin: const EdgeInsets.fromLTRB(8.0, 2.0, 2.0, 2.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  shape: BoxShape.circle,
                ),
                child: TextButton(
                  onPressed: () {
                    debugPrint("DescButton pressed");
                    showTextFieldDialog(context, (String invDesc, String speCode, String groupCode, String securityCode, String lineDesc) {
                      // BlocProvider.of<MaterialBloc>(context).add(SetDescription(fichLineDesc: lineDesc));
                    }, trs, txt, false);
                  },
                  child: Column(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Theme.of(context).primaryColor,
                        size: 25,
                      ),
                      SizedBox(
                        height: 9,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            trs.translate('description') ?? 'Description',
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: 50,
                height: 50,
                margin: const EdgeInsets.fromLTRB(8.0, 2.0, 2.0, 2.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  shape: BoxShape.circle,
                ),
                child: TextButton(
                  onPressed: () {},
                  child: Column(
                    children: [
                      Icon(
                        Icons.payment,
                        color: Theme.of(context).primaryColor,
                        size: 25,
                      ),
                      SizedBox(
                        height: 9,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            trs.translate('payment') ?? 'Payment',
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: Theme.of(context).cardColor,
                  ),
                  child: Center(
                    child: FittedBox(
                      fit: BoxFit.fitWidth,
                      child: Text(
                        widget.table.TableName,
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Theme.of(context).colorScheme.secondaryContainer),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                height: 50,
                width: 50,
                margin: const EdgeInsets.fromLTRB(2.0, 2.0, 8.0, 2.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: Icon(
                    isOpened ? Icons.arrow_downward : Icons.arrow_upward,
                    color: Theme.of(context).primaryColor,
                  ),
                  onPressed: () async {
                    if (isOpened) {
                      await panelController.animatePanelToPosition(0);
                    } else {
                      await panelController.animatePanelToPosition(1.0);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
        panel: Container(
          height: 600,
          margin: EdgeInsets.only(top: widget.headerHeight),
          child: CustomScrollView(
            slivers: [
              // SliverToBoxAdapter(
              //   child: SizedBox(
              //     height: 50,
              //     child: Padding(
              //       padding: const EdgeInsets.all(8.0),
              //       child: Row(
              //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //         children: [
              //           InkWell(
              //             onTap: (){
              //               inputDialog(context);
              //             },
              //             child: Row(
              //               children: [
              //                 Icon(Icons.phone_outlined,color: Theme.of(context).canvasColor,),
              //                 Text("+993$firstNumber", style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Theme.of(context).colorScheme.secondaryContainer))
              //               ],
              //             ),
              //           ),
              //           InkWell(
              //             onTap: () => serviceDialog(context),
              //             child: Row(
              //               children: [
              //                 Icon(Icons.room_service_outlined,color: Theme.of(context).canvasColor),
              //                 Text(serviceName, style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Theme.of(context).colorScheme.secondaryContainer),)
              //               ],
              //             ),
              //           ),
              //         ],
              //       ),
              //     ),
              //   ),
              // ),
              // SliverToBoxAdapter(
              //   child: SizedBox(
              //     height: 50,
              //     child: Padding(
              //       padding: const EdgeInsets.all(8.0),
              //       child: Row(
              //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //         children: [
              //           InkWell(
              //             onTap: () async{
              //               await showDatePicker(
              //                 context: context,
              //                 initialDate: date,
              //                 firstDate: DateTime(2022),
              //                 lastDate: DateTime(2080),
              //               ).then((selectedDate) {
              //                 if (selectedDate != null) {
              //                   setState(() {
              //                     date = selectedDate;
              //                     formattedDate = DateFormat('dd.MM.yyyy')
              //                         .format(selectedDate);
              //                   });
              //                 }
              //               });
              //             },
              //             child: Row(
              //               children: [
              //                 Icon(Icons.calendar_month_outlined,color: Theme.of(context).canvasColor),
              //                 Text(formattedDate, style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Theme.of(context).colorScheme.secondaryContainer))
              //               ],
              //             ),
              //           ),
              //           InkWell(
              //             onTap: () async{
              //                   await showTimePicker(context: context, initialTime: TimeOfDay.now()).then((value) {
              //                       if (value != null) {
              //                         setState(() {
              //                           crtTime = value;
              //                         });
              //                       }
              //                     });
              //             },
              //             child: Row(
              //               children: [
              //                 Icon(Icons.access_time_outlined,color: Theme.of(context).canvasColor,),
              //                 Text(crtTime!.format(context), style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Theme.of(context).colorScheme.secondaryContainer))
              //               ],
              //             ),
              //           ),
              //           Text("Çek №: 5", style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Theme.of(context).colorScheme.secondaryContainer))
              //         ],
              //       ),
              //     ),
              //   ),
              // ),
              // SliverToBoxAdapter(
              //   child: Divider(color: Theme.of(context).colorScheme.secondaryContainer),
              // ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(trs.translate('orders') ?? 'Orders', style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Theme.of(context).colorScheme.secondaryContainer) ),
                      ),
                      TextButton(
                        onPressed: () {
                          showTextFieldDialog(context, () {}, trs, '', true);
                        },
                        child: Text(trs.translate('delete_selected_orders') ??
                            'Delete selected orders'),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Divider(thickness: 4, color: Theme.of(context).colorScheme.secondaryContainer),
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: globalProvider.getCartItems.where((element) => element.TableId==widget.table.TableId).length * 70 + 50,
                  child: Column(
                    children: globalProvider.getCartItems.where((element) => element.TableId==widget.table.TableId).map((cartItem) {
                      return Container(
                        height: 60,
                        margin: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        child: Row(
                          children: [
                            Container(
                              height: 50,
                              width: 50,
                              margin: const EdgeInsets.only(left: 5),
                              alignment: Alignment.centerLeft,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              child: BlocProvider(
                                create: (context) => ImageLoaderBloc(Provider.of<GlobalVarsProvider>(context, listen: false))..add(LoadImageEvent(cartItem.ResId)),
                                child: BlocBuilder
                                <ImageLoaderBloc, ImageLoaderState>(
                                    builder: (buildContext, state) {
                                      if (state is ImageLoadedState) {
                                        return Image.memory(
                                            state.imageBytes!);
                                      } else if (state is LoadingImageState) {
                                        return const Center(
                                            child: CircularProgressIndicator());
                                      } else if (state is ImageEmptyState ||
                                          state is ImageLoadErrorState) {
                                        return ClipRRect(
                                          child: Image.asset(
                                              'assets/images/noFoodImage.jpg',
                                              fit: BoxFit.cover),
                                        );
                                      } else {
                                        return const SizedBox.shrink();
                                      }
                                    }
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Text(
                                      ((trs.locale.languageCode == 'tk')
                                          ? cartItem.ResNameTm
                                          : (trs.locale.languageCode == 'ru')
                                          ? cartItem.ResNameRu
                                          : cartItem.ResNameEn)
                                          .isNotEmpty
                                          ? (trs.locale.languageCode == 'tk')
                                          ? cartItem.ResNameTm
                                          : (trs.locale.languageCode == 'ru')
                                          ? cartItem.ResNameRu
                                          : cartItem.ResNameEn
                                          : cartItem.ResName,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: const TextStyle(color: Colors.black),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            flex: 2,
                                            child: Text(
                                              cartItem.ResPriceValue.toStringAsFixed(2),
                                              textAlign: TextAlign.right,
                                              style: TextStyle(
                                                  color: Colors.blue[900]),
                                            ),
                                          ),
                                          const Expanded(
                                            flex: 1,
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 8.0),
                                              child: Text('x',
                                                  style: TextStyle(
                                                      color: Colors.black)),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Text(
                                              cartItem.ItemCount.toStringAsFixed(0),
                                              style: TextStyle(
                                                  color: Colors.green[900]),
                                            ),
                                          ),
                                          const Expanded(
                                            flex: 1,
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 8.0),
                                              child: Text(
                                                '=',
                                                style:
                                                TextStyle(color: Colors.black),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Text(
                                              cartItem.ItemPriceTotal.toStringAsFixed(2),
                                              style:
                                              TextStyle(color: Colors.red[900]),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Row(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      BlocProvider.of<CartItemBloc>(context).add(
                                        ChangeCartItemCount(
                                          globalProvider.getResources.firstWhere((element) => element.ResId == cartItem.ResId),
                                          cartItem.ItemCount - 1,
                                          false,
                                          0,
                                          cartItem.matAttributes,
                                          widget.table.TableId
                                        ),
                                      );
                                    },
                                    icon: Icon(Icons.remove, color: Theme.of(context).canvasColor),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      BlocProvider.of<CartItemBloc>(context).add(
                                        ChangeCartItemCount(
                                          globalProvider.getResources.firstWhere((element) => element.ResId == cartItem.ResId),
                                          cartItem.ItemCount + 1,
                                          false,
                                          0,
                                          cartItem.matAttributes,
                                          widget.table.TableId
                                        ),
                                      );
                                    },
                                    icon: Icon(Icons.add, color: Theme.of(context).canvasColor),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: TextButton(
                                style:
                                TextButton.styleFrom(padding: EdgeInsets.zero),
                                onPressed: () async {
                                  showAttributesDialog(context, cartItem, () {}, trs);
                                },
                                child: Icon(
                                  Icons.info_outline,
                                  color: (cartItem.matAttributes.isNotEmpty) ? Colors.amberAccent : Colors.black,
                                  size: 30,
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
