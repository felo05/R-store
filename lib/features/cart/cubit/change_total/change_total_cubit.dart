import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'change_total_state.dart';

class ChangeTotalCubit extends Cubit<ChangeTotalState> {
  ChangeTotalCubit() : super(ChangeTotalInitial());

  void changeTotal() {
    emit(ChangeTotalChangeState());
  }
}
