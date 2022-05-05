import 'package:flutter/material.dart';

class RepoTitle extends StatelessWidget {
  const RepoTitle({
    required this.url,
  });

  final Uri? url;

  @override
  Widget build(BuildContext context) {
    final String nameString = url?.pathSegments.last ?? "Your Repository";
    final String urlString = url?.toString() ?? "Unknown URL";
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(nameString, style: Theme.of(context).textTheme.displaySmall),
        Text(urlString, style: Theme.of(context).textTheme.headlineSmall),
      ],
    );
  }
}
