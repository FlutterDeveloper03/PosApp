// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pos_app/bloc/SplashScreenPageCubit.dart';
import 'package:pos_app/helpers/enums.dart';
import 'package:pos_app/helpers/localization.dart';
import 'package:pos_app/widgets/GlassMorphism.dart';

class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({super.key});

  @override
  SplashScreenPState createState() => SplashScreenPState();
}

class SplashScreenPState extends State<SplashScreenPage> with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  Device _deviceType = Device.mobile;

  //Animation _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 1));
  }

  @override
  void dispose() {
    if (_controller != null) _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final trs = AppLocalizations.of(context);
    Orientation orientation=MediaQuery.of(context).orientation;
    _deviceType = (MediaQuery.of(context).size.width < 800) ? Device.mobile : Device.tablet;
    final double height = MediaQuery.of(context).size.height;
    final double fontSize = height >= 550 ? 14 : MediaQuery.sizeOf(context).width/70;
    if (_controller != null) _controller?.forward();
    return Scaffold(
            body: BlocConsumer<SplashScreenPageCubit,SplashScreenPageState>(
              listener: (context, state) {
                if(state is SplashScreenPageInitial || state is SplashScreenPageErrorState){
                  context.read<SplashScreenPageCubit>().loadSplashScreenPage();
                }
                else if (state is CantConnectToServerState){
                  _showDialog(context);
                }
               else if(state is UnregisteredState){
                  GoRouter.of(context).go('/activationPage');
                }
                else if(state is ServerSettingsEmptyState){
                  GoRouter.of(context).go('/serverSettings');
                }
                else if(state is SplashScreenPageLoadedState){
                  if(state.posType==1){
                    GoRouter.of(context).go('/marketHome');
                  }
                  else{
                    GoRouter.of(context).go('/restoHome');
                  }
                  // GoRouter.of(context).go('/loginPage');
                }
              },
              builder: (context, state) {
                if(state is LoadingSplashScreenPageData){
                  return (_deviceType == Device.tablet) ?
                  Stack(children: [
                    Container(
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/images/SplashScreen.JPG"),
                          fit: BoxFit.cover,
                        ),
                      ),
                      alignment: const Alignment(0, 0),
                      child: GlassMorphism(
                        width: 425,
                        height: 273,
                        child: Align(
                          alignment: Alignment.center,
                          child: Column(
                            children: [
                              Text(
                                "POS",
                                  style: Theme.of(context).textTheme.labelMedium!.copyWith(fontWeight: FontWeight.bold,
                                    fontSize: 96,
                                    color: Colors.yellow,)
                              ),
                              Text(
                                "APP",
                                  style: Theme.of(context).textTheme.labelMedium!.copyWith(fontWeight: FontWeight.bold,
                                    fontSize: 96,
                                    color: Colors.white,)
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                        top: 15,
                        left: 15,
                        child: GlassMorphism(
                          width: 320,
                          height: 180,
                          child: ListView(
                            children: [
                              _widget(trs.translate('connecting_to_db')??'Connecting to db', state.dbConnection, fontSize),
                              _widget(trs.translate('checking_licence')??'Checking licence', state.licenceStatus, fontSize),
                              _widget(trs.translate('loading_data_from_db')??'Loading data from DB', state.loadingData, fontSize),
                              _widget(trs.translate('check_settings')??'Checking settings',state.settings,fontSize)
                            ],
                          ),
                        ))
                  ]) :
                  (orientation == Orientation.landscape) ?
                  Stack(children: [
                    Container(
                      constraints: const BoxConstraints.expand(),
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/images/SplashScreen.JPG"),
                          fit: BoxFit.cover,
                        ),
                      ),
                      alignment: const Alignment(0.3, 0.2),
                      child: GlassMorphism(
                        width: MediaQuery.of(context).size.width/2,
                        height: MediaQuery.of(context).size.height/1.3,
                        child: Align(
                          alignment: Alignment.center,
                          child: Column(
                            children: [
                              Text(
                                "POS",
                                  style: Theme.of(context).textTheme.labelMedium!.copyWith(fontWeight: FontWeight.bold,
                                    fontSize: 91,
                                    color: Colors.yellow,
                                  ),
                                  ),
                              Text(
                                "APP",
                                  style: Theme.of(context).textTheme.labelMedium!.copyWith(fontWeight: FontWeight.bold,
                                    fontSize: 91,
                                    color: Colors.white,)
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                        top: 15,
                        left: 15,
                        child: GlassMorphism(
                          width: MediaQuery.of(context).size.width/3.6,
                          height: MediaQuery.of(context).size.height/1.9,
                          child: ListView(
                            children: [
                              _widget(trs.translate('connecting_to_db')??'Connecting to db', state.dbConnection, fontSize),
                              _widget(trs.translate('checking_licence')??'Checking licence', state.licenceStatus, fontSize),
                              _widget(trs.translate('loading_data_from_db')??'Loading data from DB', state.loadingData, fontSize),
                              _widget(trs.translate('check_settings')??'Checking settings',state.settings, fontSize)
                            ],
                          ),
                        ))
                  ])
                      : Stack(children: [
                    Container(
                      height: height,
                      decoration: const BoxDecoration(
                        color: Color(0xff003A3E),
                        image: DecorationImage(
                          image: AssetImage("assets/images/SplashScreen2.webp"),
                          fit: BoxFit.contain,
                          alignment: Alignment.bottomCenter
                        ),
                      ),
                      alignment: const Alignment(0, 0),
                      child:  GlassMorphism(
                        width: MediaQuery.of(context).size.width/1.1,
                        height: MediaQuery.of(context).size.height/3.2,
                        child: Align(
                          alignment: Alignment.center,
                          child: Column(
                            children: [
                               Expanded(
                                 child: Text(
                                  "POS",
                                    style: Theme.of(context).textTheme.labelMedium!.copyWith(fontWeight: FontWeight.bold,
                                      fontSize: 91,
                                      color: Colors.yellow,)
                                                               ),
                               ),
                              Expanded(
                                child: Text(
                                  "APP",
                                  style: Theme.of(context).textTheme.labelMedium!.copyWith(fontWeight: FontWeight.bold,
                                    fontSize: 96,
                                    color: Colors.white,),
                                  overflow:TextOverflow.clip
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                        top: 15,
                        left: 15,
                        child: GlassMorphism(
                          width: MediaQuery.of(context).size.width/1.2,
                          height: MediaQuery.of(context).size.height/4,
                          child: ListView(
                            children: [
                              _widget(trs.translate('connecting_to_db')??'Connecting to db', state.dbConnection, fontSize),
                              _widget(trs.translate('checking_licence')??'Checking licence', state.licenceStatus, fontSize),
                              _widget(trs.translate('loading_data_from_db')??'Loading data from DB', state.loadingData, fontSize),
                              _widget(trs.translate('check_settings')??'Checking settings',state.settings,fontSize)
                            ],
                          ),
                        ))
                  ]);
                }
                else if(state is SplashScreenPageErrorState){
                  return Center(
                    child: Column(
                      children: [
                        Text("${trs.translate("error_text") ?? "Error"}: ${state.getErrorString}"),
                        TextButton(
                            onPressed: () => context.read<SplashScreenPageCubit>().loadSplashScreenPage(),
                            child: Text(trs.translate('try_again')??"Try again"))
                      ],
                    ),
                  );
                }
                return const SizedBox.shrink();
              }
            ),
          );
  }

  Widget _widget(String text, Status status, double fontSize) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(
                text,
                style: Theme.of(context).textTheme.labelMedium!.copyWith(fontSize: fontSize,color:Colors.yellow)
              ),
            ),
          ),
          setStatus(status)
        ],
      ),
    );
  }
  Widget setStatus(Status status) {
    Widget widget = const SizedBox.shrink();
    switch (status) {
      case Status.initial:
        widget = const SizedBox.shrink();
        break;
      case Status.onProgress:
        widget = const SizedBox(
          height: 18.0,
          width: 18.0,
          child: CircularProgressIndicator(),
        );
        break;
      case Status.completed:
        widget = const Icon(
          Icons.check,
          color: Colors.green,
        );
        break;
      case Status.failed:
        widget = const Icon(
          Icons.close,
          color: Colors.red,
        );
        break;
      default:
        widget = const SizedBox.shrink();
    }
    return widget;
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
                 context.read<SplashScreenPageCubit>().loadSplashScreenPage(loadMode: DbConnectionMode.offlineMode.value);
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
}
