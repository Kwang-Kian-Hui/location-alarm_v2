import 'package:riverpod/riverpod.dart';

import 'package:location_alarm/application/addedit_alarm_form_state.dart';
import 'package:location_alarm/infrastructure/alarm_repository.dart';


class AddEditAlarmFormNotifier extends StateNotifier<AddEditAlarmFormState> {
  final AlarmRepository _alarmRepository;
  AddEditAlarmFormNotifier(this._alarmRepository): super(AddEditAlarmFormState.initial());
  
  void alarmNameChanged(String name){
    state = state.copyWith(alarmName: name.trim());
  }

  void alarmRadiusChanged(int radius){
    state = state.copyWith(alarmRadius: radius);
  }

  void alarmDestLatChanged(){

  }

  void alarmDestLngChanged(){
    
  }

  void alarmCameraPositionChanged(){

  }

  void mapLoadedStateChanged(){
    state = state.copyWith(hasMapLoaded: !state.hasMapLoaded);
  }

  void initialPositionStateChanged(){
    state = state.copyWith(hasInitialPositionLoaded: !state.hasInitialPositionLoaded);
  }

  Future<void> _validateInputs() async{

  }

  void addAlarm(){
    
  }
}