import 'package:flutter/material.dart';
import 'package:grocery_expiry_reminder/model/grocery_item.dart';
import 'package:grocery_expiry_reminder/service/notification_service.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  final Function(bool) toggleTheme;
  final bool isDarkMode;
  const HomeScreen(
      {super.key, required this.toggleTheme, required this.isDarkMode});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _nameController = TextEditingController();
  DateTime? _selectedDate;

  Box<GroceryItem> get groceryBox => Hive.box<GroceryItem>('groceryBox');

  //open date picker
  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2101));
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  //adding item
  Future<void> _addItem() async {
    if (_nameController.text.isEmpty || _selectedDate == null) return;

    final item =
        GroceryItem(name: _nameController.text, expiryDate: _selectedDate!);
    groceryBox.add(item);
    // Schedule notification 1 day before expiry
    final reminderDate = item.expiryDate.subtract(const Duration(days: 1));
    await NotificationService.scheduleNotification(
      id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title: 'Grocery Expiry Reminder',
      body: '${item.name} expires tomorrow!',
      scheduledDate: reminderDate,
    );
    _nameController.clear();
    _selectedDate = null;
    setState(() {});
  }

  //days left
  int _daysLeft(DateTime expiryDate) {
    return expiryDate.difference(DateTime.now()).inDays;
  }

  //color indicatore

  Color _getColorIndicator(int daysLeft) {
    if (daysLeft <= 1) return Colors.red;
    if (daysLeft <= 3) return Colors.orange;
    return Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Grocery Expiry Reminder'),
        actions: [
          Switch(
            value: widget.isDarkMode,
            onChanged: widget.toggleTheme,
          ),
        ],
      ),
      body: ValueListenableBuilder(
          valueListenable: groceryBox.listenable(),
          builder: (context, Box<GroceryItem> box, _) {
            final items = box.values.toList();

            return Column(children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Item Name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                            child: Text(_selectedDate == null
                                ? 'No date chossen '
                                : 'Expiry: ${DateFormat('dd MMM yyyy').format(_selectedDate!)}')),
                        ElevatedButton(
                          onPressed: () => _pickDate(context),
                          child: const Text('Pick Date'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: _addItem,
                      child: Text('Add Item'),
                    ),
                  ],
                ),
              ),
              const Divider(),
              Expanded(
                  child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  final daysLeft = _daysLeft(item.expiryDate);
                  final color = _getColorIndicator(daysLeft);

                  return ListTile(
                    title: Text(item.name),
                    subtitle: Text(
                        'Expires in $daysLeft day${daysLeft == 1 ? '' : 's'}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircleAvatar(
                          backgroundColor: color,
                          radius: 8,
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            item.delete(); // HiveObject delete
                          },
                        ),
                      ],
                    ),
                  );
                },
              ))
            ]);
          }),
    );
  }
}
