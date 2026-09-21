import 'package:fintrack/cubit/shared/simple_state.dart';
import 'package:fintrack/data/models/notification_model.dart';
import 'package:fintrack/data/repositories/finance_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationsCubit extends Cubit<SimpleLoadState<NotificationInbox>> {
  NotificationsCubit(this._repository) : super(const SimpleLoading());

  final FinanceRepository _repository;

  Future<void> load() async {
    if (state is! SimpleLoaded<NotificationInbox>) {
      emit(const SimpleLoading());
    }
    try {
      emit(SimpleLoaded(await _repository.notifications()));
    } catch (error) {
      emit(SimpleFailure(error.toString()));
    }
  }

  Future<void> markRead(int id) async {
    try {
      emit(SimpleLoaded(await _repository.markNotificationRead(id)));
    } catch (error) {
      emit(SimpleFailure(error.toString()));
    }
  }

  Future<void> markAllRead() async {
    try {
      emit(SimpleLoaded(await _repository.markAllNotificationsRead()));
    } catch (error) {
      emit(SimpleFailure(error.toString()));
    }
  }

  void clear() {
    emit(const SimpleLoaded(NotificationInbox(items: [], unreadCount: 0)));
  }
}
