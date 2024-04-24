import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_crud/bloc/user_list_bloc.dart';

import '../../model/user.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
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
      body: BlocBuilder<UserListBloc, List<User>>(
        bloc: BlocProvider.of<UserListBloc>(context),
        builder: (context, state) {
          return ListView.builder(
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            itemCount: state.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: Text(
                  '$index',
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                title: Text(
                  state[index].username,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  state[index].email,
                  style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
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
                              userEdit: state[index],
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
                              .deleteUser(state[index]);
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
              );
            },
          );

          // return const CircularProgressIndicator();
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
          width: 60,
          height: 25,
          decoration: BoxDecoration(
              color: Colors.green, borderRadius: BorderRadius.circular(5)),
          alignment: Alignment.center,
          child: const Text(
            'Edit',
            style: TextStyle(color: Colors.white),
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
                BlocProvider.of<UserListBloc>(context).updateUser(userEdit!);
              } else {
                final userAdd = User(
                    username: controllerUsername.text,
                    email: controllerEmail.text,
                    id: DateTime.now().toString());
                BlocProvider.of<UserListBloc>(context).addUser(userAdd);
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
