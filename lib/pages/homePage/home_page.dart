// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_crud/pages/detailPage/detail_page.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'package:flutter_crud/bloc/user_list_bloc.dart';
import 'package:uuid/uuid.dart';

import '../../model/user.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    BlocProvider.of<UserListBloc>(context).add(LoadLocalUser());

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Center(
          child: Text(
            'CRUD',
            style: TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: BlocBuilder<UserListBloc, UserListState>(
        builder: (context, state) {
          if (state is UserListUpdated && state.users.isNotEmpty) {
            return ListView.builder(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              itemCount: state.users.length,
              itemBuilder: (context, index) {
                return ItemList(
                    index: index,
                    username: state.users[index].username,
                    email: state.users[index].email,
                    user: state.users[index]);
              },
            );
          }
          if (state.users.isEmpty) {
            return const SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: Center(
                child: Text('No users'),
              ),
            );
          }
          return Center(
            child: LoadingAnimationWidget.dotsTriangle(
              color: Colors.blue,
              size: 30,
            ),
          );
        },
      ),
      bottomSheet: GestureDetector(
        onTap: () => showModalBottomSheet(
            context: context,
            builder: (context) => ChangeListModalBottomSheet(
                  isEdit: false,
                  userEdit: null,
                )),
        child: Container(
          margin: const EdgeInsets.only(bottom: 15),
          width: 80,
          height: 27,
          decoration: BoxDecoration(
              color: Colors.green, borderRadius: BorderRadius.circular(5)),
          alignment: Alignment.center,
          child: const Text(
            'Add user',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}

class ItemList extends StatelessWidget {
  final int index;
  String username;
  String email;
  User user;
  ItemList({
    super.key,
    required this.index,
    required this.username,
    required this.email,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context)
          .push(MaterialPageRoute(builder: (_) => DetailPage(user: user))),
      child: ListTile(
        leading: Text(
          '$index',
          style: const TextStyle(
            color: Colors.greenAccent,
            fontSize: 18,
          ),
        ),
        title: Text(
          username,
          style: const TextStyle(
              color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          email,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 18,
          ),
        ),
        trailing: SizedBox(
          height: 30,
          width: 100,
          child: Row(
            children: [
              IconButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) => ChangeListModalBottomSheet(
                      isEdit: true,
                      userEdit: user,
                    ),
                  );
                },
                icon: const Icon(
                  Icons.mode_edit_outline_outlined,
                  color: Colors.blue,
                  size: 22,
                ),
              ),
              IconButton(
                onPressed: () {
                  BlocProvider.of<UserListBloc>(context)
                      .add(DeleteUser(user: user));
                },
                icon: const Icon(
                  Icons.delete,
                  color: Colors.redAccent,
                  size: 22,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ChangeListModalBottomSheet extends StatelessWidget {
  final bool isEdit;
  final User? userEdit;
  ChangeListModalBottomSheet({
    super.key,
    required this.isEdit,
    required this.userEdit,
  });

  final controllerUsername = TextEditingController();
  final controllerEmail = TextEditingController();
  @override
  Widget build(BuildContext context) {
    isEdit ? controllerUsername.text = userEdit!.username : controllerUsername;
    isEdit ? controllerEmail.text = userEdit!.email : controllerEmail;
    return Container(
      margin: const EdgeInsets.all(10),
      height: 230,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(height: 15),
          Text(
            isEdit ? 'UPDATE USER' : 'ADD USER',
            style: const TextStyle(
                color: Colors.blue, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 45,
            child: TextField(
              controller: controllerUsername,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'UserName',
                contentPadding: EdgeInsets.only(left: 12),
              ),
            ),
          ),
          const SizedBox(height: 5),
          SizedBox(
            height: 45,
            child: TextField(
              controller: controllerEmail,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Email',
                contentPadding: EdgeInsets.only(left: 12),
              ),
            ),
          ),
          const SizedBox(height: 15),
          GestureDetector(
            onTap: () {
              if (isEdit) {
                userEdit!.setUsername = controllerUsername.text;
                userEdit!.setEmail = controllerEmail.text;
                BlocProvider.of<UserListBloc>(context)
                    .add(UpdateUser(user: userEdit!));
              } else {
                var uuid = const Uuid();
                final userAdd = User(
                  username: controllerUsername.text,
                  email: controllerEmail.text,
                  id: uuid.v1(),
                  createAt: DateFormat('HH:mm:ss - dd/MM/yyyy')
                      .format(DateTime.now()),
                );
                BlocProvider.of<UserListBloc>(context)
                    .add(AddUser(user: userAdd));
              }
              Navigator.pop(context);
            },
            child: Container(
              // margin: const EdgeInsets.only(bottom: 15),
              width: 70,
              height: 30,
              decoration: BoxDecoration(
                  color: Colors.green, borderRadius: BorderRadius.circular(5)),
              alignment: Alignment.center,
              child: Text(
                isEdit ? 'Update' : 'Add',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
