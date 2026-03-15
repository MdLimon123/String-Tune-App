import 'package:flutter/material.dart';

import 'package:demo_project/app/features/user_list/model/user_model.dart';

class UserTile extends StatelessWidget {
  final UserModel user;
  final VoidCallback? onTap;

  const UserTile({super.key, required this.user, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: user.avatar != null ? NetworkImage(user.avatar!) : null,
        child: user.avatar == null
            ? Text(user.name.isNotEmpty ? user.name[0].toUpperCase() : '?')
            : null,
      ),
      title: Text(user.name),
      subtitle: Text(user.email),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
