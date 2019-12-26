import 'package:flutter/material.dart';
//import 'package:flutter/services.dart';

import './widgets/New_transaction.dart';
import './widgets/Transaction_list.dart';
import './widgets/chart.dart';
import './model/transaction.dart';

void main() {
  // SystemChrome.setPreferredOrientations
  //[DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
  //);
  runApp(MyApp());
} // it is the main point where the app starts

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Expense Tracker',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        accentColor: Colors.amber,
        fontFamily: 'Quicksand',
        textTheme: ThemeData.light().textTheme.copyWith(
            title: TextStyle(
                fontFamily: 'QuickSans',
                fontWeight: FontWeight.bold,
                fontSize: 18),
            button: TextStyle(color: Colors.white)),
      ),
      home: Myhomepage(),
    );
  }
}

class Myhomepage extends StatefulWidget {
  @override
  _MyhomepageState createState() => _MyhomepageState();
}

class _MyhomepageState extends State<Myhomepage> {
  bool _showChart = false;
  final List<Transaction> _userTransaction = [
    /*  Transaction(
      id: 't1',
      title: 'Shoes',
      amount: 5000,
      date: DateTime.now(),
    ),
    Transaction(
      id: 't2',
      title: 'Watch',
      amount: 15000,
      date: DateTime.now(),
    ) */
  ];

  List<Transaction> get _recentTransaction {
    return _userTransaction.where((tx) {
      return tx.date.isAfter(
        DateTime.now().subtract(
          Duration(days: 7),
        ),
      );
    }).toList();
  }

  void _addUserTransaction(String title, double amount, DateTime chosenDate) {
    final newTxt = Transaction(
      title: title,
      amount: amount,
      date: chosenDate,
      id: DateTime.now().toString(),
    );
    setState(
      () {
        _userTransaction.add(newTxt);
      },
    );
  }

  void _startNewTransactions(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          child: NewTransactions(_addUserTransaction),
          behavior: HitTestBehavior.opaque,
        );
      },
    );
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransaction.removeWhere((tx) => tx.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isLandscape =
        mediaQuery.orientation == Orientation.landscape;
    final appBar = AppBar(
      title: Text('Expense Tracker'),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () => _startNewTransactions(context),
        ),
      ],
    );
    final txtTransaction = Container(
      height: (mediaQuery.size.height -
              appBar.preferredSize.height -
              mediaQuery.padding.top) *
          0.7,
      child: TransactionList(_userTransaction, _deleteTransaction),
    );
    final pageBody = SafeArea(child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            if (isLandscape)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Show Chart'),
                  Switch.adaptive(
                    value: _showChart,
                    onChanged: (val) {
                      setState(() {
                        _showChart = val;
                      });
                    },
                  )
                ],
              ),
            if (!isLandscape)
              Container(
                height: (mediaQuery.size.height -
                        appBar.preferredSize.height -
                        mediaQuery.padding.top) *
                    0.3,
                child: Chart(_recentTransaction),
              ),
            if (!isLandscape) txtTransaction,
            if (isLandscape)
              _showChart
                  ? Container(
                      height: (mediaQuery.size.height -
                              appBar.preferredSize.height -
                              mediaQuery.padding.top) *
                          0.65,
                      child: Chart(_recentTransaction),
                    )
                  : txtTransaction,
          ],
          ),
        ),
      );
    return Scaffold(
      appBar: appBar,
      body: pageBody,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _startNewTransactions(context),
      ),
    );
  }
}
