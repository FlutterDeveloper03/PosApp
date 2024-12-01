// ignore_for_file: file_names

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:pos_app/bloc/CartItemsBloc.dart';
import 'package:pos_app/bloc/ImageLoaderBloc.dart';
import 'package:pos_app/bloc/RestoProductsPageCubit.dart';
import 'package:pos_app/bloc/RestoReservationsPageCubit.dart';
import 'package:pos_app/helpers/enums.dart';
import 'package:pos_app/helpers/localization.dart';
import 'package:go_router/go_router.dart';
import 'package:pos_app/models/tbl_dk_cart_item.dart';
import 'package:pos_app/models/tbl_dk_res_category.dart';
import 'package:pos_app/models/tbl_dk_table.dart';
import 'package:pos_app/models/v_dk_resource.dart';
import 'package:pos_app/provider/GlobalVarsProvider.dart';
import 'package:pos_app/widgets/ChangeThemeButtonWidget.dart';
import 'package:pos_app/widgets/CustomSlidingPanel.dart';

class RestoProductsPage extends StatefulWidget {
  final TblDkTable table;

  const RestoProductsPage({super.key, required this.table});

  @override
  State<RestoProductsPage> createState() => _RestoProductsPageState();
}

class _RestoProductsPageState extends State<RestoProductsPage> with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  Device _deviceType = Device.mobile;
  bool showDesc = false;
  late TabController _controller;
  DateTime date = DateTime.now();
  TimeOfDay? crtTime = TimeOfDay.now();
  late String formattedDate;
  late String serviceName;
  late String firstNumber;

  @override
  void initState() {
    super.initState();
    _controller = TabController(initialIndex: 0, length: context.read<GlobalVarsProvider>().getResCategories.length, vsync: this);
    formattedDate = DateFormat('dd.MM.yyyy').format(date);
    serviceName = "Stolda";
    firstNumber = "65102030";
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final trs = AppLocalizations.of(context);
    GlobalVarsProvider globalVarsProvider = Provider.of<GlobalVarsProvider>(context);
    Size screenSize = MediaQuery.of(context).size;
    _deviceType = (screenSize.width < 800) ? Device.mobile : Device.tablet;
    Orientation orientation = MediaQuery.of(context).orientation;
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        GoRouter.of(context).go('/restoHome');
      },
      child: DefaultTabController(
        length: globalVarsProvider.getResCategories.length,
        child: SafeArea(
          child: Scaffold(
              key: _key,
              appBar: AppBar(
                backgroundColor: Theme.of(context).primaryColor,
                elevation: 0,
                leading: IconButton(
                  onPressed: () {
                    GoRouter.of(context).go('/restoHome');
                  },
                  icon: Icon(Icons.arrow_back, color: Theme.of(context).iconTheme.color),
                  iconSize: 30,
                ),
                flexibleSpace: Padding(
                  padding: const EdgeInsets.only(left: 30.0),
                  child: SizedBox(
                    height: 90,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TabBar(
                          tabs: globalVarsProvider.getResCategories.map<Tab>((TblDkResCategory category) {
                            return Tab(text: category.ResCatName);
                          }).toList(),
                          controller: _controller,
                          isScrollable: true,
                          tabAlignment: TabAlignment.start,
                          labelPadding: const EdgeInsets.symmetric(horizontal: 20),
                          labelStyle: Theme.of(context).textTheme.labelLarge!.copyWith(fontWeight: FontWeight.bold, color: Theme.of(context).indicatorColor),
                          indicator: UnderlineTabIndicator(
                            borderSide: BorderSide(
                              width: 4.0,
                              color: Theme.of(context).indicatorColor,
                            ),
                            borderRadius: BorderRadius.circular(16),
                            insets: const EdgeInsets.only(top: 50),
                          ),
                          dividerColor: Theme.of(context).cardColor,
                          indicatorSize: TabBarIndicatorSize.label,
                          unselectedLabelStyle: Theme.of(context).textTheme.labelLarge!.copyWith(color: Theme.of(context).cardColor),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              body: BlocConsumer<RestoPosProductsPageCubit, RestoPosProductsPageState>(listener: (context, state) {
                if (state is RPPCCantConnectToServerState) {
                  _showDialog(context);
                }
              }, builder: (context, state) {
                if (state is RestoPosProductsPageLoadErrorState) {
                  return Center(
                    child: Column(
                      children: [
                        Text("${trs.translate("error_text") ?? "Error"}: ${state.errorMsg}"),
                        TextButton(
                            onPressed: () => context.read<RestoPosProductsPageCubit>().reloadData(),
                            child: Text(trs.translate('try_again') ?? "Try again"))
                      ],
                    ),
                  );
                } else if (state is LoadingRestoPosProductsPageState) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is RestoPosProductsPageLoadedState) {
                  return Stack(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TabBarView(
                              controller: _controller,
                              children: globalVarsProvider.getResCategories.map<Widget>((TblDkResCategory category) {
                                return ProductsTabBar(_deviceType, tableId: widget.table.TableId,
                                    resources: globalVarsProvider.getResources.where((element) => element.ResCatId == category.ResCatId).toList());
                              }).toList(),
                            ),
                          ),
                          (_deviceType == Device.tablet)
                              ? Ink(
                                  width: MediaQuery.of(context).size.width / 8,
                                  color: Theme.of(context).primaryColor,
                                  child: ListView(
                                    children: [
                                      Material(
                                        color: Theme.of(context).primaryColor,
                                        child: InkWell(
                                          child: Ink(
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Column(
                                                children: [
                                                  const Padding(
                                                    padding: EdgeInsets.only(top: 8.0),
                                                    child: Icon(
                                                      Icons.add,
                                                      size: 30,
                                                    ),
                                                  ),
                                                  Text("Add", style: Theme.of(context).textTheme.labelSmall)
                                                ],
                                              ),
                                            ),
                                          ),
                                          onTap: () {},
                                        ),
                                      ),
                                      Material(
                                        color: Theme.of(context).primaryColor,
                                        child: InkWell(
                                          child: Ink(
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Column(
                                                children: [
                                                  const Padding(
                                                    padding: EdgeInsets.only(top: 8.0),
                                                    child: Icon(
                                                      Icons.delete,
                                                      size: 30,
                                                    ),
                                                  ),
                                                  Text("Delete", style: Theme.of(context).textTheme.labelSmall)
                                                ],
                                              ),
                                            ),
                                          ),
                                          onTap: () {},
                                        ),
                                      ),
                                      Material(
                                        color: Theme.of(context).primaryColor,
                                        child: InkWell(
                                          child: Ink(
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Column(
                                                children: [
                                                  const Padding(
                                                    padding: EdgeInsets.only(top: 8.0),
                                                    child: Icon(
                                                      Icons.person,
                                                      size: 30,
                                                    ),
                                                  ),
                                                  Text("Person", style: Theme.of(context).textTheme.labelSmall)
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
                                  color: Theme.of(context).primaryColor,
                                  width: (orientation == Orientation.portrait)
                                      ? MediaQuery.of(context).size.width / 6
                                      : MediaQuery.of(context).size.width / 8,
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 58.0),
                                    child: ListView(
                                      scrollDirection: Axis.vertical,
                                      children: [
                                        Material(
                                          color: Theme.of(context).primaryColor,
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
                                                        textAlign: TextAlign.center,
                                                        trs.translate('this_table_reservations') ?? "This table's reservations",
                                                        style: Theme.of(context).textTheme.labelSmall),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            onTap: () {
                                              GoRouter.of(context).go('/reservationsPage', extra: widget.table);
                                              context.read<RestoReservationPageCubit>().loadRestoReservationPage(tableId: widget.table.TableId);
                                            },
                                          ),
                                        ),
                                        Divider(
                                          thickness: 2,
                                          color: Theme.of(context).dividerColor
                                        ),
                                        Material(
                                          color: Theme.of(context).primaryColor,
                                          child: InkWell(
                                            child: Ink(
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Column(
                                                  children: [
                                                    const Padding(
                                                      padding: EdgeInsets.only(top: 8.0),
                                                      child: Icon(
                                                        Icons.delete,
                                                        size: 30,
                                                      ),
                                                    ),
                                                    Text("Delete", style: Theme.of(context).textTheme.labelSmall)
                                                  ],
                                                ),
                                              ),
                                            ),
                                            onTap: () {},
                                          ),
                                        ),
                                        Divider(
                                          thickness: 2,
                                          color: Theme.of(context).dividerColor
                                        ),
                                        Material(
                                          color: Theme.of(context).primaryColor,
                                          child: InkWell(
                                            child: Ink(
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Column(
                                                  children: [
                                                    const Padding(
                                                      padding: EdgeInsets.only(top: 8.0),
                                                      child: Icon(
                                                        Icons.person,
                                                        size: 30,
                                                      ),
                                                    ),
                                                    Text("Person", style: Theme.of(context).textTheme.labelSmall)
                                                  ],
                                                ),
                                              ),
                                            ),
                                            onTap: () {},
                                          ),
                                        ),
                                        Divider(
                                          thickness: 2,
                                          color: Theme.of(context).dividerColor
                                        ),
                                        const ChangeThemeButtonWidget(),
                                      ],
                                    ),
                                  ),
                                ),
                        ],
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child:  CustomSlidingPanel(headerHeight: screenSize.height / 14, table: widget.table,),
                        // GestureDetector(
                        //   onVerticalDragEnd: (details) {
                        //     if (details.primaryVelocity! < 0) {
                        //       showDesc = true;
                        //       setState(() {});
                        //     }
                        //     if (details.primaryVelocity! > 0) {
                        //       showDesc = false;
                        //       setState(() {});
                        //     }
                        //   },
                        //   child: (MediaQuery.of(context).orientation == Orientation.portrait)
                        //       ? AnimatedContainer(
                        //           duration: const Duration(milliseconds: 350),
                        //           decoration: BoxDecoration(
                        //             color: Theme.of(context).canvasColor,
                        //             borderRadius: BorderRadius.only(topLeft: Radius.circular(4), topRight: Radius.circular(4)),
                        //           ),
                        //           height: (showDesc) ? screenSize.height / 1.4 : screenSize.height / 15,
                        //           child: ListView(
                        //             physics: const NeverScrollableScrollPhysics(),
                        //             children: [
                        //               Row(
                        //                 children: [
                        //                   ElevatedButton(
                        //                       onPressed: () {},
                        //                       style: ElevatedButton.styleFrom(
                        //                           shape: const CircleBorder(),
                        //                           minimumSize: (_deviceType == Device.tablet) ? const Size(100, 100) : const Size(50, 50),
                        //                           backgroundColor: Theme.of(context).dialogBackgroundColor),
                        //                       child: Column(mainAxisSize: MainAxisSize.min, children: [
                        //                         Icon(Icons.restaurant_rounded, size: 20),
                        //                         Text("Sargydy ýaz", style: Theme.of(context).textTheme.labelSmall!.copyWith(fontSize: 5))
                        //                       ])),
                        //                   ElevatedButton(
                        //                       onPressed: () {},
                        //                       style: ElevatedButton.styleFrom(
                        //                           shape: const CircleBorder(),
                        //                           minimumSize: (_deviceType == Device.tablet) ? const Size(100, 100) : const Size(50, 50),
                        //                           backgroundColor: Theme.of(context).dialogBackgroundColor),
                        //                       child: Column(mainAxisSize: MainAxisSize.min, children: [
                        //                         Icon(Icons.info_outline, size: 20),
                        //                         Text("Düşündiriş", style: Theme.of(context).textTheme.labelSmall!.copyWith(fontSize: 5))
                        //                       ])),
                        //                   ElevatedButton(
                        //                       onPressed: () {},
                        //                       style: ElevatedButton.styleFrom(
                        //                           shape: const CircleBorder(),
                        //                           minimumSize: (_deviceType == Device.tablet) ? const Size(100, 100) : const Size(50, 50),
                        //                           backgroundColor: Theme.of(context).dialogBackgroundColor),
                        //                       child: Column(mainAxisSize: MainAxisSize.min, children: [
                        //                         Icon(Icons.payment_outlined, size: 20),
                        //                         Text("Töleg", style: Theme.of(context).textTheme.labelSmall!.copyWith(fontSize: 5))
                        //                       ])),
                        //                   ElevatedButton(
                        //                     onPressed: () {},
                        //                     style: ElevatedButton.styleFrom(
                        //                         shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
                        //                         minimumSize: const Size(30, 20),
                        //                         backgroundColor: Theme.of(context).dialogBackgroundColor),
                        //                     child: Text(widget.table.TableName,
                        //                         style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold)),
                        //                   ),
                        //                 ],
                        //               ),
                        //               SingleChildScrollView(
                        //                 child: Column(children: [
                        //                   Padding(
                        //                     padding: const EdgeInsets.only(top: 10.0, bottom: 5),
                        //                     child: Row(
                        //                       children: [
                        //                         Expanded(
                        //                           child: Row(
                        //                             children: [
                        //                               const Icon(Icons.phone),
                        //                               TextButton(
                        //                                 onPressed: () {
                        //                                   inputDialog(context);
                        //                                 },
                        //                                 child: Text("+993$firstNumber",
                        //                                     style: Theme.of(context).textTheme.labelMedium!.copyWith(fontWeight: FontWeight.bold)),
                        //                               ),
                        //                             ],
                        //                           ),
                        //                         ),
                        //                         Row(
                        //                           children: [
                        //                             const Icon(Icons.home_repair_service),
                        //                             Padding(
                        //                               padding: const EdgeInsets.only(left: 5.0),
                        //                               child: TextButton(
                        //                                 onPressed: () {
                        //                                   serviceDialog(context);
                        //                                 },
                        //                                 child: Text(serviceName,
                        //                                     style: Theme.of(context).textTheme.labelMedium!.copyWith(fontWeight: FontWeight.bold)),
                        //                               ),
                        //                             ),
                        //                           ],
                        //                         ),
                        //                         const SizedBox(width: 20),
                        //                       ],
                        //                     ),
                        //                   ),
                        //                   Row(
                        //                     children: [
                        //                       Row(
                        //                         children: [
                        //                           const Icon(Icons.calendar_month),
                        //                           TextButton(
                        //                             onPressed: () async {
                        //                               await showDatePicker(
                        //                                 context: context,
                        //                                 initialDate: date,
                        //                                 firstDate: DateTime(2022),
                        //                                 lastDate: DateTime(2080),
                        //                               ).then((selectedDate) {
                        //                                 if (selectedDate != null) {
                        //                                   setState(() {
                        //                                     date = selectedDate;
                        //                                     formattedDate = DateFormat('dd.MM.yyyy').format(selectedDate);
                        //                                   });
                        //                                 }
                        //                               });
                        //                             },
                        //                             child: Text(
                        //                               formattedDate,
                        //                               style: Theme.of(context).textTheme.labelMedium!.copyWith(fontWeight: FontWeight.bold),
                        //                             ),
                        //                           ),
                        //                         ],
                        //                       ),
                        //                       Row(
                        //                         children: [
                        //                           const Icon(Icons.history_outlined),
                        //                           TextButton(
                        //                             onPressed: () async {
                        //                               await showTimePicker(context: context, initialTime: TimeOfDay.now()).then((value) {
                        //                                 if (value != null) {
                        //                                   setState(() {
                        //                                     crtTime = value;
                        //                                   });
                        //                                 }
                        //                               });
                        //                             },
                        //                             child: Text(
                        //                               crtTime!.format(context),
                        //                               style: Theme.of(context).textTheme.labelMedium!.copyWith(fontWeight: FontWeight.bold),
                        //                             ),
                        //                           )
                        //                         ],
                        //                       ),
                        //                       Padding(
                        //                         padding: const EdgeInsets.only(left: 12.0),
                        //                         child: Text("Çek No: 5",
                        //                             style: Theme.of(context).textTheme.labelMedium!.copyWith(fontWeight: FontWeight.bold)),
                        //                       ),
                        //                       const Spacer(),
                        //                     ],
                        //                   ),
                        //                   (showDesc)
                        //                       ? globalVarsProvider.getCartItems.isNotEmpty
                        //                           ? Container(
                        //                               color: Theme.of(context).cardColor,
                        //                               height: MediaQuery.of(context).size.height / 2.05,
                        //                               child: const CustomCart())
                        //                           : Padding(
                        //                               padding: const EdgeInsets.only(left: 5.0, top: 25),
                        //                               child: Center(
                        //                                 child: Column(
                        //                                   children: [
                        //                                     SvgPicture.asset(
                        //                                       "assets/images/Vectorcart.svg",
                        //                                       colorFilter: const ColorFilter.mode(Colors.yellow, BlendMode.srcIn),
                        //                                       fit: BoxFit.cover,
                        //                                       width: MediaQuery.of(context).size.width / 20,
                        //                                       height: MediaQuery.of(context).size.height / 20,
                        //                                     ),
                        //                                     Padding(
                        //                                       padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
                        //                                       child: Text(trs.translate('no_cart_item_text') ?? "Your cart is empty",
                        //                                           style: Theme.of(context).textTheme.labelLarge),
                        //                                     ),
                        //                                     Text(trs.translate('go_menu_text') ?? "Go through the menu and choose the dish you want",
                        //                                         style: Theme.of(context).textTheme.labelLarge!.copyWith(color: Colors.yellow)),
                        //                                   ],
                        //                                 ),
                        //                               ),
                        //                             )
                        //                       : const SizedBox.shrink(),
                        //                 ]),
                        //               ),
                        //             ],
                        //           ),
                        //         )
                        //       : AnimatedContainer(
                        //           duration: const Duration(milliseconds: 350),
                        //           decoration: BoxDecoration(color: Theme.of(context).canvasColor, boxShadow: [
                        //             BoxShadow(color: Theme.of(context).colorScheme.secondaryContainer, blurRadius: 20, offset: const Offset(0, 10))
                        //           ]),
                        //           height: (showDesc) ? screenSize.height / 1.6 : screenSize.height / 11,
                        //           child: Padding(
                        //               padding: const EdgeInsets.only(left: 8),
                        //               child: Column(
                        //                 children: [
                        //                   SizedBox(
                        //                     height: MediaQuery.of(context).size.height / 12,
                        //                     child: Row(
                        //                       children: [
                        //                         Expanded(
                        //                           child: Row(
                        //                             children: [
                        //                               const Icon(Icons.functions),
                        //                               Text("60.00 TMT",
                        //                                   style: Theme.of(context)
                        //                                       .textTheme
                        //                                       .bodyLarge!
                        //                                       .copyWith(fontWeight: FontWeight.bold, fontSize: 18)),
                        //                             ],
                        //                           ),
                        //                         ),
                        //                         const Expanded(child: SizedBox.shrink()),
                        //                         Text(widget.table.TableName,
                        //                             style:
                        //                                 Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold, fontSize: 18)),
                        //                         const SizedBox(width: 20),
                        //                       ],
                        //                     ),
                        //                   ),
                        //                   Expanded(
                        //                     child: SingleChildScrollView(
                        //                       child: Column(mainAxisSize: MainAxisSize.min, children: [
                        //                         Padding(
                        //                           padding: const EdgeInsets.only(top: 10.0),
                        //                           child: Row(
                        //                             children: [
                        //                               Expanded(
                        //                                 child: Row(
                        //                                   mainAxisSize: MainAxisSize.min,
                        //                                   children: [
                        //                                     const Icon(Icons.phone),
                        //                                     TextButton(
                        //                                       onPressed: () {
                        //                                         inputDialog(context);
                        //                                       },
                        //                                       child: Text("+993$firstNumber",
                        //                                           style: Theme.of(context)
                        //                                               .textTheme
                        //                                               .labelMedium!
                        //                                               .copyWith(fontWeight: FontWeight.bold, fontSize: 14)),
                        //                                     ),
                        //                                   ],
                        //                                 ),
                        //                               ),
                        //                               Row(
                        //                                 children: [
                        //                                   const Icon(Icons.home_repair_service),
                        //                                   TextButton(
                        //                                     onPressed: () {
                        //                                       serviceDialog(context);
                        //                                     },
                        //                                     child: Text(serviceName,
                        //                                         style: Theme.of(context)
                        //                                             .textTheme
                        //                                             .labelMedium!
                        //                                             .copyWith(fontWeight: FontWeight.bold, fontSize: 14)),
                        //                                   ),
                        //                                 ],
                        //                               ),
                        //                               Expanded(
                        //                                 child: Row(
                        //                                   children: [
                        //                                     const Icon(Icons.calendar_month),
                        //                                     TextButton(
                        //                                       onPressed: () async {
                        //                                         await showDatePicker(
                        //                                           context: context,
                        //                                           initialDate: date,
                        //                                           firstDate: DateTime(2022),
                        //                                           lastDate: DateTime(2080),
                        //                                         ).then((selectedDate) {
                        //                                           if (selectedDate != null) {
                        //                                             setState(() {
                        //                                               date = selectedDate;
                        //                                               formattedDate = DateFormat('dd.MM.yyyy').format(selectedDate);
                        //                                             });
                        //                                           }
                        //                                         });
                        //                                       },
                        //                                       child: Text(
                        //                                         formattedDate,
                        //                                         style: Theme.of(context)
                        //                                             .textTheme
                        //                                             .labelMedium!
                        //                                             .copyWith(fontWeight: FontWeight.bold, fontSize: 14),
                        //                                       ),
                        //                                     ),
                        //                                   ],
                        //                                 ),
                        //                               ),
                        //                               Expanded(
                        //                                 child: Row(
                        //                                   children: [
                        //                                     const Icon(Icons.history_outlined),
                        //                                     TextButton(
                        //                                       onPressed: () async {
                        //                                         await showTimePicker(context: context, initialTime: TimeOfDay.now()).then((value) {
                        //                                           if (value != null) {
                        //                                             setState(() {
                        //                                               crtTime = value;
                        //                                             });
                        //                                           }
                        //                                         });
                        //                                       },
                        //                                       child: Text(
                        //                                         crtTime!.format(context),
                        //                                         style: Theme.of(context)
                        //                                             .textTheme
                        //                                             .labelMedium!
                        //                                             .copyWith(fontWeight: FontWeight.bold, fontSize: 14),
                        //                                       ),
                        //                                     )
                        //                                   ],
                        //                                 ),
                        //                               ),
                        //                               Padding(
                        //                                 padding: const EdgeInsets.only(right: 40.0),
                        //                                 child: Text("Çek No: 5",
                        //                                     style: Theme.of(context)
                        //                                         .textTheme
                        //                                         .labelMedium!
                        //                                         .copyWith(fontWeight: FontWeight.bold, fontSize: 14)),
                        //                               ),
                        //                             ],
                        //                           ),
                        //                         ),
                        //                         (showDesc)
                        //                             ? globalVarsProvider.getCartItems.isNotEmpty
                        //                                 ? Container(
                        //                                     color: Theme.of(context).cardColor,
                        //                                     height: MediaQuery.of(context).size.height / 2.8,
                        //                                     child: const CustomCart())
                        //                                 : Padding(
                        //                                     padding: const EdgeInsets.only(left: 5.0, top: 25),
                        //                                     child: Center(
                        //                                       child: Column(
                        //                                         children: [
                        //                                           SvgPicture.asset(
                        //                                             "assets/images/Vectorcart.svg",
                        //                                             colorFilter: const ColorFilter.mode(Colors.yellow, BlendMode.srcIn),
                        //                                             fit: BoxFit.cover,
                        //                                             width: MediaQuery.of(context).size.width / 15,
                        //                                             height: MediaQuery.of(context).size.height / 15,
                        //                                           ),
                        //                                           Padding(
                        //                                             padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
                        //                                             child: Text(trs.translate('no_cart_item_text') ?? "Your cart is empty",
                        //                                                 style: Theme.of(context).textTheme.labelLarge),
                        //                                           ),
                        //                                           Text(
                        //                                               trs.translate('go_menu_text') ??
                        //                                                   "Go through the menu and choose the dish you want",
                        //                                               style: Theme.of(context).textTheme.labelLarge!.copyWith(color: Colors.yellow)),
                        //                                         ],
                        //                                       ),
                        //                                     ),
                        //                                   )
                        //                             : const SizedBox.shrink(),
                        //                       ]),
                        //                     ),
                        //                   ),
                        //                 ],
                        //               )),
                        //         ),
                        // ),
                      ),
                    ],
                  );
                }
                return const SizedBox.shrink();
              })),
        ),
      ),
    );
  }

  Future<void> _showDialog(BuildContext context) async {
    final trs = AppLocalizations.of(context);
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: SizedBox(
            height: MediaQuery.of(context).size.height / 4,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text(trs.translate("no_internet_txt") ?? "Do you want to be in offline mode or go to server settings?",
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 17)),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            Column(children: [
              TextButton(
                  onPressed: () {
                    context.read<RestoPosProductsPageCubit>().reloadData(loadMode: DbConnectionMode.offlineMode.value);
                    Navigator.pop(context);
                  },
                  child: Text(trs.translate("offline_mode") ?? "Offline mode",
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 17, color: Colors.blue))),
              TextButton(
                  onPressed: () {
                    GoRouter.of(context).go('/serverSettings');
                  },
                  child: Text(trs.translate("server_settings") ?? "Server settings",
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 17, color: Colors.blue))),
            ])
          ],
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
        return SingleChildScrollView(
          child: AlertDialog(
            scrollable: true,
            content: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: firstNumberController,
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
                    controller: secondNumberController,
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
                      labelText: trs.translate("phone_number") ?? 'Phone number',
                      prefixText: '+993 ',
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
                  trs.translate('back') ?? 'Back',
                  style: Theme.of(context).textTheme.labelMedium,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              TextButton(
                  child: Text(trs.translate("ok") ?? 'OK', style: Theme.of(context).textTheme.labelMedium),
                  onPressed: () {
                    setState(() {
                      firstNumber = firstNumberController.text;
                    });
                    Navigator.pop(context);
                  }),
            ],
          ),
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
                  trs.translate('back') ?? 'Back',
                  style: Theme.of(context).textTheme.labelMedium,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              TextButton(
                  child: Text(trs.translate("ok") ?? 'OK', style: Theme.of(context).textTheme.labelMedium),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
            ],
          );
        });
      },
    );
  }
}

