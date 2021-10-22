import 'dart:collection';

import 'package:crypto_trader/import_facade/controller.dart';
import 'package:crypto_trader/import_facade/model.dart';
import 'package:crypto_trader/import_facade/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DepositCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => DepositCardValue())],
      builder: (context, child) => WithHoldings(builder: (holdings) {
            final state = context.watch<DepositCardValue>();
            return Card(
                shape: _roundedRectOuter(),
                elevation: 5,
                child: Container(
                    decoration: _roundedRectInner(),
                    height: MediaQuery.of(context).size.height / 6,
                    width: MediaQuery.of(context).size.width / 2.2,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [_title(), _body(state)])));
          }));

  RoundedRectangleBorder _roundedRectOuter() => RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      );

  BoxDecoration _roundedRectInner() => BoxDecoration(
        border: Border.all(color: Colors.green[900]!),
        borderRadius: BorderRadius.circular(20),
        color: Colors.red[200]!.withOpacity(.3),
      );

  MyText _title() => MyText(
        'Deposit Dollars',
        fontSize: 18,
        color: Colors.grey[300],
      );

  Row _body(DepositCardValue state) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          DepositDropdown(state.value),
          TransactButton(
            Environment.trader.deposit,
            Colors.yellow.withOpacity(.7),
            state,
          ),
        ],
      );
}

class DepositCardValue extends ValueNotifier<String> {
  DepositCardValue() : super(50.toString());
}

// TODO Finish this. Still haven't quite figured out how it's gonna work.
//  Could be best to start out with a design doc.
//  See diagram in https://lucid.app/lucidchart/6b93f504-d4fe-4678-ac79-7367588f256f/edit?invitationId=inv_b2451dd2-8c3a-4353-8815-b600572ba92d
class DepositAction extends AppAction {
  DepositAction(this.amount);

  final Dollars amount;
  late final Holdings holdingsCopy;

  @override
  Future<void> request() async {
    holdingsCopy = (await Environment.trader.getMyHoldings()).copy();
    await Environment.trader.deposit(amount);
  }

  @override
  Future<void> verify() async {
    int numRuns = 0;
    while (numRuns++ < 6) {
      await Future.delayed(const Duration(seconds: 2));
      final holdings = await Environment.trader.forceRefreshHoldings();
      if (holdings != holdingsCopy) return;
    }
    throw StateError('Operation timed out');
  }
}

enum _ActionState {
  scheduled,
  requesting,
  verifying,
  completeWithoutError,
  error,
}

abstract class AppAction {
  var state = _ActionState.scheduled;

  Future<void> request();

  Future<void> verify();
}

// TODO probably needs a synchronization lock.
class Executor extends ChangeNotifier {
  final _actions = Queue<AppAction>();

  void add(AppAction action) {
    _actions.addLast(action);
    _onAdd();
  }

  Future<void> _onAdd() async {
    if (_actions.first.state == _ActionState.scheduled) {
      _actions.first.state = _ActionState.requesting;
      await _actions.first.request();
      notifyListeners();
    }
  }
}
