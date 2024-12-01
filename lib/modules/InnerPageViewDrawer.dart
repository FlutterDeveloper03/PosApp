// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:pos_app/bloc/DbSyncPageCubit.dart';
import 'package:pos_app/provider/GlobalVarsProvider.dart';
import 'package:pos_app/modules/ServerSettingsDrawer.dart';
import 'package:pos_app/modules/SettingsDrawer.dart';
import 'package:pos_app/modules/ProfileDrawer.dart';

class InnerPageViewDrawer extends StatefulWidget {
  final bool visible;
  final bool isHome;
  const InnerPageViewDrawer({super.key, required this.visible, required this.isHome});

  @override
  State<InnerPageViewDrawer> createState() {
    return _InnerPageViewDrawerState();
  }
}

class _InnerPageViewDrawerState extends State<InnerPageViewDrawer> {
  late int myIndex;
  late PageController _controller;
  bool lockIcon=false;
  @override
  void initState() {
    super.initState();
    _controller = PageController(initialPage: 0);
  }
  _onChangePage(int index){
    if(index != 0) setState(() => myIndex = index);
    _controller.animateToPage(index.clamp(0, 2),
        duration: const Duration(milliseconds: 100), curve: Curves.bounceInOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Orientation orientation=MediaQuery.of(context).orientation;
    final providerModel = Provider.of<GlobalVarsProvider>(context, listen: false);
    return Container(
      width: (size.width<800) ? (orientation==Orientation.portrait)?size.width/1.3:size.width/2 : size.width/3,
      clipBehavior: Clip.hardEdge,
      decoration:  const BoxDecoration(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(32),bottomLeft:Radius.circular(32)
        ),
      ),
      child: Drawer(
          child: BlocProvider(create: (context) => DbSyncPageCubit(providerModel)..loadDbSyncPageEvent(),
            child: PageView.builder(
              controller: _controller,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 4,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return SettingsDrawer(
                  synch: () => _onChangePage(1), visible: widget.visible,
                  profile: ()=> _onChangePage(2),
                 goBack: ()=> _onChangePage(3),
                  server: ()=>_onChangePage(4),
                );
                }
                if (myIndex == 2) {
                  return ProfileDrawer(goBack: ()=>_onChangePage(0),);
                }
                if(myIndex==4){
                  return ServerSettingsDrawer(
                    goBack:()=>_onChangePage(0));
                }
                return null;
              },
            ),
          )
      ),
    );
  }
}






class MyInnerDrawer extends StatelessWidget {
  final String name;
  final PageController _controller;

  const MyInnerDrawer(this._controller, this.name, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      ListTile(
        title: Text(name),
        trailing: const Icon(Icons.arrow_back_ios),
        onTap: () => _controller.animateToPage(0,
            duration: const Duration(milliseconds: 500), curve: Curves.linear),
      )
    ]);
  }
}