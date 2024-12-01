// ignore_for_file: use_build_context_synchronously, file_names

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:pos_app/bloc/RestoReservationsPageCubit.dart';
import 'package:pos_app/helpers/enums.dart';
import 'package:pos_app/helpers/localization.dart';
import 'package:pos_app/models/tbl_dk_event.dart';
import 'package:pos_app/models/tbl_dk_table.dart';
import 'package:pos_app/provider/GlobalVarsProvider.dart';
class RestoReservationsPage extends StatefulWidget {
  final TblDkTable? table;
  const RestoReservationsPage({super.key, this.table});

  @override
  State<RestoReservationsPage> createState() => _RestoReservationsPageState();
}

class _RestoReservationsPageState extends State<RestoReservationsPage> {

  DateTimeRange dateRange = DateTimeRange(
    start: DateTime.now(),
    end: DateTime.now(),
  );

  @override
  void initState() {
    super.initState();
    context.read<RestoReservationPageCubit>().loadRestoReservationPage();
  }

  @override
  Widget build(BuildContext context) {
    final trs = AppLocalizations.of(context);
    final start = dateRange.start;
    final end = dateRange.end;
    final globalProvider = Provider.of<GlobalVarsProvider>(context);
    return PopScope(
        canPop: false,
        onPopInvoked: (didPop) {
          if(widget.table==null) {
            GoRouter.of(context).go('/restoHome');
          }
          else{
            GoRouter.of(context).go('/productsPage',extra:widget.table);
          }
    },
        child: Scaffold(
      appBar: AppBar(
        title: Text("${trs.translate('reservations')??"Reservations"} (${globalProvider.getReservations.length})",style: Theme.of(context).textTheme.labelSmall!.copyWith(fontSize:20)),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            if(widget.table==null) {
              GoRouter.of(context).go('/restoHome');
            }
            else{
              GoRouter.of(context).go('/productsPage',extra:widget.table);
            }
          },
          icon: Icon(Icons.arrow_back,color:Theme.of(context).iconTheme.color),
          iconSize: 30,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: InkWell(
              onTap: () async{
                await pickDateRange();
              },
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text("${start.day}-${start.month}-${start.year}ý.", style: Theme.of(context).textTheme.labelMedium),
                        Text("${end.day}-${end.month}-${end.year}ý.", style: Theme.of(context).textTheme.labelMedium),
                      ],
                    ),
                  ),
                  Icon(Icons.calendar_month_outlined, color: Theme.of(context).cardColor, size: 30)
                ],
              ),
            ),
          )
        ],
      ),
      body: BlocConsumer<RestoReservationPageCubit,RestoReservationPageState>(
        listener: (context,state){
          if(state is RRPCantConnectToServerState){
            _showDialog(context);
          }
          else if(state is ReservedState){
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: SizedBox(
                    height:MediaQuery.of(context).size.height/5,
                    child: Column(
                      children: [
                        Text(trs.translate("event_name_label")??"Event's name"),
                        Text(state.event.EventName),
                        Text(trs.translate("startTime")??"Event's start time"),
                        Text("${state.event.EventStartDate}"),
                        Text(trs.translate("endTime")??"Event's end time"),
                        Text("${state.event.EventEndDate}"),
                      ],
                    ),
                  ),
                ));
          }
          else if(state is EventModifiedState){
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                      trs.translate('eventModified') ?? 'Event modified!'),
                ));
          }
        },
        builder: (context,state){
          if(state is RestoReservationPageLoadedState){
            return ListView(
              children: [
                SizedBox(
                  height: MediaQuery.sizeOf(context).height/1.15,
                  child: RefreshIndicator(
                    backgroundColor: Theme.of(context).cardColor,
                    onRefresh: ()async{
                      context.read<RestoReservationPageCubit>().loadRestoReservationPage();
                    },
                    child: ListView.builder(
                        itemCount: globalProvider.getReservations.length,
                        itemBuilder: (context,index){
                          return ReservationsListItem(event: globalProvider.getReservations[index]);
                        }),
                  ),
                )
              ],
            );
          }
          else if(state is LoadingRestoReservationPageState){
            return const Center(child: CircularProgressIndicator());
          }
          else if(state is CantReserveState){
            return Center(
              child: Column(
                children: [
                  Text("${trs.translate("error_text") ?? "Error"}: ${state.errorMsg}"),
                  TextButton(
                      onPressed: () => context.read<RestoReservationPageCubit>().loadRestoReservationPage(),
                      child: Text(trs.translate('try_again')??"Try again"))
                ],
              ),
            );
          }
          else if(state is CantModifyEventState){
            return Center(
              child: Column(
                children: [
                  Text("${trs.translate("error_text") ?? "Error"}: ${state.errorMsg}"),
                  TextButton(
                      onPressed: () => context.read<RestoReservationPageCubit>().loadRestoReservationPage(),
                      child: Text(trs.translate('try_again')??"Try again"))
                ],
              ),
            );
          }
          else if(state is PageLoadingFailedState){
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text("${trs.translate("error_text") ?? "Error"}: ${state.errorMsg}",textAlign: TextAlign.center,),
                    TextButton(
                        onPressed: () => context.read<RestoReservationPageCubit>().loadRestoReservationPage(),
                        child: Text(trs.translate('try_again')??"Try again"))
                  ],
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        }

      ),
    ));
  }
  Future<void> _showDialog(BuildContext context) async {
    final trs = AppLocalizations.of(context);
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: SizedBox(
            height:MediaQuery.of(context).size.height/4,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text(trs.translate("no_internet_txt")??"Do you want to be in offline mode or go to server settings?",style:Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize:17)),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            Column(
                children:[
                  TextButton(onPressed: (){
                    context.read<RestoReservationPageCubit>().loadRestoReservationPage(loadMode: DbConnectionMode.offlineMode.value);
                    Navigator.pop(context);
                  }, child: Text(trs.translate("offline_mode")??"Offline mode",style:Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize:17,color: Colors.blue))),

                  TextButton(onPressed: (){
                    GoRouter.of(context).go('/serverSettings');
                  }, child: Text(trs.translate("server_settings")??"Server settings",style:Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize:17,color:Colors.blue))),
                ]
            )
          ],
        );
      },
    );
  }
  Future<void> pickDateRange() async {
    DateTimeRange? newDateRange = await showDateRangePicker(
      context: context,
      initialDateRange: dateRange,
      firstDate: DateTime(2023),
      lastDate: DateTime(2050),
    );
    setState(() {
      dateRange = newDateRange ?? dateRange;
      if (newDateRange == null) return;
    });
    context.read<RestoReservationPageCubit>().loadRestoReservationPage(startDate: dateRange.start,endDate: dateRange.end);
  }
}
class ReservationsListItem extends StatefulWidget {
  final TblDkEvent event;
  const ReservationsListItem({super.key, required this.event});