class ProductsTabBar extends StatelessWidget {
  final Device deviceType;
  final List<VDkResource> resources;
  final int tableId;
  const ProductsTabBar(this.deviceType, {super.key, required this.resources, required this.tableId});

  @override
  Widget build(BuildContext context) {
    return (deviceType == Device.tablet)
        ? GridView.builder(
            padding: const EdgeInsets.all(23),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: 1.3, mainAxisSpacing: 10, crossAxisCount: (MediaQuery.of(context).orientation == Orientation.portrait) ? 2 : 4),
            itemCount: resources.length,
            itemBuilder: (context, index) {
              return Product(deviceType, resource: resources[index], tableId: tableId);
            },
          )
        : (MediaQuery.of(context).orientation == Orientation.portrait)
            ? Padding(
              padding: const EdgeInsets.only(bottom: 30.0),
              child: GridView.builder(
                  padding: const EdgeInsets.all(23),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(childAspectRatio: 1.4, crossAxisCount: 2),
                  itemCount: resources.length,
                  itemBuilder: (context, index) {
                    return BlocProvider(
                        create: (context) => ImageLoaderBloc(Provider.of<GlobalVarsProvider>(context, listen: false))..add(LoadImageEvent(resources[index].ResId)),
                        child: Product(deviceType, resource: resources[index], tableId: tableId));
                  },
                ),
            )
            : GridView.builder(
                padding: const EdgeInsets.all(23),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(childAspectRatio: 1.4, crossAxisCount: 3),
                itemCount: resources.length,
                itemBuilder: (context, index) {
                  return Product(deviceType, resource: resources[index], tableId: tableId);
                },
              );
  }
}

