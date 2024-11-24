import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'change_body_state.dart';

class ChangeBodyCubit extends Cubit<ChangeBodyState> {
  ChangeBodyCubit() : super(ChangeBodyInitial());

  void changeBody() {
    emit(ChangeBodyChangeState());
  }
}
