import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../data/models/transaction_model.dart';
import '../data/providers/transactions_provider.dart';

class AddEditTransaction extends StatefulWidget {
  final CashTransaction? t;
  const AddEditTransaction({this.t});
  @override
  State<AddEditTransaction> createState() => _AddEditTransactionState();
}
class _AddEditTransactionState extends State<AddEditTransaction> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late double _amount;
  DateTime _date = DateTime.now();
  String _type = 'expense';
  String? _note;

  @override
  void initState() {
    super.initState();
    if (widget.t != null) {
      _title = widget.t!.title;
      _amount = widget.t!.amount;
      _date = widget.t!.date;
      _type = widget.t!.type;
      _note = widget.t!.note;
    } else {
      _title = '';
      _amount = 0.0;
    }
  }
  _pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => _date = picked);
  }
  _save() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    final t = CashTransaction(
      id: widget.t?.id,
      title: _title,
      amount: _amount,
      date: _date,
      type: _type,
      note: _note,
    );

    final provider = Provider.of<TransactionsProvider>(context, listen: false);
    if (widget.t == null) {
      await provider.addTransaction(t);
    } else {
      await provider.updateTransaction(t);
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar مع زر الرجوع الافتراضي
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.orange,Colors.grey,],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(0),
            ),),),
        title: Text(widget.t == null ? 'إضافة' : 'تعديل'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade50, Colors.blue.shade500],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                // حقل العنوان
                TextFormField(
                  initialValue: _title,
                  decoration: InputDecoration(
                    labelText: 'العنوان',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.transparent,
                  ),
                  validator: (v) =>
                  v == null || v.trim().isEmpty ? 'أدخل عنوان' : null,
                  onSaved: (v) => _title = v!.trim(),
                ),
                const SizedBox(height: 12),

                // حقل المبلغ
                TextFormField(
                  initialValue:
                  widget.t != null ? widget.t!.amount.toString() : '',
                  decoration: InputDecoration(
                    labelText: 'المبلغ',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'أدخل مبلغ';
                    final parsed = double.tryParse(v);
                    if (parsed == null) return 'أدخل رقم صالح';
                    return null;
                  },
                  onSaved: (v) => _amount = double.parse(v!.trim()),
                ),
                const SizedBox(height: 12),
                // اختيار التاريخ
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('التاريخ: ${DateFormat.yMd().format(_date)}'),
                    TextButton(
                      onPressed: _pickDate,
                      child: const Text('اختيار'),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Dropdown لاختيار نوع المعاملة
                DropdownButtonFormField<String>(
                  value: _type,
                  items: const [
                    DropdownMenuItem(value: 'income', child: Text('دخل')),
                    DropdownMenuItem(value: 'expense', child: Text('مصاريف')),
                  ],
                  onChanged: (v) => setState(() => _type = v!),
                  decoration: InputDecoration(
                    labelText: 'النوع',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),

                // حقل الملاحظة الاختيارية
                TextFormField(
                  initialValue: _note ?? '',
                  decoration: InputDecoration(
                    labelText: 'ملاحظة (اختياري)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  onSaved: (v) => _note = v,
                ),
                const SizedBox(height: 20),
                // زر الحفظ بتدرج لوني
                Container(
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: LinearGradient(
                      colors: [Colors.blue.shade400, Colors.blue.shade700],
                    ),
                  ),
                  child: ElevatedButton(
                    onPressed: _save,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'حفظ',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
