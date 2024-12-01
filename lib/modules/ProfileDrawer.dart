// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:pos_app/bloc/UserProfileBloc.dart';
import 'package:pos_app/helpers/SharedPrefKeys.dart';
import 'package:pos_app/helpers/enums.dart';
import 'package:pos_app/helpers/localization.dart';
import 'package:pos_app/provider/GlobalVarsProvider.dart';
import 'package:pos_app/models/tbl_dk_res_price_group.dart';
import 'package:shared_preferences/shared_preferences.dart';
class ProfileDrawer extends StatefulWidget {
  final  VoidCallback? goBack;
  const ProfileDrawer({super.key,  this.goBack});

  @override
  State<ProfileDrawer> createState() => _ProfileDrawerState();
}

class _ProfileDrawerState extends State<ProfileDrawer> {
  TblDkResPriceGroup? tblDkResPriceGroup;
  Device _deviceType=Device.mobile;
  String? dropdownvalue;
  @override
  void initState() {
    super.initState();
    loadData();
  }
  Future loadData() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      dropdownvalue = prefs.getString(SharedPrefKeys.initialPage) ?? "HomePage";
    });

  }
  @override
  Widget build(BuildContext context) {
    var items = [
      "HomePage",
      "ProductsPage",
      "ProductDetailPage"
    ];

    final GlobalVarsProvider providerModel = Provider.of<GlobalVarsProvider>(context);
    _deviceType=(MediaQuery.of(context).size.width<800)?Device.mobile:Device.tablet;
    final trs = AppLocalizations.of(context);
    return BlocConsumer<UserProfileCubit,UserProfileState>(
      listener: (context, state) {
        if (state is UserProfileInitialState || state is UserProfileSavedState){
          context.read<UserProfileCubit>().loadUserProfile();
        }
      },
        builder: (context,state){
          return (state is UserProfileLoadedState) ? Container(
              width: 379,
              height:834,
              clipBehavior: Clip.hardEdge,
              decoration:  const BoxDecoration(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(25),bottomLeft:Radius.circular(25)
                ),
              ),
              child: Drawer(
                child: Padding(
                  padding: const EdgeInsets.only(right:30,left:30),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(top: 30,bottom: 5),
                        child: (_deviceType==Device.tablet)?Row(
                          children: [
                            Align(alignment:Alignment.centerLeft,child: TextButton(onPressed: widget.goBack, child:  const Icon(Icons.arrow_back))),
                            Text(trs.translate('profile')??"My profile",style: Theme.of(context).textTheme.bodySmall),
                            const Spacer(),
                            const Icon(Icons.person_outline_sharp,size: 25),
                          ],
                        )
                        :Row(
                          children: [
                            Transform.translate(offset: const Offset(-20,0),child: TextButton(onPressed: widget.goBack, child:  const Icon(Icons.arrow_back,))),
                            Transform.translate(offset: const Offset(-30,0),child: Text(trs.translate('profile')??"My profile",style: Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 17))),
                            Expanded(child: Transform.translate(offset: const Offset(-20,0),child: const Icon(Icons.person_outline_sharp,size: 25,))),
                          ],
                        ),
                      ),
                      const Divider(height: 2,),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top:15),
                              child: Text(trs.translate('username')??'Username',style: Theme.of(context).textTheme.bodySmall),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 15.0),
                              child: Text(providerModel.getDbUName,style: Theme.of(context).textTheme.bodyLarge),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top:10),
                              child: Text(trs.translate('lbl_price_group')??'Price groups:',style: Theme.of(context).textTheme.bodySmall),
                            ),
                            DropdownButton<TblDkResPriceGroup>(
                              padding: const EdgeInsets.only(left:20,right:30),
                              value: state.priceGroups.where((element) => element.ResPriceGroupId==state.selectedPriceGroupId).first,
                              isExpanded: true,
                              iconSize: 35,
                              icon:  const Icon(Icons.keyboard_arrow_down,),
                              items: state.priceGroups.map((resPriceGroup) {
                                return DropdownMenuItem(
                                  value: resPriceGroup,
                                  child: Text(resPriceGroup.ResPriceGroupName,),
                                );
                              }).toList(),
                              onChanged: (TblDkResPriceGroup? resPriceGroup) {
                                context.read<UserProfileCubit>().saveUserProfile(resPriceGroup!.ResPriceGroupId);
                              },
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top:10.0),
                              child: Text(trs.translate('init_page')??'Initial page:',style: Theme.of(context).textTheme.bodySmall),
                            ),
                            DropdownButton(
                              padding: const EdgeInsets.only(left:20,right:30),
                              value: dropdownvalue,
                              isExpanded: true,
                              iconSize: 35,
                              icon:  const Icon(Icons.keyboard_arrow_down),
                              items: items.map((String items) {
                                return DropdownMenuItem(
                                  value: items,
                                  child: Text(items,),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  dropdownvalue= newValue!;
                                });
                                saveData(newValue!);
                              },
                            ),

                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ) : const SizedBox.shrink();
        },
    );
  }

  Future saveData(String newValue) async{
    final sharedPref = await SharedPreferences.getInstance();
    sharedPref.setString(SharedPrefKeys.initialPage,newValue);
  }
}

