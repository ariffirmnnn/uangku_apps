import 'package:flutter/material.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String selectedDate = '';
  Map<String, List<Map<String, dynamic>>> transactionsByDate = {
    '15 Januari 2024': [
      {'title': 'Gaji Freelance', 'amount': 12000000, 'type': 'Pemasukan'},
      {'title': 'Beli Motor', 'amount': -26000000, 'type': 'Pengeluaran'},
    ],
  };

  @override
  void initState() {
    super.initState();
    selectedDate = _getFormattedDate(DateTime.now()); // Set selectedDate to today's date
  }

  String _getFormattedDate(DateTime date) {
    List<String> months = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  void _onDateSelected(String date) {
    setState(() {
      selectedDate = date;
      if (!transactionsByDate.containsKey(date)) {
        transactionsByDate[date] = [];
      }
    });
  }

  void _showTransactionModal() {
    String selectedType = 'Pemasukan'; // Default value
    TextEditingController titleController = TextEditingController();
    TextEditingController amountController = TextEditingController();

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: 'Judul Transaksi'),
              ),
              TextField(
                controller: amountController,
                decoration: InputDecoration(labelText: 'Jumlah'),
                keyboardType: TextInputType.number,
              ),
              DropdownButton<String>(
                value: selectedType,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedType = newValue!;
                  });
                },
                items: <String>['Pemasukan', 'Pengeluaran']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              ElevatedButton(
                onPressed: () {
                  if (titleController.text.isNotEmpty && amountController.text.isNotEmpty) {
                    setState(() {
                      transactionsByDate[selectedDate]?.add({
                        'title': titleController.text,
                        'amount': int.parse(amountController.text),
                        'type': selectedType,
                      });
                    });
                    Navigator.pop(context);
                  }
                },
                child: Text('Simpan'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showEditTransactionModal(int index) {
    final transaction = transactionsByDate[selectedDate]?[index];
    String selectedType = transaction?['type'] ?? 'Pemasukan'; // Default value
    TextEditingController titleController = TextEditingController(text: transaction?['title']);
    TextEditingController amountController = TextEditingController(text: transaction?['amount'].toString());

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: 'Judul Transaksi'),
              ),
              TextField(
                controller: amountController,
                decoration: InputDecoration(labelText: 'Jumlah'),
                keyboardType: TextInputType.number,
              ),
              DropdownButton<String>(
                value: selectedType,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedType = newValue!;
                  });
                },
                items: <String>['Pemasukan', 'Pengeluaran']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    transactionsByDate[selectedDate]?[index] = {
                      'title': titleController.text,
                      'amount': int.parse(amountController.text),
                      'type': selectedType,
                    };
                  });
                  Navigator.pop(context);
                },
                child: Text('Simpan'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _deleteTransaction(int index) {
    setState(() {
      transactionsByDate[selectedDate]?.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> transactions = transactionsByDate[selectedDate] ?? [];
    int totalPemasukan = transactions
        .where((transaction) => transaction['type'] == 'Pemasukan')
        .fold(0, (sum, item) => sum + (item['amount'] as int));
    int totalPengeluaran = transactions
        .where((transaction) => transaction['type'] == 'Pengeluaran')
        .fold(0, (sum, item) => sum + (item['amount'] as int));

    DateTime today = DateTime.now();
    String todayFormatted = _getFormattedDate(today);

    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text("UANGKU"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text("Hi, Arif", style: TextStyle(fontSize: 24, color: Colors.black54)),
            const SizedBox(height: 16),
            Text('Tanggal Hari Ini: $todayFormatted', style: TextStyle(fontSize: 18, color: Colors.black87)),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    DashboardCard(title: "Total Pemasukan", amount: "Rp. $totalPemasukan"),
                    const SizedBox(height: 8),
                    DashboardCard(title: "Total Pengeluaran", amount: "Rp. $totalPengeluaran"),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(7, (index) {
                String date = (12 + index).toString();
                String weekday = ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu'][index];
                return GestureDetector(
                  onTap: () => _onDateSelected('$date Januari 2024'),
                  child: CalendarDay(
                    day: date,
                    weekday: weekday,
                    isSelected: selectedDate == '$date Januari 2024',
                  ),
                );
              }),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: transactions.length,
                itemBuilder: (context, index) {
                  final transaction = transactions[index];
                  return GestureDetector(
                    onLongPress: () => _showEditTransactionModal(index),
                    child: Dismissible(
                      key: Key(transaction['title'] + index.toString()),
                      onDismissed: (direction) {
                        _deleteTransaction(index);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Transaksi dihapus")));
                      },
                      background: Container(color: Colors.red),
                      child: TransactionItem(
                        title: transaction['title'],
                        amount: transaction['amount'],
                        isIncome: transaction['type'] == 'Pemasukan',
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () => _showTransactionModal(),
                  child: const Text("Tambah"),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (transactions.isNotEmpty) {
                      _showEditTransactionModal(0);
                    }
                  },
                  child: const Text("Edit"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class DashboardCard extends StatelessWidget {
  final String title;
  final String amount;

  const DashboardCard({required this.title, required this.amount});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontSize: 16, color: Colors.black87)),
        Text(amount, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    );
  }
}

class CalendarDay extends StatelessWidget {
  final String day;
  final String weekday;
  final bool isSelected;

  const CalendarDay({required this.day, required this.weekday, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.blue,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: isSelected ? Colors.blue : Colors.transparent),
          ),
          child: Text(
            day,
            style: TextStyle(
              fontSize: 16,
              color: isSelected ? Colors.blue : Colors.white,
            ),
          ),
        ),
        Text(weekday, style: const TextStyle(fontSize: 14, color: Colors.black38)),
      ],
    );
  }
}

class TransactionItem extends StatelessWidget {
  final String title;
  final int amount;
  final bool isIncome;

  const TransactionItem({required this.title, required this.amount, required this.isIncome});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 16)),
          Text(
            'Rp. ${amount.toString()}',
            style: TextStyle(
              fontSize: 16,
              color: isIncome ? Colors.blue : Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}
