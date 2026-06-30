import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AsyncValueWidget<T> extends StatelessWidget {
  final AsyncValue<T> value;
  final Widget Function(T data) data;
  final Widget? loading;
  final Widget Function(Object error, StackTrace? stack)? error;
  final Widget? empty;
  final T? Function(T data)? emptyCheck;

  const AsyncValueWidget({
    super.key,
    required this.value,
    required this.data,
    this.loading,
    this.error,
    this.empty,
    this.emptyCheck,
  });

  @override
  Widget build(BuildContext context) {
    return value.when(
      loading: () =>
          loading ??
          Center(
            child: CircularProgressIndicator(color: Theme.of(context).colorScheme.primary),
          ),
      error: (e, st) =>
          error?.call(e, st) ??
          Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline,
                      size: 56, color: Theme.of(context).colorScheme.error),
                  const SizedBox(height: 16),
                  Text(e.toString(),
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(color: Theme.of(context).colorScheme.error, fontSize: 14)),
                ],
              ),
            ),
          ),
      data: (d) {
        if (empty != null && emptyCheck != null && emptyCheck!(d) == true) {
          return empty!;
        }
        return data(d);
      },
    );
  }
}
