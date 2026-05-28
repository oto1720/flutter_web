import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NavBar extends StatelessWidget implements PreferredSizeWidget {
  const NavBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.surface,
      elevation: 0,
      scrolledUnderElevation: 1,
      title: GestureDetector(
        onTap: () => context.go('/'),
        child: Text(
          'Portfolio',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => context.go('/'), child: const Text('Home')),
        TextButton(
          onPressed: () => context.go('/about'),
          child: const Text('About'),
        ),
        TextButton(
          onPressed: () => context.go('/work'),
          child: const Text('Work'),
        ),
        const SizedBox(width: 16),
      ],
    );
  }
}
