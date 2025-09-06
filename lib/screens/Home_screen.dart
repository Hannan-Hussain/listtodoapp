import 'package:flutter/material.dart';
import 'package:listtodoapp/models/Database.Helper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Map<String, dynamic>> _todos = [];
  final TextEditingController _taskController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadTodos();
  }

  Future<void> _loadTodos() async {
    final data = await DatabaseHelper.instance.queryAll();
    setState(() {
      _todos.clear();
      _todos.addAll(data);
    });
  }

  Future<void> _addTodo() async {
    final task = _taskController.text.trim();
    final time = _timeController.text.trim();
    if (task.isEmpty || time.isEmpty) return;

    await DatabaseHelper.instance.insert({'task': task, 'time': time});
    _taskController.clear();
    _timeController.clear();
    _loadTodos();
  }

  Future<void> _removeTodoAt(int id) async {
    await DatabaseHelper.instance.delete(id);
    _loadTodos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My To-Do List", style: TextStyle(color: Colors.white, fontSize: 20,fontWeight: FontWeight.bold),),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 38, 136, 210),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  controller: _taskController,
                  decoration: const InputDecoration(
                    hintText: "Enter a task",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _timeController,
                  decoration: const InputDecoration(
                    hintText: "Enter time or duration",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
          ElevatedButton(
  onPressed: _addTodo,
  style: ElevatedButton.styleFrom(
    backgroundColor: const Color.fromARGB(255, 22, 157, 211),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.zero, // keeps rectangular
    ),
    minimumSize: const Size(100, 48), // ⬅️ width = 100px, height = 48px
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12), // adds spacing inside
  ),
  child: const Text(
    "Add",
    style: TextStyle(color: Colors.white),
  ),
),


              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _todos.length,
              itemBuilder: (context, index) {
                final todo = _todos[index];
                return Card(
                  child: ListTile(
                    title: Text(todo['task']),
                    subtitle: Text("Time: ${todo['time']}"),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _removeTodoAt(todo['id']),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