  @override
  State<ReservationsListItem> createState() => _ReservationsListItemState();
}

class _ReservationsListItemState extends State<ReservationsListItem> {

  @override
  Widget build(BuildContext context) {
    final trs = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
      child: Slidable(
          startActionPane: ActionPane(
            extentRatio: 0.01,
            motion: const DrawerMotion(),
            dismissible: DismissiblePane(
                closeOnCancel: true,
                confirmDismiss: askToConfirmDialog,
                onDismissed: () {
                  context.read<RestoReservationPageCubit>().modifyReservation(widget.event,delete:true);
                }),
            children: const [],
          ),
          endActionPane: ActionPane(
            extentRatio: 0.2,
            motion: const DrawerMotion(),
            children:[
              SlidableAction(
                borderRadius: const BorderRadius.only(topRight: Radius.circular(5),bottomRight: Radius.circular(5)),
                onPressed: (context){
                  modifyReservationDialog(context,widget.event);
                },
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                icon: Icons.edit,
                label: trs.translate('edit')??"Edit",
              ),
            ]
          ),

        key: UniqueKey(),
        child: Container(
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onSecondaryContainer,
              borderRadius: BorderRadius.circular(5),
              boxShadow: [
                BoxShadow(
                    color: Theme.of(context).dividerColor,
                    blurRadius: 2, offset: const Offset(1,1)
                )
              ]
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text('${trs.translate('event_name_label') ?? 'Event\'s name'}:   ',
                      style: const TextStyle(fontSize: 15),
                    ),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(widget.event.EventName,
                        style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text('${trs.translate('event_title_label') ?? 'Event\'s title'}:   ',
                      style: const TextStyle(fontSize: 15),
                    ),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(widget.event.EventTitle,
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text('${trs.translate('event_desc') ?? 'Event\'s description'}:   ',
                      style: const TextStyle(fontSize: 15),
                    ),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(widget.event.EventDesc, maxLines: 3,
                        style: const TextStyle(fontSize: 15),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Row(
                    children: [
                      Icon(Icons.date_range_outlined, size: 20,color: Theme.of(context).secondaryHeaderColor,),
                      Padding(
                        padding: const EdgeInsets.only(left: 5.0),
                        child: Row(
                          children: [
                            Text(DateFormat('dd.MM.yyyy HH:mm').format(widget.event.EventStartDate!)),
                            Text(" - ${DateFormat('dd.MM.yyyy HH:mm').format(widget.event.EventStartDate!)}"),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 7.0),
                  child: Row(
                    children: [
                      Icon(Icons.person_outline_rounded,color: Theme.of(context).secondaryHeaderColor,),
                      Padding(
                        padding: const EdgeInsets.only(left: 5.0),
                        child: Text(widget.event.NumberOfGuests.toString()),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )
      ),
    );
  }

  Future<bool> askToConfirmDialog() async {
    final trs = AppLocalizations.of(context);
    return (await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.onSecondary,
        content: Text(
          trs.translate('remove_event_txt') ?? "Do you really want to delete this event?",
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

  Future<void> modifyReservationDialog(BuildContext context,TblDkEvent event) async {
    DateTimeRange dateRange = DateTimeRange(
      start: event.EventStartDate ?? DateTime.now(),
      end: event.EventEndDate ?? DateTime.now(),
    );
    TimeOfDay? startTime=TimeOfDay.fromDateTime(event.EventStartDate ?? DateTime.now());
    TimeOfDay? endTime=TimeOfDay.fromDateTime(event.EventEndDate ?? DateTime.now());
    final trs = AppLocalizations.of(context);
    TextEditingController nameCtrl = TextEditingController();
    TextEditingController titleCtrl = TextEditingController();
    TextEditingController countCtrl = TextEditingController();
    TextEditingController descCtrl = TextEditingController();
    bool isWholeDay=event.WholeDay==1? true : false;
    int wholeDay=event.WholeDay;
    nameCtrl.text=event.EventName;
    titleCtrl.text=event.EventTitle;
    countCtrl.text=event.NumberOfGuests.toString();
    descCtrl.text=event.EventDesc;
    return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
            builder: (context,set){
              return SingleChildScrollView(
                child: AlertDialog(
                  backgroundColor: Theme.of(context).colorScheme.onSecondary,
                  scrollable: true,
                  content: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Align(
                      alignment:Alignment.centerLeft,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(trs.translate('fill_to_reserve_txt')??"Fill in the fields to reserve: ",style:Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize:17)),
                          Text(trs.translate('event_name_label')??"Event's name:"),
                          TextField(
                            style: TextStyle(color: Theme.of(context).canvasColor),
                            controller: nameCtrl,
                            decoration: InputDecoration(
                                fillColor: Theme.of(context).cardColor,
                                filled: true,
                                labelStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
                                border: const UnderlineInputBorder(
                                  borderSide: BorderSide( width: 2.0),
                                ),
                                enabledBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(width: 2.0),
                                ),
                                focusedBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(width: 2.0),
                                ),
                                labelText: trs.translate('event_name_label')??"Event's name:",
                                hintText: primaryFocus!.hasFocus? "":trs.translate('event_name_label')??"Event's name:"
                            ),
                            keyboardType: TextInputType.name,
                          ),
                          Text(trs.translate('event_title_label')??"Event's title:"),
                          TextField(
                            style: TextStyle(color: Theme.of(context).canvasColor),
                            controller: titleCtrl,
                            decoration: InputDecoration(
                              fillColor: Theme.of(context).cardColor,
                              filled: true,
                              labelStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
                              border: const UnderlineInputBorder(
                                borderSide: BorderSide( width: 2.0),
                              ),
                              enabledBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(width: 2.0),
                              ),
                              focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(width: 2.0),
                              ),
                              labelText: trs.translate('event_title_label')??"Event's title:",
                              hintText: primaryFocus!.hasFocus? "":trs.translate('event_title_label')??"Event's title:",
                            ),
                            keyboardType: TextInputType.name,
                          ),
                          Text(trs.translate('person_count')??"Person count:"),
                          TextField(
                            style: TextStyle(color: Theme.of(context).canvasColor),
                            controller: countCtrl,
                            decoration: InputDecoration(
                              fillColor: Theme.of(context).cardColor,
                              filled: true,
                              border: const UnderlineInputBorder(
                                borderSide: BorderSide( width: 2.0),
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
                          Text(trs.translate('event_desc')??"Event's description:"),
                          TextFormField(
                            style: TextStyle(color: Theme.of(context).canvasColor),
                            controller: descCtrl,
                            decoration: InputDecoration(
                              fillColor: Theme.of(context).cardColor,
                              filled: true,
                              border: const UnderlineInputBorder(
                                borderSide: BorderSide( width: 2.0),
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
                            maxLines :10,
                          ),
                          CheckboxListTile(
                            title: Text(trs.translate('whole_day')??"Whole day"),
                            value: isWholeDay,
                            onChanged: (value){
                              set(() {
                                isWholeDay=!isWholeDay;
                              });
                              wholeDay=(value==false)? 0 : 1;
                            },
                          ),
                          Align(
                              alignment:Alignment.centerLeft,
                              child: Text(trs.translate('date_range')??"Date range",style:Theme.of(context).textTheme.bodyMedium)),
                          InkWell(
                            onTap: ()async{
                              DateTimeRange? newDateRange = await showDateRangePicker(
                                context: context,
                                initialDateRange: dateRange,
                                firstDate: DateTime(2023,1,1,0,0,0,0),
                                lastDate: DateTime(2050,12,7,23,59,59,59),
                              );
                              await showTimePicker(
                                  helpText: trs.translate("startTime")??"startTime",
                                  context: context,
                                  initialTime: TimeOfDay.fromDateTime(event.EventStartDate ?? DateTime.now())).then((value){
                                if (value != null) {
                                  setState(() {
                                    startTime = value;
                                  });
                                }
                              });
                              await showTimePicker(
                                  helpText: trs.translate("endTime")??"endTime",
                                  context: context,
                                  initialTime: TimeOfDay.fromDateTime(event.EventEndDate ?? DateTime.now())).then((value){
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
                                children:[
                                  Icon(Icons.date_range, color: Theme.of(context).secondaryHeaderColor,),
                                  Column(
                                    children: [
                                      Text("${dateRange.start.day}-${dateRange.start.month}-${dateRange.start.year}ý. ${startTime!.format(context)}",style:Theme.of(context).textTheme.bodyMedium),
                                      Text("${dateRange.end.day}-${dateRange.end.month}-${dateRange.end.year}ý. ${endTime!.format(context)}",style:Theme.of(context).textTheme.bodyMedium)
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
                        trs.translate('back')??'Back',
                        style: TextStyle(color: Theme.of(context).secondaryHeaderColor),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    TextButton(
                        child: Text(
                            trs.translate('ok')??'OK',
                            style: TextStyle(color: Theme.of(context).secondaryHeaderColor),
                        ),
                        onPressed:  (){
                          int personCount=int.tryParse(countCtrl.text)??8;
                          TblDkEvent reserveEvent=TblDkEvent(EventId: event.EventId, EventGuid: event.EventGuid, EventTypeId: event.EventTypeId,
                              ResCatId: event.ResCatId, ColorId: event.ColorId, LocId: event.LocId, TableId: event.TableId, TableGroupGuid: event.TableGroupGuid,
                              SaleCardId: event.SaleCardId, RpAccId: event.RpAccId, CId: event.CId,
                              DivId: event.DivId, WpId: event.WpId,
                              EmpId: event.EmpId, OwnerEventId: event.OwnerEventId,
                              EventName: nameCtrl.text, EventDesc: descCtrl.text, EventTitle: titleCtrl.text,
                              EventStartDate: dateRange.start.copyWith(hour: startTime?.hour ?? 0,minute:startTime?.minute ?? 0),
                              EventEndDate: dateRange.end.copyWith(hour: endTime?.hour ?? 0, minute: endTime?.minute ?? 0),
                              WholeDay: wholeDay, NumberOfGuests: personCount, TagsInfo: event.TagsInfo,
                              RecurrenceInfo: event.RecurrenceInfo, ReminderInfo: event.ReminderInfo, AddInf1: event.AddInf1, AddInf2: event.AddInf2, AddInf3: event.AddInf3,
                              AddInf4: event.AddInf4, AddInf5: event.AddInf5, AddInf6: event.AddInf6, AddInf7: event.AddInf7, AddInf8: event.AddInf8, AddInf9: event.AddInf9, AddInf10: event.AddInf10,
                              CreatedDate: event.CreatedDate, ModifiedDate: event.ModifiedDate, CreatedUId: event.CreatedUId, ModifiedUId: event.ModifiedUId,
                              SyncDateTime: event.SyncDateTime);
                          context.read<RestoReservationPageCubit>().modifyReservation(reserveEvent);
                          Navigator.pop(context);
                        }
                    ),
                  ],
                ),
              );
            }
        );
      },
    );
  }
}

