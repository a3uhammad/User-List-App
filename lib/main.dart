import 'package:flutter/material.dart';

void main() => runApp(UserListApp());

class User {
  final String name;
  final String email;
  final String source;

  User(this.name, this.email, this.source);
}

class UserListApp extends StatefulWidget {
  @override
  _UserListAppState createState() => _UserListAppState();
}

class _UserListAppState extends State<UserListApp> {
  List<User> users = [];
  final List<String> sources = [
    'Facebook', 'Instagram', 'Organic', 'Friend', 'Google'
  ];
  String? filter;
  String searchQuery = '';
  List<User> batchUsers = [];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'User List App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Scaffold(
        appBar: AppBar(title: Text('User List App')),
        body: users.isEmpty ? buildEntryForm() : buildUserList(),
      ),
    );
  }

  Widget buildEntryForm() {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    String? dropdownValue = sources.first;

    return Padding(
      padding: EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: nameController,
            decoration: InputDecoration(labelText: 'Name'),
          ),
          TextField(
            controller: emailController,
            decoration: InputDecoration(labelText: 'Email'),
          ),

          DropdownButtonFormField<String>(
            value: dropdownValue,
            items: sources.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                dropdownValue = newValue;
              });
            },
          ),
          ElevatedButton(onPressed: (){
            setState(() {
              dropdownValue = sources.first;
              batchUsers.add(User(nameController.text, emailController.text, dropdownValue!));
              nameController.clear();
              emailController.clear();
              //dropdownValue = sources.first;
            });
          }, child: Text('Add Users')),
          ElevatedButton(
            child: Text('Submit'),
            onPressed: () {
              setState(() {
                users.addAll(batchUsers);
                batchUsers.clear();
                //users.add(User(nameController.text, emailController.text, dropdownValue!));
              });
            },
          ),
        ],
      ),
    );
  }

  Widget buildUserList() {
    var displayedUsers = users.where((user) {
      if (filter != null && filter != user.source) {
        return false;
      }
      if (searchQuery.isNotEmpty &&
          !user.name.contains(searchQuery) &&
          !user.email.contains(searchQuery)) {
        return false;
      }
      return true;
    }).toList();

    return Column(
      children: [
        DropdownButton<String>(
          hint: Text("Filter by source"),
          value: filter,
          items: ['All', ...sources].map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              filter = newValue;
              if (filter == 'All') {
                filter = null;
              }
            });
          },
        ),
        TextField(
          onChanged: (value) {
            setState(() {
              searchQuery = value;
            });
          },
          decoration: InputDecoration(labelText: 'Search by name or email'),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: displayedUsers.length,
            itemBuilder: (context, index) {
              final user = displayedUsers[index];
              return ListTile(
                title: Text(user.name),
                subtitle: Text(user.email),
                trailing: Text(user.source),
              );
            },
          ),
        ),
      ],
    );
  }
}