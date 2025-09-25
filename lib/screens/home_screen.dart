
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../data/providers/transactions_provider.dart';
import 'add_edit_transaction.dart';
import '../widgets/transaction_tile.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}
class _HomeScreenState extends State<HomeScreen> {
  bool _loading = true;
  @override
  void initState() {
    super.initState();
    _load();
  }
  Future _load() async {
    await Provider.of<TransactionsProvider>(context, listen: false).loadTransactions();
    setState(() => _loading = false);
  }
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TransactionsProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("دفتر النقدية",style: TextStyle(color: Colors.white)),
        flexibleSpace: Container(
          decoration:  BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.grey, Colors.orange.shade500],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius:const  BorderRadius.vertical(
              bottom: Radius.circular(0),
            ),),),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        // color: Colors.deepPurple,
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : Column(
          children: [
            FutureBuilder<double>(
              future: provider.getBalance(),
              builder: (context, snap) {
                if (!snap.hasData) return const SizedBox(height: 80, child: Center(child: CircularProgressIndicator()));
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      colors: [Colors.blue.shade200, Colors.blue.shade700], // تدرج أزرق
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      )
                    ],
                  ),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    margin: const EdgeInsets.all(12),
                      child: ListTile(
                        title:const Text('الرصيد الحالي',textAlign: TextAlign.center, style: TextStyle(fontSize: 18 ,fontWeight: FontWeight.bold)),
                        subtitle: Text(NumberFormat.currency(symbol: '').format(snap.data),textAlign:TextAlign.center,style:const TextStyle(fontSize: 18,fontWeight: FontWeight.bold)),
                      ),
                    ),
                );
              },
            ),
            Expanded(
              child: provider.items.isEmpty
                  ? const Center(child: Text('لا توجد معاملات بعد'))
                  : Container(
                decoration:  BoxDecoration(
                  gradient:  LinearGradient(
                    colors: [Colors.blue.shade50, Colors.blue.shade500],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(0),
                  ),),
                    child: ListView.builder(
                itemCount: provider.items.length,
                itemBuilder: (ctx, i) => TransactionTile(provider.items[i]),
              ),
                  ),
            ),
          ],
        ),
      ),
        floatingActionButton: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: const SweepGradient(
              colors: [Colors.red, Colors.yellow, Colors.blue, Colors.green, Colors.red,],
              stops: <double>[0.0, 0.25, 0.5, 0.75, 1.0],
              tileMode: TileMode.clamp,
            ),
          ),
          child: RawMaterialButton(
            shape: const CircleBorder(),
            elevation: 5,
            child: const Icon(Icons.add, color: Colors.white),
            onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const AddEditTransaction())),
          ),
        )
    );
  }
}