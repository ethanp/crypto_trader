import 'package:crypto_trader/import_facade/controller.dart';
import 'package:crypto_trader/import_facade/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DepositCard extends StatefulWidget {
  @override
  _DepositCardState createState() => _DepositCardState();
}

class _DepositCardState extends State<DepositCard> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [ChangeNotifierProvider(create: (_) => DepositCardState())],
        builder: (context, child) => WithHoldings(builder: (holdings) {
              final state = context.watch<DepositCardState>();
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
  }

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

  Row _body(DepositCardState state) => Row(
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

const int _initial = 50;

class DepositCardState extends ValueNotifier<String> {
  DepositCardState() : super(_initial.toString());

  var _state = _DepositState.nothing;

  void start() {
    _state = _DepositState.depositing;
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
  nothing,
  depositing,
  waitingToPropagate,
}
