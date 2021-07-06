import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

part 'stopwatch_state.dart';

class StopwatchCubit extends Cubit<StopwatchState> {
  StopwatchCubit() : super(StopwatchInitial());
}
