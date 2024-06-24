import 'package:flutter/material.dart';

class Todo {
  String title;
  bool isCompleted;

  Todo({
    required this.title,
    this.isCompleted = false,
  });
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController todoController = TextEditingController();
  List<Todo> todos = [];

  int selectedIndex = -1;
  bool isEditing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('To-Do List'),
      ),
      backgroundColor: Colors.blue,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const SizedBox(height: 10),
            TextField(
              controller: todoController,
              decoration: const InputDecoration(
                hintText: 'To-Do Task',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    String title = todoController.text.trim();

                    if (title.isNotEmpty) {
                      if (isEditing) {
                        // Update existing todo
                        setState(() {
                          todos[selectedIndex].title = title;
                          todoController.text = '';
                          isEditing = false;
                          selectedIndex = -1;
                        });
                      } else {
                        // Add new todo
                        setState(() {
                          todoController.text = '';
                          todos.add(Todo(title: title));
                        });
                      }
                    }
                  },
                  child: Text(
                    isEditing ? 'Update Task' : 'Add Task',
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            todos.isEmpty
                ? const Text(
                    'No Tasks Yet..',
                    style: TextStyle(fontSize: 22),
                  )
                : Expanded(
                    child: ListView.builder(
                      itemCount: todos.length,
                      itemBuilder: (context, index) => getRow(index),
                    ),
                  )
          ],
        ),
      ),
    );
  }

  Widget getRow(int index) {
    return Card(
      child: ListTile(
        title: Text(
          todos[index].title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            decoration: todos[index].isCompleted
                ? TextDecoration.lineThrough
                : TextDecoration.none,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: () {
                setState(() {
                  todos[index].isCompleted = !todos[index].isCompleted;
                });
              },
              icon: Icon(
                todos[index].isCompleted
                    ? Icons.check_box
                    : Icons.check_box_outline_blank,
              ),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  todoController.text = todos[index].title;
                  isEditing = true;
                  selectedIndex = index;
                });
              },
              icon: const Icon(Icons.edit),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  todos.removeAt(index);
                });
              },
              icon: const Icon(Icons.delete),
            ),
          ],
        ),
      ),
    );
  }
}
