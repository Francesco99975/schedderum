import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:schedderum/helpers/failure.dart';
import 'package:schedderum/screens/error.dart';

class AsyncProviderComparer<T> extends ConsumerWidget {
  final ProviderListenable<AsyncValue<Either<Failure, T>>> provider;
  final Refreshable<Future<Either<Failure, T>>> future;
  final Widget Function(T) render;

  const AsyncProviderComparer({
    super.key,
    required this.provider,
    required this.future,
    required this.render,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(provider);
    return state.when(
      data:
          (value) => value.match(
            (l) => errorWidget(l.message, () => ref.refresh(future)),
            render,
          ),
      error:
          (error, _) =>
              errorWidget(error.toString(), () => ref.refresh(future)),
      loading:
          () => Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).colorScheme.secondary,
              ),
            ),
          ),
    );
  }
}
