import 'package:crypto_trader/import_facade/controller.dart';
import 'package:crypto_trader/import_facade/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DepositRow extends StatefulWidget {
  @override
  _DepositRowState createState() => _DepositRowState();
}

class _DepositRowState extends State<DepositRow> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => DepositRowState())],
      builder: (context, child) => WithHoldings(
        builder: (holdings) {
          final state = context.watch<DepositRowState>();
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DepositDropdown(state.dropdownValue),
              const SizedBox(width: 20),
              TransactButton(
                Environment.trader.deposit,
                'Deposit Dollars',
                state.dropdownValue.toString(),
              ),
            ],
          );
        },
      ),
    );
  }
}

class DepositRowState extends ChangeNotifier {
  final _dropdownValue = DropdownValue(50);
  var _state = _DepositState.NOTHING;

  int get dropdownValue => _dropdownValue.wrappedInt;

  void changeDropdownValue(int newVal) {
    _dropdownValue.wrappedInt = newVal;
    notifyListeners();
  }

  void start() {
    _state = _DepositState.DEPOSITING;
  }
}

// TODO I'd like to finish implementing this at some point, but I'm taking
//  a break to get back to the granularity dropdown. A big change is necessary:
//  It should apply to both the deposit and the buy button with the same code.
//  The visual I was thinking of was that it would replace the row temporarily.
//  But now I'm realizing there's another cleanup I'd like to throw in also,
//  which is, it should *poll* for the data to propagate; instead of waiting
//  a long time and then giving it one good shot, it should try early, and then
//  try again a few times before giving up and showing the snackbar. Also, all
//  of these in-the-between states should not be shown in the snackbar; I'm not
//  sure if using the AnimatedSwitcher is the right thing to use visually
//  instead or not (ref: https://www.raywenderlich.com/18724197).
enum _DepositState {
  NOTHING,
  DEPOSITING,
  WAITING_TO_PROPAGATE,
}
