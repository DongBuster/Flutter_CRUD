import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_crud/model/user.dart';
part 'user_list_event.dart';
part 'user_list_state.dart';

class UserListBloc extends Cubit<List<User>> {
  UserListBloc() : super([]);
  void addUser(User user) {
    emit([...state, user]);
  }

  void deleteUser(User user) {
    state.remove(user);
    emit([...state]);
  }

  void updateUser(User user) {
    for (var i = 0; i < state.length; i++) {
      if (state[i].id == user.id) {
        print(user.username);
        state[i] = user;
      }
    }
    emit([...state]);
  }
}
