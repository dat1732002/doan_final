import 'package:flutter_riverpod/flutter_riverpod.dart';


abstract class BaseStateDelegate<V extends ConsumerStatefulWidget,
N extends AutoDisposeNotifier> extends ConsumerState<V> {
  late final N notifier;

  void initNotifier();

  @override
  void initState() {
    super.initState();
    initNotifier();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
