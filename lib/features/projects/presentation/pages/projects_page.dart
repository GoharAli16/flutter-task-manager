import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProjectsPage extends ConsumerStatefulWidget {
  const ProjectsPage({super.key});

  @override
  ConsumerState<ProjectsPage> createState() => _ProjectsPageState();
}

class _ProjectsPageState extends ConsumerState<ProjectsPage> {
  final List<Map<String, dynamic>> _projects = [
    {
      'id': '1',
      'name': 'Mobile App Development',
      'description': 'Building a cross-platform mobile application',
      'status': 'In Progress',
      'progress': 65,
      'startDate': '2024-01-01',
      'endDate': '2024-03-31',
      'teamSize': 5,
      'tasksCompleted': 32,
      'totalTasks': 50,
      'color': Colors.blue,
      'isFavorite': true,
    },
    {
      'id': '2',
      'name': 'Website Redesign',
      'description': 'Complete redesign of the company website',
      'status': 'Planning',
      'progress': 25,
      'startDate': '2024-02-01',
      'endDate': '2024-04-30',
      'teamSize': 3,
      'tasksCompleted': 8,
      'totalTasks': 30,
      'color': Colors.green,
      'isFavorite': false,
    },
    {
      'id': '3',
      'name': 'Data Migration',
      'description': 'Migrating data to new database system',
      'status': 'Completed',
      'progress': 100,
      'startDate': '2023-12-01',
      'endDate': '2024-01-15',
      'teamSize': 2,
      'tasksCompleted': 15,
      'totalTasks': 15,
      'color': Colors.purple,
      'isFavorite': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Projects'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: _openSearch,
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: _showMoreOptions,
          ),
        ],
      ),
      body: _projects.isEmpty ? _buildEmptyState() : _buildProjectsList(),
      floatingActionButton: FloatingActionButton(
        onPressed: _createProject,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.folder_outlined,
            size: 100,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 24),
          Text(
            'No projects yet',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Create your first project to get started',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _createProject,
            icon: const Icon(Icons.add),
            label: const Text('Create Project'),
          ),
        ],
      ),
    );
  }

  Widget _buildProjectsList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _projects.length,
      itemBuilder: (context, index) {
        final project = _projects[index];
        return _buildProjectCard(project);
      },
    );
  }

  Widget _buildProjectCard(Map<String, dynamic> project) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () => _openProject(project),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  // Project Icon
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: project['color'].withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.folder,
                      color: project['color'],
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  
                  // Project Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              project['name'],
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (project['isFavorite'])
                              const Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: 20,
                              ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          project['description'],
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Status
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getStatusColor(project['status']).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      project['status'],
                      style: TextStyle(
                        color: _getStatusColor(project['status']),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              // Progress Bar
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Progress',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        '${project['progress']}%',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: project['progress'] / 100,
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation<Color>(project['color']),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              // Stats
              Row(
                children: [
                  _buildStatItem(
                    icon: Icons.people,
                    label: 'Team',
                    value: '${project['teamSize']}',
                  ),
                  const SizedBox(width: 24),
                  _buildStatItem(
                    icon: Icons.task_alt,
                    label: 'Tasks',
                    value: '${project['tasksCompleted']}/${project['totalTasks']}',
                  ),
                  const SizedBox(width: 24),
                  _buildStatItem(
                    icon: Icons.schedule,
                    label: 'Due',
                    value: _formatDate(project['endDate']),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 4),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Completed':
        return Colors.green;
      case 'In Progress':
        return Colors.blue;
      case 'Planning':
        return Colors.orange;
      case 'On Hold':
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
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d left';
    } else {
      return '${(-difference.inDays)}d overdue';
    }
  }

  void _openSearch() {
    // Implement search functionality
  }

  void _showMoreOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.view_list),
              title: const Text('View All Projects'),
              onTap: _viewAllProjects,
            ),
            ListTile(
              leading: const Icon(Icons.archive),
              title: const Text('Archived Projects'),
              onTap: _viewArchivedProjects,
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Project Settings'),
              onTap: _openProjectSettings,
            ),
          ],
        ),
      ),
    );
  }

  void _createProject() {
    // Implement project creation
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Creating new project...')),
    );
  }

  void _openProject(Map<String, dynamic> project) {
    // Implement project opening
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Opening ${project['name']}...')),
    );
  }

  void _viewAllProjects() {
    Navigator.pop(context);
    // Implement view all projects
  }

  void _viewArchivedProjects() {
    Navigator.pop(context);
    // Implement view archived projects
  }

  void _openProjectSettings() {
    Navigator.pop(context);
    // Implement project settings
  }
}
