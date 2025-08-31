import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To-Do',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: Colors.grey[100],
      ),
      home: const MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Task {
  final String label;
  bool isDone;

  Task({required this.label, this.isDone = false});
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Task> tasks = [];
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _addTask() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() {
      tasks.add(Task(label: text));
      _controller.clear();
    });
  }

  double get progress {
    if (tasks.isEmpty) return 0.0;
    return tasks.where((t) => t.isDone).length / tasks.length;
  }

  void _showChecked() {
    final checked = tasks.where((t) => t.isDone).map((t) => '• ${t.label}').toList();
    final content = checked.isEmpty ? 'Nenhuma tarefa concluída.' : checked.join('\n');
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Concluídas'),
        content: Text(content),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Fechar')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Minhas Tarefas')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Progress(value: progress),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      labelText: 'Nova tarefa',
                      hintText: 'Digite algo...',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _addTask(),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: _addTask,
                  icon: const Icon(Icons.add),
                  label: const Text('Adicionar'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: TaskList(
                tasks: tasks,
                onToggle: (task, v) => setState(() => task.isDone = v ?? false),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showChecked,
        icon: const Icon(Icons.checklist),
        label: const Text('Ver concluídas'),
      ),
    );
  }
}

class Progress extends StatelessWidget {
  final double value;

  const Progress({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Progresso:'),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: value.clamp(0.0, 1.0),
            color: Colors.deepPurple,
            backgroundColor: Colors.deepPurple.shade100,
          ),
          const SizedBox(height: 4),
          Text('${(value * 100).toStringAsFixed(0)}% concluído'),
        ],
      ),
    );
  }
}

class TaskList extends StatelessWidget {
  final List<Task> tasks;
  final void Function(Task, bool?) onToggle;

  const TaskList({super.key, required this.tasks, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final t = tasks[index];
        return TaskItem(
          label: t.label,
          value: t.isDone,
          onChanged: (v) => onToggle(t, v),
        );
      },
    );
  }
}

class TaskItem extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool?> onChanged;

  const TaskItem({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: Checkbox(
          value: value,
          onChanged: onChanged,
        ),
        title: Text(
          label,
          style: TextStyle(
            decoration: value ? TextDecoration.lineThrough : null,
            color: value ? Colors.grey : Colors.black,
          ),
        ),
        trailing: Icon(
          value ? Icons.check_circle : Icons.radio_button_unchecked,
          color: value ? Colors.green : Colors.grey,
        ),
        onTap: () => onChanged(!value),
      ),
    );
  }
}
