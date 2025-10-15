import 'package:flutter/material.dart';
import 'package:instakarm/features/home/data/repositories/task_repository.dart';
import 'package:instakarm/features/home/domain/models/task_category.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

// Combined model for the screen's data
class HomeData {
  final List<DailyTaskDisplay> dailyTasks;
  final List<TaskCategory> weeklyCategories;

  HomeData({required this.dailyTasks, required this.weeklyCategories});
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<HomeData> _homeDataFuture;
  final TaskRepository _taskRepository = TaskRepository();

  @override
  void initState() {
    super.initState();
    _homeDataFuture = _loadHomeData();
  }

  Future<HomeData> _loadHomeData() async {
    // Use Future.wait to fetch both data sets concurrently
    final results = await Future.wait([
      _taskRepository.getDailyTasks(),
      _taskRepository.getWeeklyCategoryProgress(),
    ]);
    return HomeData(
      dailyTasks: results[0] as List<DailyTaskDisplay>,
      weeklyCategories: results[1] as List<TaskCategory>,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Hallo, [Nutzer]!'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            colors: [
              const Color(0xFFFF8C42).withOpacity(0.2),
              const Color(0xFFFFE29F).withOpacity(0.2),
            ],
            center: Alignment.center,
            radius: 1.0,
          ),
        ),
        child: FutureBuilder<HomeData>(
          future: _homeDataFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Fehler: ${snapshot.error}'));
            } else if (!snapshot.hasData) {
              return const Center(child: Text('Keine Aufgaben gefunden.'));
            }

            final homeData = snapshot.data!;

            return CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.only(top: 120, left: 16, right: 16, bottom: 16),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        _buildDailyTaskSection(context, 'Tägliche Aufgaben', homeData.dailyTasks),
                        const SizedBox(height: 24),
                        _buildWeeklyTaskSection(context, 'Wöchentliche Aufgaben', homeData.weeklyCategories),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(icon: const Icon(Icons.home_outlined), onPressed: () {}),
            IconButton(icon: const Icon(Icons.bar_chart_outlined), onPressed: () {}),
            const SizedBox(width: 48),
            IconButton(icon: const Icon(Icons.store_outlined), onPressed: () {}),
            IconButton(icon: const Icon(Icons.person_outline), onPressed: () {}),
          ],
        ),
      ),
    );
  }

  Widget _buildDailyTaskSection(BuildContext context, String title, List<DailyTaskDisplay> tasks) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        SizedBox(
          height: 130,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: tasks.length,
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final dailyTask = tasks[index];
              return SizedBox(
                width: 160,
                child: Card(
                  color: dailyTask.categoryColor.withOpacity(0.9),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          dailyTask.task.name,
                          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 14),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const Spacer(),
                        Text(
                          dailyTask.categoryName,
                          style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildWeeklyTaskSection(BuildContext context, String title, List<TaskCategory> categories) {
    const totalWeeklyTasks = 7.0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        SizedBox(
          height: 130,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final category = categories[index];
              final progress = category.weeklyProgress / totalWeeklyTasks;
              return SizedBox(
                width: 160,
                child: Card(
                  color: category.color.withOpacity(0.9),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          category.name,
                          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18),
                        ),
                        const SizedBox(height: 16),
                        LinearProgressIndicator(
                          value: progress,
                          backgroundColor: Colors.white24,
                          valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${category.weeklyProgress}/${totalWeeklyTasks.toInt()} erledigt',
                          style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}