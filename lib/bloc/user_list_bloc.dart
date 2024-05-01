import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_crud/model/user.dart';

import '../localstore/local_datebase.dart';
part 'user_list_event.dart';
part 'user_list_state.dart';

class UserListBloc extends Bloc<UserListEvent, UserListState> {
  final localStore = LocalStoreService();

  UserListBloc() : super(UserListInitial(users: [])) {
    on<LoadLocalUser>((event, emit) => initialListUser(emit));
    on<AddUser>((event, emit) => addUser(event, emit));
    on<DeleteUser>((event, emit) => deleteUser(event, emit));
    on<UpdateUser>((event, emit) => updateUser(event, emit));
  }

  void initialListUser(Emitter<UserListState> emit) async {
    List<User> users = [];
    await localStore
        .loadItems()
        .then((value) => value != null ? users.addAll(value) : null);
    emit(UserListUpdated(users: users));
  }

  void addUser(AddUser event, Emitter<UserListState> emit) {
    state.users.add(event.user);
    localStore.addItem(event.user);
    localStore.loadItems().then((value) => print(value));

    emit(UserListUpdated(users: state.users));
  }

  void deleteUser(DeleteUser event, Emitter<UserListState> emit) {
    state.users.remove(event.user);
    localStore.removeItem(event.user.id);
    emit(UserListUpdated(users: state.users));
  }

  void updateUser(UpdateUser event, Emitter<UserListState> emit) {
    for (var i = 0; i < state.users.length; i++) {
      if (state.users[i].id == event.user.id) {
        // print(user.username);
        state.users[i] = event.user;
      }
    }
    localStore.updateItem(event.user);
    emit(UserListUpdated(users: state.users));
  }
}