class Product extends StatefulWidget {
  final Device deviceType;
  final VDkResource resource;
  final int tableId;
  const Product(this.deviceType, {super.key, required this.resource, required this.tableId});

  @override
  State<Product> createState() => _ProductState();
}

class _ProductState extends State<Product> {
  @override
  Widget build(BuildContext context) {
    final trs = AppLocalizations.of(context);
    GlobalVarsProvider globalVarsProvider = Provider.of<GlobalVarsProvider>(context);
    double count = (globalVarsProvider.getCartItems
            .firstWhere(
              (element) => (element.ResId == widget.resource.ResId && element.TableId==widget.tableId),
          orElse: () => TblDkCartItem(
            ResId: 0,
            ItemCount: 0,
            ItemPriceTotal: 0,
            matAttributes: [],
            TableId: widget.tableId, ResName: widget.resource.ResName,
              ResNameTm: widget.resource.ResNameTm, ResNameRu: widget.resource.ResNameRu, ResNameEn: widget.resource.ResNameEn,
              ResPriceGroupId: 0, ResPriceValue: widget.resource.SalePrice,
              SyncDateTime: widget.resource.SyncDateTime, RpAccId: 0, ImageFilePath: widget.resource.ImageFilePath
          ),
        )
            .ItemCount >
            0)
        ? globalVarsProvider.getCartItems.firstWhere((element) => (element.ResId == widget.resource.ResId && element.TableId==widget.tableId)).ItemCount.toDouble()
        : 0;
    String formattedPrice = widget.resource.SalePrice.toStringAsFixed(2);
    return BlocListener<CartItemBloc, CartItemState>(
      listener: (BuildContext context, CartItemState state) {
        if (state is CartItemCountChanged && state.getResource.ResId == widget.resource.ResId) {
          debugPrint("CartItemCountChanged state.");
          globalVarsProvider.setCartItems = state.getCartItems;
          count = state.getItemCount;
        }
      },
      child: Padding(
          padding: const EdgeInsets.only(right: 5, left: 5),
          child: Stack(
            children: [
              Container(
                clipBehavior: Clip.antiAlias,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                ),
                child: Stack(
                  children: [
                    ClipRRect(
                      child: BlocBuilder<ImageLoaderBloc, ImageLoaderState>(builder: (context, state) {
                        if (state is ImageLoadedState) {
                          return Container(
                              decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(16))),
                              child: Image.memory(state.imageBytes!));
                        } else if (state is LoadingImageState) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (state is ImageEmptyState || state is ImageLoadErrorState) {
                          return ClipRRect(
                            child: Container(
                                decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(16))),
                                child: Image.asset('assets/images/noFoodImage.jpg', fit: BoxFit.cover)),
                          );
                        } else {
                          return const SizedBox.shrink();
                        }
                      }),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      child: ClipRRect(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                          child: (widget.deviceType == Device.tablet)
                              ? Container(
                                  width: MediaQuery.of(context).size.width / 3,
                                  height: MediaQuery.of(context).size.height / 17,
                                  clipBehavior: Clip.antiAlias,
                                  decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.1),
                                      borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(16), bottomRight: Radius.circular(16))),
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 2, left: 12),
                                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                      Text("$formattedPrice TMT",
                                          style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold, color: Colors.white)),
                                      FittedBox(
                                        fit: BoxFit.fitWidth,
                                        child: Text(
                                          ((trs.locale.languageCode == 'tk')
                                                      ? widget.resource.ResNameTm
                                                      : (trs.locale.languageCode == 'ru')
                                                          ? widget.resource.ResNameRu
                                                          : widget.resource.ResNameEn)
                                                  .isNotEmpty
                                              ? (trs.locale.languageCode == 'tk')
                                                  ? widget.resource.ResNameTm
                                                  : (trs.locale.languageCode == 'ru')
                                                      ? widget.resource.ResNameRu
                                                      : widget.resource.ResNameEn
                                              : widget.resource.ResName,
                                          style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.white),
                                        ),
                                      ),
                                    ]),
                                  ),
                                )
                              : (MediaQuery.of(context).orientation == Orientation.portrait)
                                  ? Container(
                                      width: MediaQuery.of(context).size.width / 3,
                                      height: MediaQuery.of(context).size.height / 20,
                                      clipBehavior: Clip.antiAlias,
                                      decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(0.1),
                                          borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(16), bottomRight: Radius.circular(16))),
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 2, left: 12),
                                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                          Text("$formattedPrice TMT",
                                              style:
                                                  Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold, color: Colors.white)),
                                          Expanded(
                                            child: Text(
                                              ((trs.locale.languageCode == 'tk')
                                                          ? widget.resource.ResNameTm
                                                          : (trs.locale.languageCode == 'ru')
                                                              ? widget.resource.ResNameRu
                                                              : widget.resource.ResNameEn)
                                                      .isNotEmpty
                                                  ? (trs.locale.languageCode == 'tk')
                                                      ? widget.resource.ResNameTm
                                                      : (trs.locale.languageCode == 'ru')
                                                          ? widget.resource.ResNameRu
                                                          : widget.resource.ResNameEn
                                                  : widget.resource.ResName,
                                              style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.white),
                                            ),
                                          ),
                                        ]),
                                      ),
                                    )
                                  : Container(
                                      width: MediaQuery.of(context).size.width / 3,
                                      height: MediaQuery.of(context).size.height / 8,
                                      clipBehavior: Clip.antiAlias,
                                      decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(0.1),
                                          borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(16), bottomRight: Radius.circular(16))),
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 2, left: 12),
                                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                          Text("$formattedPrice TMT",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge!
                                                  .copyWith(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 17)),
                                          Expanded(
                                            child: Text(
                                              ((trs.locale.languageCode == 'tk')
                                                          ? widget.resource.ResNameTm
                                                          : (trs.locale.languageCode == 'ru')
                                                              ? widget.resource.ResNameRu
                                                              : widget.resource.ResNameEn)
                                                      .isNotEmpty
                                                  ? (trs.locale.languageCode == 'tk')
                                                      ? widget.resource.ResNameTm
                                                      : (trs.locale.languageCode == 'ru')
                                                          ? widget.resource.ResNameRu
                                                          : widget.resource.ResNameEn
                                                  : widget.resource.ResName,
                                              style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.white),
                                            ),
                                          ),
                                        ]),
                                      ),
                                    ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Material(
                color: Theme.of(context).shadowColor,
                clipBehavior: Clip.hardEdge,
                borderRadius: const BorderRadius.all(Radius.circular(16)),
                child: Stack(
                  children: [
                    InkWell(
                      splashColor: Theme.of(context).splashColor.withOpacity(0.2),
                      onTap: () {
                        BlocProvider.of<CartItemBloc>(context).add(
                          ChangeCartItemCount(
                            globalVarsProvider.getResources.firstWhere((element) => element.ResId == widget.resource.ResId),
                            count + 1,
                            false,
                            0,
                            const [],
                            widget.tableId
                          ),
                        );
                        setState(() {});
                      },
                      child: Container(
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(Radius.circular(16)),
                          color: Theme.of(context).shadowColor,
                        ),
                      ),
                    ),
                    Visibility(
                      visible: count>0,
                      child: Align(
                        alignment: Alignment.topRight,
                        child: (widget.deviceType == Device.tablet)
                            ? InkWell(
                                onTap: () {
                                  removeDialog(
                                      context, globalVarsProvider.getCartItems.firstWhere((element) => element.ResId == widget.resource.ResId));
                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width / 9,
                                  height: MediaQuery.of(context).size.height / 18,
                                  decoration: BoxDecoration(
                                      color: Theme.of(context).indicatorColor,
                                      borderRadius: const BorderRadius.only(topRight: Radius.circular(16), bottomLeft: Radius.circular(16))),
                                  child: Center(child: Text(count.toStringAsFixed(0), style: Theme.of(context).textTheme.labelMedium!.copyWith(color: Colors.red))),
                                ),
                              )
                            : (MediaQuery.of(context).orientation == Orientation.portrait)
                                ? InkWell(
                                    onTap: () {
                                      removeDialog(
                                          context, globalVarsProvider.getCartItems.firstWhere((element) => element.ResId == widget.resource.ResId && element.TableId==widget.tableId));
                                    },
                                    child: Container(
                                      width: MediaQuery.of(context).size.width / 15,
                                      height: MediaQuery.of(context).size.height / 27,
                                      decoration: BoxDecoration(
                                          color: Theme.of(context).indicatorColor,
                                          borderRadius: const BorderRadius.only(topRight: Radius.circular(16), bottomLeft: Radius.circular(16))),
                                      child: Center(child: Text(count.toStringAsFixed(0), style: Theme.of(context).textTheme.labelMedium!.copyWith(color: Colors.red))),
                                    ),
                                  )
                                : InkWell(
                                    onTap: () {
                                      removeDialog(
                                          context, globalVarsProvider.getCartItems.firstWhere((element) => element.ResId == widget.resource.ResId && element.TableId==widget.tableId));
                                    },
                                    child: Container(
                                      width: MediaQuery.of(context).size.width / 18,
                                      height: MediaQuery.of(context).size.height / 13,
                                      decoration: BoxDecoration(
                                          color: Theme.of(context).indicatorColor,
                                          borderRadius: const BorderRadius.only(topRight: Radius.circular(16), bottomLeft: Radius.circular(16))),
                                      child: Center(
                                          child:
                                              Text("$count", style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.red, fontSize: 17))),
                                    ),
                                  ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  }

  Future<void> removeDialog(BuildContext context, TblDkCartItem cartItem) async {
    final trs = AppLocalizations.of(context);
    GlobalVarsProvider globalVarsProvider = Provider.of<GlobalVarsProvider>(context, listen: false);
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text(trs.translate('remove_cart_item') ?? "Do you really want to remove this product from cart?",
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 17)),
          actions: <Widget>[
            TextButton(
              child: Text(
                trs.translate('back') ?? "Back",
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
                child: Text(trs.translate('ok') ?? "Ok"),
                onPressed: () {
                  BlocProvider.of<CartItemBloc>(context).add(
                    ChangeCartItemCount(
                      globalVarsProvider.getResources.firstWhere((element) => element.ResId == cartItem.ResId),
                      0,
                      false,
                      0,
                      const [],
                      widget.tableId
                    ),
                  );
                  setState(() {});
                  Navigator.pop(context);
                }),
          ],
        );
      },
    );
  }
}

