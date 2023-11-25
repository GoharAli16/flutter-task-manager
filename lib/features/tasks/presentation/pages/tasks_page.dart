import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TasksPage extends ConsumerStatefulWidget {
  const TasksPage({super.key});

  @override
  ConsumerState<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends ConsumerState<TasksPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedFilter = 'All';
  String _selectedSort = 'Due Date';

  final List<Map<String, dynamic>> _tasks = [
    {
      'id': '1',
      'title': 'Complete project proposal',
      'description': 'Write and submit the project proposal for the new mobile app',
      'priority': 'High',
      'status': 'In Progress',
      'dueDate': '2024-01-20',
      'createdAt': '2024-01-15',
      'category': 'Work',
      'tags': ['work', 'proposal', 'deadline'],
      'isCompleted': false,
      'assignee': 'John Doe',
      'project': 'Mobile App',
    },
    {
      'id': '2',
      'title': 'Buy groceries',
      'description': 'Milk, bread, eggs, vegetables, and fruits',
      'priority': 'Medium',
      'status': 'Pending',
      'dueDate': '2024-01-18',
      'createdAt': '2024-01-16',
      'category': 'Personal',
      'tags': ['shopping', 'personal'],
      'isCompleted': false,
      'assignee': 'Me',
      'project': 'Personal',
    },
    {
      'id': '3',
      'title': 'Review code changes',
      'description': 'Review and approve the latest code changes from the team',
      'priority': 'High',
      'status': 'Pending',
      'dueDate': '2024-01-17',
      'createdAt': '2024-01-16',
      'category': 'Work',
      'tags': ['work', 'code', 'review'],
      'isCompleted': false,
      'assignee': 'Me',
      'project': 'Mobile App',
    },
    {
      'id': '4',
      'title': 'Call dentist',
      'description': 'Schedule appointment for dental checkup',
      'priority': 'Low',
      'status': 'Completed',
      'dueDate': '2024-01-15',
      'createdAt': '2024-01-14',
      'category': 'Health',
      'tags': ['health', 'appointment'],
      'isCompleted': true,
      'assignee': 'Me',
      'project': 'Personal',
    },
  ];

  final List<String> _filters = ['All', 'Pending', 'In Progress', 'Completed', 'Overdue'];
  final List<String> _sorts = ['Due Date', 'Priority', 'Created Date', 'Title'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: _openSearch,
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterOptions,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'Today'),
            Tab(text: 'This Week'),
            Tab(text: 'Completed'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildTasksList(_getFilteredTasks()),
          _buildTasksList(_getTodayTasks()),
          _buildTasksList(_getThisWeekTasks()),
          _buildTasksList(_getCompletedTasks()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createTask,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildTasksList(List<Map<String, dynamic>> tasks) {
    if (tasks.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return _buildTaskItem(task);
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.task_alt,
            size: 100,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 24),
          Text(
            'No tasks found',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Create your first task to get started',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _createTask,
            icon: const Icon(Icons.add),
            label: const Text('Create Task'),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskItem(Map<String, dynamic> task) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _openTask(task),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  // Checkbox
                  Checkbox(
                    value: task['isCompleted'],
                    onChanged: (value) => _toggleTaskCompletion(task),
                  ),
                  
                  // Title
                  Expanded(
                    child: Text(
                      task['title'],
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        decoration: task['isCompleted'] 
                            ? TextDecoration.lineThrough 
                            : TextDecoration.none,
                        color: task['isCompleted'] 
                            ? Colors.grey[600] 
                            : null,
                      ),
                    ),
                  ),
                  
                  // Priority
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getPriorityColor(task['priority']).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      task['priority'],
                      style: TextStyle(
                        color: _getPriorityColor(task['priority']),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              
              // Description
              if (task['description'].isNotEmpty)
                Text(
                  task['description'],
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              const SizedBox(height: 12),
              
              // Footer
              Row(
                children: [
                  // Category
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getCategoryColor(task['category']).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      task['category'],
                      style: TextStyle(
                        color: _getCategoryColor(task['category']),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  
                  // Due Date
                  Icon(
                    Icons.schedule,
                    size: 16,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _formatDate(task['dueDate']),
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                  
                  const Spacer(),
                  
                  // Status
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getStatusColor(task['status']).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      task['status'],
                      style: TextStyle(
                        color: _getStatusColor(task['status']),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'High':
        return Colors.red;
      case 'Medium':
        return Colors.orange;
      case 'Low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Work':
        return Colors.blue;
      case 'Personal':
        return Colors.green;
      case 'Health':
        return Colors.red;
      case 'Shopping':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Completed':
        return Colors.green;
      case 'In Progress':
        return Colors.blue;
      case 'Pending':
        return Colors.orange;
      case 'Overdue':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _formatDate(String dateString) {
    final date = DateTime.parse(dateString);
    final now = DateTime.now();
    final difference = date.difference(now);
    
    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Tomorrow';
    } else if (difference.inDays == -1) {
      return 'Yesterday';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} days left';
    } else {
      return '${(-difference.inDays)} days overdue';
    }
  }

  List<Map<String, dynamic>> _getFilteredTasks() {
    var filtered = _tasks.where((task) {
      if (_selectedFilter != 'All' && task['status'] != _selectedFilter) {
        return false;
      }
      return true;
    }).toList();
    
    // Sort by selected criteria
    filtered.sort((a, b) {
      switch (_selectedSort) {
        case 'Due Date':
          return DateTime.parse(a['dueDate']).compareTo(DateTime.parse(b['dueDate']));
        case 'Priority':
          final priorityOrder = {'High': 3, 'Medium': 2, 'Low': 1};
          return priorityOrder[b['priority']]!.compareTo(priorityOrder[a['priority']]!);
        case 'Created Date':
          return DateTime.parse(b['createdAt']).compareTo(DateTime.parse(a['createdAt']));
        case 'Title':
          return a['title'].compareTo(b['title']);
        default:
          return 0;
      }
    });
    
    return filtered;
  }

  List<Map<String, dynamic>> _getTodayTasks() {
    final today = DateTime.now();
    return _tasks.where((task) {
      final dueDate = DateTime.parse(task['dueDate']);
      return dueDate.year == today.year && 
             dueDate.month == today.month && 
             dueDate.day == today.day;
    }).toList();
  }

  List<Map<String, dynamic>> _getThisWeekTasks() {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));
    
    return _tasks.where((task) {
      final dueDate = DateTime.parse(task['dueDate']);
      return dueDate.isAfter(startOfWeek.subtract(const Duration(days: 1))) &&
             dueDate.isBefore(endOfWeek.add(const Duration(days: 1)));
    }).toList();
  }

  List<Map<String, dynamic>> _getCompletedTasks() {
    return _tasks.where((task) => task['isCompleted'] == true).toList();
  }

  void _openSearch() {
    showSearch(
      context: context,
      delegate: TaskSearchDelegate(_tasks),
    );
  }

  void _showFilterOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Filter & Sort',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              title: const Text('Filter By'),
              trailing: DropdownButton<String>(
                value: _selectedFilter,
                items: _filters.map((filter) {
                  return DropdownMenuItem(
                    value: filter,
                    child: Text(filter),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedFilter = value!;
                  });
                  Navigator.pop(context);
                },
              ),
            ),
            ListTile(
              title: const Text('Sort By'),
              trailing: DropdownButton<String>(
                value: _selectedSort,
                items: _sorts.map((sort) {
                  return DropdownMenuItem(
                    value: sort,
                    child: Text(sort),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedSort = value!;
                  });
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _createTask() {
    // Implement task creation
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Creating new task...')),
    );
  }

  void _openTask(Map<String, dynamic> task) {
    // Implement task opening
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Opening ${task['title']}...')),
    );
  }

  void _toggleTaskCompletion(Map<String, dynamic> task) {
    setState(() {
      task['isCompleted'] = !task['isCompleted'];
      task['status'] = task['isCompleted'] ? 'Completed' : 'Pending';
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          task['isCompleted'] 
              ? 'Task completed!' 
              : 'Task marked as pending'
        ),
      ),
    );
  }
}

class TaskSearchDelegate extends SearchDelegate {
  final List<Map<String, dynamic>> tasks;

  TaskSearchDelegate(this.tasks);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults();
  }

  Widget _buildSearchResults() {
    final results = tasks.where((task) {
      return task['title'].toLowerCase().contains(query.toLowerCase()) ||
             task['description'].toLowerCase().contains(query.toLowerCase()) ||
             task['category'].toLowerCase().contains(query.toLowerCase());
    }).toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final task = results[index];
        return ListTile(
          title: Text(task['title']),
          subtitle: Text(task['description']),
          trailing: Text(task['status']),
          onTap: () {
            close(context, task);
          },
        );
      },
    );
  }
}
