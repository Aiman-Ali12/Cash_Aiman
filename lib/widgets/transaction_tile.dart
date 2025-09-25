import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../data/models/transaction_model.dart';
import '../data/providers/transactions_provider.dart';
import '../screens/add_edit_transaction.dart';
import 'package:provider/provider.dart';

class TransactionTile extends StatelessWidget {
  final CashTransaction t;
  TransactionTile(this.t);

  @override
  Widget build(BuildContext context) {
    final amountStr = NumberFormat.currency(symbol: '').format(t.amount);
    return Dismissible(
      key: ValueKey(t.id),
      background: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.red.shade400, Colors.red.shade800], // تدرج أحمر عند الحذف
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: Colors.white, size: 30),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (_) async {
        await Provider.of<TransactionsProvider>(context, listen: false)
            .deleteTransaction(t.id!);
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('تم الحذف')));
      },

      // تصميم بطاقة محسنة لكل معاملة
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: t.type == 'income'
                ? [Colors.white, Colors.orange.shade200]
                : [Colors.red.shade200, Colors.red.shade400],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15),
          boxShadow: const [
            BoxShadow(
              color: Colors.yellow,
              blurRadius: 20,
              offset: Offset(0, 5),
            )
          ],
        ),
        child: ListTile(
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          leading: CircleAvatar(
            radius: 25,
            backgroundColor:
            t.type == 'income' ? Colors.blue : Colors.red.shade700,
            child: Text(t.type == 'income' ? '+' : '-',
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
          title: Text(
            t.title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            DateFormat.yMMMd().format(t.date) +
                (t.note != null && t.note!.isNotEmpty ? ' — ${t.note}' : ''),
          ),
          trailing: Text(
            amountStr,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: t.type == 'income' ? Colors.black: Colors.black,
            ),
          ),
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => AddEditTransaction(t: t)),
          ),
        ),
      ),
    );
  }
}