// class CustomCart extends StatefulWidget {
//   const CustomCart({Key? key}) : super(key: key);
//
//   @override
//   State<CustomCart> createState() => _CustomCartState();
// }
//
// class _CustomCartState extends State<CustomCart> {
//   Device _deviceType = Device.mobile;
//
//   @override
//   Widget build(BuildContext context) {
//     final trs = AppLocalizations.of(context);
//     GlobalVarsProvider globalVarsProvider = Provider.of<GlobalVarsProvider>(context);
//     Size screenSize = MediaQuery.of(context).size;
//     _deviceType = (screenSize.width < 800) ? Device.mobile : Device.tablet;
//     return
//       ListView.separated(
//         separatorBuilder: (context, separatorIndex) {
//           return const Divider(
//             color: Colors.grey,
//             thickness: 0.3,
//           );
//         },
//         itemCount: globalVarsProvider.getCartItems.isEmpty ? 0 : globalVarsProvider.getCartItems.length,
//         itemBuilder: (context, index) {
//           if (globalVarsProvider.getCartItems.isNotEmpty) {
//             return (_deviceType == Device.tablet)
//                 ? ListTile(
//                     leading: Container(
//                       height: MediaQuery.of(context).size.height / 2,
//                       width: MediaQuery.of(context).size.width / 8,
//                       decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(4))),
//                       child:
//                       // (globalVarsProvider.getCartItems[index].ImageFilePath.isEmpty)
//                       //     ?
//                       Image.asset(
//                               'assets/images/noFoodImage.jpg',
//                               fit: BoxFit.cover,
//                             )
//                           // : Image.file(
//                           //     File(globalVarsProvider.getCartItems[index].ImageFilePath),
//                           //     fit: BoxFit.cover,
//                           //   ),
//                     ),
//                     title: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           ((trs.locale.languageCode == 'tk')
//                                       ? globalVarsProvider.getCartItems[index].resource!.ResNameTm
//                                       : (trs.locale.languageCode == 'ru')
//                                           ? globalVarsProvider.getCartItems[index].resource!.ResNameRu
//                                           : globalVarsProvider.getCartItems[index].resource!.ResNameEn)
//                                   .isNotEmpty
//                               ? (trs.locale.languageCode == 'tk')
//                                   ? globalVarsProvider.getCartItems[index].resource!.ResNameTm
//                                   : (trs.locale.languageCode == 'ru')
//                                       ? globalVarsProvider.getCartItems[index].resource!.ResNameRu
//                                       : globalVarsProvider.getCartItems[index].resource!.ResNameEn
//                               : globalVarsProvider.getCartItems[index].resource!.ResName,
//                           style: Theme.of(context).textTheme.labelMedium,
//                         ),
//                         Row(
//                           children: [
//                             Expanded(
//                               child: Row(
//                                 children: [
//                                   const Icon(Icons.list_alt),
//                                   Text(
//                                     globalVarsProvider.getCartItems[index].ItemCount.toStringAsFixed(2),
//                                     style: Theme.of(context).textTheme.labelMedium,
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             Expanded(
//                               child: Row(
//                                 children: [
//                                   const Icon(Icons.functions),
//                                   Text(
//                                     globalVarsProvider.getCartItems[index].ItemPriceTotal.toStringAsFixed(2),
//                                     style: Theme.of(context).textTheme.labelMedium,
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                     trailing: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceAround,
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             IconButton(
//                                 onPressed: () {
//                                   CartItem cartItem = globalVarsProvider.getCartItems
//                                       .where((element) => element.ResId == globalVarsProvider.getCartItems[index].ResId)
//                                       .first;
//                                   globalVarsProvider.updateCartItems(
//                                       globalVarsProvider.getCartItems
//                                           .indexWhere((element) => element.ResId == globalVarsProvider.getCartItems[index].ResId),
//                                       globalVarsProvider.getCartItems
//                                           .where((element) => element.ResId == globalVarsProvider.getCartItems[index].ResId)
//                                           .first
//                                           .copyWith(
//                                               ItemCount: cartItem.ItemCount + 1, ItemPriceTotal: (cartItem.ItemCount + 1) * cartItem.ResPriceValue));
//                                 },
//                                 padding: const EdgeInsets.fromLTRB(0, 3, 15, 2),
//                                 constraints: const BoxConstraints(),
//                                 icon: const Icon(Icons.add)),
//                             IconButton(
//                                 onPressed: () {
//                                   CartItem cartItem = globalVarsProvider.getCartItems
//                                       .where((element) => element.ResId == globalVarsProvider.getCartItems[index].ResId)
//                                       .first;
//                                   globalVarsProvider.updateCartItems(
//                                       globalVarsProvider.getCartItems
//                                           .indexWhere((element) => element.ResId == globalVarsProvider.getCartItems[index].ResId),
//                                       cartItem.ItemCount > 1
//                                           ? globalVarsProvider.getCartItems
//                                               .where((element) => element.ResId == globalVarsProvider.getCartItems[index].ResId)
//                                               .first
//                                               .copyWith(
//                                                   ItemCount: cartItem.ItemCount - 1,
//                                                   ItemPriceTotal: (cartItem.ItemCount - 1) * cartItem.resource!.SalePrice)
//                                           : globalVarsProvider.getCartItems
//                                               .where((element) => element.ResId == globalVarsProvider.getCartItems[index].ResId)
//                                               .first
//                                               .copyWith(ItemCount: 1));
//                                 },
//                                 padding: const EdgeInsets.fromLTRB(0, 3, 15, 0),
//                                 constraints: const BoxConstraints(),
//                                 icon: const Icon(Icons.remove)),
//                           ],
//                         ),
//                         IconButton(
//                           constraints: const BoxConstraints(),
//                           icon: const Icon(Icons.delete_outline, color: Colors.red, size: 27),
//                           onPressed: () {
//                             setState(() {
//                               globalVarsProvider.getCartItems.removeAt(index);
//                             });
//                           },
//                         ),
//                       ],
//                     ),
//                     selected: true,
//                     onTap: () {
//                       setState(() {
//                         globalVarsProvider.getCartItems.removeAt(index);
//                       });
//                     },
//                   )
//                 : (MediaQuery.of(context).orientation == Orientation.portrait)
//                     ? InkWell(
//                         onTap: () {
//                           setState(() {
//                             globalVarsProvider.getCartItems.removeAt(index);
//                           });
//                         },
//                         child: SizedBox(
//                           height: MediaQuery.of(context).size.height / 12,
//                           child: Row(
//                             children: [
//                               Padding(
//                                 padding: const EdgeInsets.only(right: 8.0),
//                                 child: Container(
//                                   height: MediaQuery.of(context).size.height / 14,
//                                   width: MediaQuery.of(context).size.width / 8,
//                                   decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(4))),
//                                   child: (globalVarsProvider.getCartItems[index].ImageFilePath.isEmpty)
//                                       ? Image.asset(
//                                           'assets/images/noFoodImage.jpg',
//                                           fit: BoxFit.cover,
//                                         )
//                                       : Image.file(
//                                           File(globalVarsProvider.getCartItems[index].ImageFilePath),
//                                           fit: BoxFit.cover,
//                                         ),
//                                 ),
//                               ),
//                               Expanded(
//                                 child: SizedBox(
//                                   height: MediaQuery.of(context).size.height / 10,
//                                   width: MediaQuery.of(context).size.width / 5,
//                                   child: Column(
//                                     crossAxisAlignment: CrossAxisAlignment.start,
//                                     children: [
//                                       Text(
//                                           ((trs.locale.languageCode == 'tk')
//                                                       ? globalVarsProvider.getCartItems[index].ResNameTm
//                                                       : (trs.locale.languageCode == 'ru')
//                                                           ? globalVarsProvider.getCartItems[index].ResNameRu
//                                                           : globalVarsProvider.getCartItems[index].ResNameEn)
//                                                   .isNotEmpty
//                                               ? (trs.locale.languageCode == 'tk')
//                                                   ? globalVarsProvider.getCartItems[index].ResNameTm
//                                                   : (trs.locale.languageCode == 'ru')
//                                                       ? globalVarsProvider.getCartItems[index].ResNameRu
//                                                       : globalVarsProvider.getCartItems[index].ResNameEn
//                                               : globalVarsProvider.getCartItems[index].ResName,
//                                           style: Theme.of(context).textTheme.labelSmall!.copyWith(fontSize: 15)),
//                                       Expanded(
//                                         child: Padding(
//                                           padding: const EdgeInsets.only(top: 8.0),
//                                           child: Row(
//                                             children: [
//                                               Expanded(
//                                                 child: Row(
//                                                   children: [
//                                                     const Icon(Icons.list_alt),
//                                                     Text(globalVarsProvider.getCartItems[index].ItemCount.toStringAsFixed(2),
//                                                         style: Theme.of(context).textTheme.labelSmall),
//                                                   ],
//                                                 ),
//                                               ),
//                                               Expanded(
//                                                 child: Row(
//                                                   children: [
//                                                     const Icon(
//                                                       Icons.functions,
//                                                     ),
//                                                     Expanded(
//                                                       child: Text(globalVarsProvider.getCartItems[index].ItemPriceTotal.toStringAsFixed(2),
//                                                           style: Theme.of(context).textTheme.labelSmall, overflow: TextOverflow.clip),
//                                                     ),
//                                                   ],
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                               Expanded(
//                                 child: SizedBox(
//                                   height: MediaQuery.of(context).size.height / 10,
//                                   width: MediaQuery.of(context).size.width / 10,
//                                   child: Row(
//                                     mainAxisAlignment: MainAxisAlignment.spaceAround,
//                                     mainAxisSize: MainAxisSize.min,
//                                     children: [
//                                       Column(
//                                         crossAxisAlignment: CrossAxisAlignment.start,
//                                         mainAxisSize: MainAxisSize.min,
//                                         children: [
//                                           Expanded(
//                                             child: IconButton(
//                                                 onPressed: () {
//                                                   TblDkCartItem cartItem = globalVarsProvider.getCartItems
//                                                       .where((element) => element.ResId == globalVarsProvider.getCartItems[index].ResId)
//                                                       .first;
//                                                   globalVarsProvider.updateCartItems(
//                                                       globalVarsProvider.getCartItems
//                                                           .indexWhere((element) => element.ResId == globalVarsProvider.getCartItems[index].ResId),
//                                                       globalVarsProvider.getCartItems
//                                                           .where((element) => element.ResId == globalVarsProvider.getCartItems[index].ResId)
//                                                           .first
//                                                           .copyWith(
//                                                               ItemCount: cartItem.ItemCount + 1,
//                                                               ItemPriceTotal: (cartItem.ItemCount + 1) * cartItem.ResPriceValue));
//                                                 },
//                                                 padding: const EdgeInsets.fromLTRB(0, 3, 15, 2),
//                                                 constraints: const BoxConstraints(),
//                                                 icon: const Icon(Icons.add)),
//                                           ),
//                                           Expanded(
//                                             child: IconButton(
//                                                 onPressed: () {
//                                                   TblDkCartItem cartItem = globalVarsProvider.getCartItems
//                                                       .where((element) => element.ResId == globalVarsProvider.getCartItems[index].ResId)
//                                                       .first;
//                                                   globalVarsProvider.updateCartItems(
//                                                       globalVarsProvider.getCartItems
//                                                           .indexWhere((element) => element.ResId == globalVarsProvider.getCartItems[index].ResId),
//                                                       cartItem.ItemCount > 1
//                                                           ? globalVarsProvider.getCartItems
//                                                               .where((element) => element.ResId == globalVarsProvider.getCartItems[index].ResId)
//                                                               .first
//                                                               .copyWith(
//                                                                   ItemCount: cartItem.ItemCount - 1,
//                                                                   ItemPriceTotal: (cartItem.ItemCount - 1) * cartItem.ResPriceValue)
//                                                           : globalVarsProvider.getCartItems
//                                                               .where((element) => element.ResId == globalVarsProvider.getCartItems[index].ResId)
//                                                               .first
//                                                               .copyWith(ItemCount: 1));
//                                                 },
//                                                 padding: const EdgeInsets.fromLTRB(0, 3, 15, 0),
//                                                 constraints: const BoxConstraints(),
//                                                 icon: const Icon(Icons.remove)),
//                                           ),
//                                         ],
//                                       ),
//                                       IconButton(
//                                         constraints: const BoxConstraints(),
//                                         icon: Icon(
//                                           Icons.delete_outline,
//                                           size: 27,
//                                           color: Theme.of(context).colorScheme.errorContainer,
//                                         ),
//                                         onPressed: () {
//                                           setState(() {
//                                             globalVarsProvider.getCartItems.removeAt(index);
//                                           });
//                                         },
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               )
//                             ],
//                           ),
//                         ),
//                       )
//                     : ListTile(
//                         leading: Container(
//                           height: MediaQuery.of(context).size.height / 2,
//                           width: MediaQuery.of(context).size.width / 8,
//                           decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(4))),
//                           child: (globalVarsProvider.getCartItems[index].ImageFilePath.isEmpty)
//                               ? Image.asset(
//                                   'assets/images/noFoodImage.jpg',
//                                   fit: BoxFit.cover,
//                                 )
//                               : Image.file(
//                                   File(globalVarsProvider.getCartItems[index].ImageFilePath),
//                                   fit: BoxFit.cover,
//                                 ),
//                         ),
//                         title: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                                 ((trs.locale.languageCode == 'tk')
//                                             ? globalVarsProvider.getCartItems[index].ResNameTm
//                                             : (trs.locale.languageCode == 'ru')
//                                                 ? globalVarsProvider.getCartItems[index].ResNameRu
//                                                 : globalVarsProvider.getCartItems[index].ResNameEn)
//                                         .isNotEmpty
//                                     ? (trs.locale.languageCode == 'tk')
//                                         ? globalVarsProvider.getCartItems[index].ResNameTm
//                                         : (trs.locale.languageCode == 'ru')
//                                             ? globalVarsProvider.getCartItems[index].ResNameRu
//                                             : globalVarsProvider.getCartItems[index].ResNameEn
//                                     : globalVarsProvider.getCartItems[index].ResName,
//                                 style: Theme.of(context).textTheme.labelLarge!.copyWith(fontSize: 17)),
//                             Row(
//                               children: [
//                                 Expanded(
//                                   child: Row(
//                                     children: [
//                                       const Icon(Icons.list_alt),
//                                       Text(globalVarsProvider.getCartItems[index].ItemCount.toStringAsFixed(2),
//                                           style: Theme.of(context).textTheme.labelLarge),
//                                     ],
//                                   ),
//                                 ),
//                                 Expanded(
//                                   child: Row(
//                                     children: [
//                                       const Icon(Icons.functions),
//                                       Text(globalVarsProvider.getCartItems[index].ItemPriceTotal.toStringAsFixed(2),
//                                           style: Theme.of(context).textTheme.labelLarge),
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                         trailing: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceAround,
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               mainAxisSize: MainAxisSize.min,
//                               children: [
//                                 Expanded(
//                                   child: IconButton(
//                                       onPressed: () {
//                                         TblDkCartItem cartItem = globalVarsProvider.getCartItems
//                                             .where((element) => element.ResId == globalVarsProvider.getCartItems[index].ResId)
//                                             .first;
//                                         globalVarsProvider.updateCartItems(
//                                             globalVarsProvider.getCartItems
//                                                 .indexWhere((element) => element.ResId == globalVarsProvider.getCartItems[index].ResId),
//                                             globalVarsProvider.getCartItems
//                                                 .where((element) => element.ResId == globalVarsProvider.getCartItems[index].ResId)
//                                                 .first
//                                                 .copyWith(
//                                                     ItemCount: cartItem.ItemCount + 1,
//                                                     ItemPriceTotal: (cartItem.ItemCount + 1) * cartItem.ResPriceValue));
//                                       },
//                                       padding: const EdgeInsets.fromLTRB(0, 3, 15, 2),
//                                       constraints: const BoxConstraints(),
//                                       icon: const Icon(Icons.add)),
//                                 ),
//                                 Expanded(
//                                   child: IconButton(
//                                       onPressed: () {
//                                         TblDkCartItem cartItem = globalVarsProvider.getCartItems
//                                             .where((element) => element.ResId == globalVarsProvider.getCartItems[index].ResId)
//                                             .first;
//                                         globalVarsProvider.updateCartItems(
//                                             globalVarsProvider.getCartItems
//                                                 .indexWhere((element) => element.ResId == globalVarsProvider.getCartItems[index].ResId),
//                                             cartItem.ItemCount > 1
//                                                 ? globalVarsProvider.getCartItems
//                                                     .where((element) => element.ResId == globalVarsProvider.getCartItems[index].ResId)
//                                                     .first
//                                                     .copyWith(
//                                                         ItemCount: cartItem.ItemCount - 1,
//                                                         ItemPriceTotal: (cartItem.ItemCount - 1) * cartItem.ResPriceValue)
//                                                 : globalVarsProvider.getCartItems
//                                                     .where((element) => element.ResId == globalVarsProvider.getCartItems[index].ResId)
//                                                     .first
//                                                     .copyWith(ItemCount: 1));
//                                       },
//                                       padding: const EdgeInsets.fromLTRB(0, 3, 15, 0),
//                                       constraints: const BoxConstraints(),
//                                       icon: const Icon(Icons.remove)),
//                                 ),
//                               ],
//                             ),
//                             IconButton(
//                               constraints: const BoxConstraints(),
//                               icon: Icon(Icons.delete_outline, size: 27, color: Theme.of(context).colorScheme.errorContainer),
//                               onPressed: () {
//                                 setState(() {
//                                   globalVarsProvider.getCartItems.removeAt(index);
//                                 });
//                               },
//                             ),
//                           ],
//                         ),
//                         selected: true,
//                         onTap: () {
//                           setState(() {
//                             globalVarsProvider.getCartItems.removeAt(index);
//                           });
//                         },
//                       );
//           } else {
//             return Center(
//               child: Column(
//                 children: [
//                   SvgPicture.asset(
//                     "assets/images/Vectorcart.svg",
//                     colorFilter: const ColorFilter.mode(Colors.yellow, BlendMode.srcIn),
//                     fit: BoxFit.cover,
//                     width: MediaQuery.of(context).size.width / 20,
//                     height: MediaQuery.of(context).size.height / 20,
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
//                     child: Text(trs.translate('no_cart_item_text') ?? "Your cart is empty", style: Theme.of(context).textTheme.labelLarge),
//                   ),
//                   Text(trs.translate('go_menu_text') ?? "Go through the menu and choose the dish you want",
//                       style: Theme.of(context).textTheme.labelLarge!.copyWith(color: Colors.yellow)),
//                 ],
//               ),
//             );
//           }
//         });
//   }
//
//   Future<void> removeDialog(BuildContext context, TblDkCartItem cartItem) async {
//     final trs = AppLocalizations.of(context);
//     GlobalVarsProvider globalVarsProvider = Provider.of<GlobalVarsProvider>(context, listen: false);
//     return showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           content: Text(trs.translate('remove_cart_item') ?? "Do you really want to remove this product from cart?",
//               style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 17)),
//           actions: <Widget>[
//             TextButton(
//               child: Text(
//                 trs.translate('back') ?? "Back",
//                 style: Theme.of(context).textTheme.labelMedium,
//               ),
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//             ),
//             TextButton(
//                 child: Text(trs.translate('ok') ?? "Ok", style: Theme.of(context).textTheme.labelMedium),
//                 onPressed: () {
//                   setState(() {
//                     globalVarsProvider.getCartItems.removeWhere((element) => element.ResId == cartItem.ResId);
//                   });
//                   Navigator.pop(context);
//                 }),
//           ],
//         );
//       },
//     );
//   }
// }
