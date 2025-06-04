import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:schedderum/helpers/failure.dart';
import 'package:schedderum/screens/error.dart';
import 'package:schedderum/screens/loading.dart';

class AsyncProviderWrapper<T> extends ConsumerWidget {
  final ProviderListenable<AsyncValue<Either<Failure, T>>> provider;
  final Refreshable<Future<Either<Failure, T>>> future;
  final Widget Function(T) render;
  final Option<Widget> errorOverride;

  const AsyncProviderWrapper({
    super.key,
    required this.provider,
    required this.future,
    required this.render,
    this.errorOverride = const Option.none(),
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(provider);

    return state.when(
      data:
          (value) => value.match(
            (l) => errorOverride.match(
              () => ErrorScreen(
                errorMessage: "server error: ${l.message}",
                onRetry: () => ref.refresh(future),
              ),
              (override) => override,
            ),
            render,
          ),
      error:
          (error, _) => errorOverride.match(
            () => ErrorScreen(
              errorMessage: "runtime error: $error",
              onRetry: () => ref.refresh(future),
            ),
            (override) => override,
          ),
      loading: () => const LoadingScreen(),
    );
  }
}
