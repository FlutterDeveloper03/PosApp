import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/helpers/SharedPrefKeys.dart';
import 'package:pos_app/models/tbl_dk_user.dart';
import 'package:pos_app/services/DbService.dart';
import 'package:shared_preferences/shared_preferences.dart';

//region States
abstract class AuthState extends Equatable {
  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthSuccess extends AuthState {
  final String uName;
  final String uPass;
  final TblDkUser user;
  final int posType;

  AuthSuccess(this.uName, this.uPass, this.user,this.posType);

  @override
  List<Object> get props => [user, uName, uPass,posType];

  @override
  String toString() => 'AuthSuccessState { token: $uName }';
}

class AuthFailure extends AuthState {
  final String errorStatus;

  AuthFailure(this.errorStatus);

  @override
  List<Object> get props => [errorStatus];

  @override
  String toString() => 'AuthFailureState { errorStatus: $errorStatus }';
}

class AuthInProgress extends AuthState {}
//endregion States

//region Cubit
class AuthBloc extends Cubit<AuthState> {
  DbService? _srv;
  String host = '';
  int port = 1433;
  String dbName = '';
  String dbUName = '';
  String dbUPass = '';
  int posType = 2;

  AuthBloc() : super(AuthInitial());

  void login(String uName, String uPass) async {
    emit(AuthInProgress());
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      posType = prefs.getInt(SharedPrefKeys.posType) ?? 2; //1=market, 2=Resto
      host = prefs.getString(SharedPrefKeys.serverAddress) ?? "";
      port = prefs.getInt(SharedPrefKeys.serverPort) ?? 1433;
      dbName = prefs.getString(SharedPrefKeys.dbName) ?? "";
      dbUName = prefs.getString(SharedPrefKeys.dbUName) ?? "";
      dbUPass = prefs.getString(SharedPrefKeys.dbUPass) ?? "";
      _srv = DbService(host, port, dbName, dbUName, dbUPass);
      TblDkUser? user = await _srv?.getUserData(uName, uPass);
      if(user != null) {
        emit(AuthSuccess(uName, uPass, user, posType));
      }
      else{
        emit(AuthFailure('Error getting user credentials'));
      }
        } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  void loginByPin(String pin) async {
    emit(AuthInProgress());
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      posType = prefs.getInt(SharedPrefKeys.posType) ?? 2; //1=market, 2=Resto
      host = prefs.getString(SharedPrefKeys.serverAddress) ?? "";
      port = prefs.getInt(SharedPrefKeys.serverPort) ?? 1433;
      dbName = prefs.getString(SharedPrefKeys.dbName) ?? "";
      dbUName = prefs.getString(SharedPrefKeys.dbUName) ?? "";
      dbUPass = prefs.getString(SharedPrefKeys.dbUPass) ?? "";
      _srv = DbService(host, port, dbName, dbUName, dbUPass);
      List<TblDkUser>? users = await _srv?.getUserDataByPin(pin);
      if (users != null && users.length<=1) {
        emit(AuthSuccess('', pin, users.first,posType));
      } else if(users!=null && users.length>1){
        emit(AuthFailure('Pin code is not unique'));
      } else {
        emit(AuthFailure(''));
      }
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  void logOut() async {
    emit(AuthInitial());
  }
}
//endregion Cubit
