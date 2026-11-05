
import 'package:flutter/material.dart';

void main() => runApp(const WellnessPlannerApp());

const Color bg = Color(0xFF101610);
const Color panel = Color(0xFF1A211A);
const Color panel2 = Color(0xFF293229);
const Color green = Color(0xFF9FD49B);
const Color greenDark = Color(0xFF214F28);
const Color textMain = Color(0xFFE2E6DE);
const Color muted = Color(0xFF92998F);
const Color border = Color(0xFF697267);

class WellnessPlannerApp extends StatelessWidget {
  const WellnessPlannerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Wellness Planner',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: bg,
        colorScheme: const ColorScheme.dark(
          primary: green,
          surface: panel,
          onSurface: textMain,
        ),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const AppShell(),
    );
  }
}

class AppShell extends StatefulWidget {
  const AppShell({super.key});
  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int tab = 0;
  int age = 17;
  double height = 160;
  double weight = 60;
  String gender = 'Male';
  String activity = 'Lightly Active';
  String goal = 'Maintain';
  final List<FoodEntry> loggedFoods = [];

  void addFood(FoodItem food) {
    setState(() => loggedFoods.add(FoodEntry(food, DateTime.now())));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${food.name} added to your food log')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      CalculatorScreen(
        age: age, height: height, weight: weight, gender: gender,
        activity: activity, goal: goal,
        onAge: (v) => setState(() => age = v),
        onHeight: (v) => setState(() => height = v),
        onWeight: (v) => setState(() => weight = v),
        onGender: (v) => setState(() => gender = v),
        onActivity: (v) => setState(() => activity = v),
        onGoal: (v) => setState(() => goal = v),
        onResults: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => ResultsScreen(
            age: age, height: height, weight: weight,
            gender: gender, activity: activity,
          ),
        )),
      ),
      FoodLogScreen(entries: loggedFoods, onRemove: (i) {
        setState(() => loggedFoods.removeAt(i));
      }),
      SelectFoodScreen(onAdd: addFood),
      SuggestionsScreen(onAdd: addFood),
      ExerciseScreen(weight: weight),
    ];

    return Scaffold(
      body: SafeArea(child: IndexedStack(index: tab, children: pages)),
      bottomNavigationBar: NavigationBar(
        backgroundColor: panel,
        indicatorColor: const Color(0xFF3B503B),
        selectedIndex: tab,
        onDestinationSelected: (v) => setState(() => tab = v),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.calculate_outlined), selectedIcon: Icon(Icons.calculate), label: 'Calculator'),
          NavigationDestination(icon: Icon(Icons.restaurant_outlined), selectedIcon: Icon(Icons.restaurant), label: 'Food Log'),
          NavigationDestination(icon: Icon(Icons.search), label: 'Select Food'),
          NavigationDestination(icon: Icon(Icons.lightbulb_outline), selectedIcon: Icon(Icons.lightbulb), label: 'Suggestions'),
          NavigationDestination(icon: Icon(Icons.fitness_center), label: 'Exercise'),
        ],
      ),
    );
  }
}

class CalculatorScreen extends StatelessWidget {
  final int age;
  final double height, weight;
  final String gender, activity, goal;
  final ValueChanged<int> onAge;
  final ValueChanged<double> onHeight, onWeight;
  final ValueChanged<String> onGender, onActivity, onGoal;
  final VoidCallback onResults;

  const CalculatorScreen({
    super.key, required this.age, required this.height, required this.weight,
    required this.gender, required this.activity, required this.goal,
    required this.onAge, required this.onHeight, required this.onWeight,
    required this.onGender, required this.onActivity, required this.onGoal,
    required this.onResults,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(padding: const EdgeInsets.fromLTRB(22, 18, 22, 24), children: [
      const Center(child: Text('Wellness Planner', style: TextStyle(fontSize: 27, fontWeight: FontWeight.w500))),
      const SizedBox(height: 24),
      const Text('Build healthy daily habits', style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600)),
      const SizedBox(height: 24),
      const SectionLabel('Gender'),
      SegmentedButton<String>(
        segments: const [
          ButtonSegment(value: 'Male', label: Text('Male'), icon: Icon(Icons.male)),
          ButtonSegment(value: 'Female', label: Text('Female'), icon: Icon(Icons.female)),
        ],
        selected: {gender}, onSelectionChanged: (s) => onGender(s.first),
      ),
      const SizedBox(height: 20),
      NumberField(label: 'Age', value: '$age', suffix: 'years',
        onChanged: (v) { final n = int.tryParse(v); if (n != null && n > 0 && n < 120) onAge(n); }),
      NumberField(label: 'Height', value: height.toStringAsFixed(0), suffix: 'cm',
        onChanged: (v) { final n = double.tryParse(v); if (n != null && n > 0) onHeight(n); }),
      NumberField(label: 'Weight', value: weight.toStringAsFixed(1), suffix: 'kg',
        onChanged: (v) { final n = double.tryParse(v); if (n != null && n > 0) onWeight(n); }),
      const SizedBox(height: 16),
      const SectionLabel('Activity Level'),
      ...[
        ('Sedentary', 'Mostly sitting; little planned activity'),
        ('Lightly Active', 'Light movement and regular daily activities'),
        ('Moderately Active', 'A mix of movement and recreational activity'),
        ('Very Active', 'Frequent sports or physically active days'),
      ].map((e) => SelectTile(title: e.$1, subtitle: e.$2,
        selected: activity == e.$1, onTap: () => onActivity(e.$1))),
      const SizedBox(height: 18),
      const SectionLabel('Wellness focus'),
      Wrap(spacing: 8, children: ['Maintain', 'Build strength', 'More energy'].map((g) =>
        ChoiceChip(label: Text(g), selected: goal == g, onSelected: (_) => onGoal(g))).toList()),
      const SizedBox(height: 20),
      const InfoCard(
        icon: Icons.health_and_safety_outlined,
        title: 'A note about your results',
        body: 'This app is for general habit tracking, not dieting or setting calorie limits. If you are under 18, growth and nutrition needs are individual—ask a qualified health professional for personal guidance.',
      ),
      const SizedBox(height: 20),
      FilledButton.icon(onPressed: onResults, icon: const Icon(Icons.insights), label: const Text('VIEW WELLNESS SUMMARY')),
    ]);
  }
}

class ResultsScreen extends StatelessWidget {
  final int age;
  final double height, weight;
  final String gender, activity;
  const ResultsScreen({super.key, required this.age, required this.height,
    required this.weight, required this.gender, required this.activity});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your Results'), backgroundColor: panel2),
      body: ListView(padding: const EdgeInsets.all(22), children: [
        const Text('Your wellness profile', textAlign: TextAlign.center,
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        Text('Based on the details entered • $activity',
          textAlign: TextAlign.center, style: const TextStyle(color: muted, fontSize: 16)),
        const SizedBox(height: 28),
        const InfoCard(icon: Icons.track_changes, title: 'Your daily focus',
          body: 'Aim for regular meals, enough rest, hydration and enjoyable movement. There is no single number that defines a healthy day.'),
        const SizedBox(height: 18),
        _resultCard('AGE', '$age years', Icons.cake_outlined, greenDark),
        _resultCard('HEIGHT', '${height.toStringAsFixed(0)} cm', Icons.height, panel2),
        _resultCard('WEIGHT', '${weight.toStringAsFixed(1)} kg', Icons.monitor_weight_outlined, panel2),
        const SizedBox(height: 18),
        const Text('Healthy habit ideas', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        const HabitRow(icon: Icons.restaurant, text: 'Eat a variety of foods across the day'),
        const HabitRow(icon: Icons.directions_walk, text: 'Choose movement that feels enjoyable'),
        const HabitRow(icon: Icons.bedtime, text: 'Keep a consistent sleep routine'),
        const HabitRow(icon: Icons.water_drop, text: 'Drink water regularly'),
      ]),
    );
  }

  Widget _resultCard(String label, String value, IconData icon, Color color) =>
    Container(margin: const EdgeInsets.only(bottom: 14), padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(24)),
      child: Column(children: [
        Icon(icon, color: green, size: 28),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(color: green, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text(value, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
      ]));
}

class SuggestionsScreen extends StatefulWidget {
  final ValueChanged<FoodItem> onAdd;
  const SuggestionsScreen({super.key, required this.onAdd});
  @override
  State<SuggestionsScreen> createState() => _SuggestionsScreenState();
}

class _SuggestionsScreenState extends State<SuggestionsScreen> {
  String meal = 'All';
  String goal = 'Maintain';
  @override
  Widget build(BuildContext context) {
    final filtered = foodItems.where((f) => meal == 'All' || f.meal == meal).toList();
    return ListView(padding: const EdgeInsets.all(22), children: [
      const Center(child: Text('Suggested Foods', style: TextStyle(fontSize: 27))),
      const SizedBox(height: 22),
      const InfoCard(icon: Icons.restaurant_menu, title: 'Balanced meal ideas',
        body: 'Choose meals that include a mix of grains, protein foods, fruits or vegetables, and satisfying fats. Portions and needs vary from person to person.'),
      const SizedBox(height: 24),
      const SectionLabel('Choose Your Focus'),
      Wrap(spacing: 8, children: ['Maintain', 'Build strength', 'More energy'].map((g) =>
        ChoiceChip(label: Text(g), selected: goal == g, onSelected: (_) => setState(() => goal = g))).toList()),
      const SizedBox(height: 18),
      SingleChildScrollView(scrollDirection: Axis.horizontal, child: Row(children:
        ['All', 'Breakfast', 'Lunch', 'Dinner', 'Snack'].map((m) => Padding(
          padding: const EdgeInsets.only(right: 8),
          child: ChoiceChip(label: Text(m), selected: meal == m, onSelected: (_) => setState(() => meal = m)),
        )).toList())),
      const SizedBox(height: 16),
      Text('Recommended Meals (${filtered.length})', style: const TextStyle(fontSize: 21, fontWeight: FontWeight.bold)),
      const SizedBox(height: 12),
      ...filtered.map((f) => FoodCard(food: f, onAdd: () => widget.onAdd(f))),
    ]);
  }
}

class SelectFoodScreen extends StatefulWidget {
  final ValueChanged<FoodItem> onAdd;
  const SelectFoodScreen({super.key, required this.onAdd});
  @override
  State<SelectFoodScreen> createState() => _SelectFoodScreenState();
}

class _SelectFoodScreenState extends State<SelectFoodScreen> {
  String query = '';
  @override
  Widget build(BuildContext context) {
    final items = foodItems.where((f) => f.name.toLowerCase().contains(query.toLowerCase())).toList();
    return ListView(padding: const EdgeInsets.all(22), children: [
      const Center(child: Text('Select Food', style: TextStyle(fontSize: 27))),
      const SizedBox(height: 22),
      TextField(decoration: const InputDecoration(prefixIcon: Icon(Icons.search), hintText: 'Search foods...'),
        onChanged: (v) => setState(() => query = v)),
      const SizedBox(height: 18),
      ...items.map((f) => FoodCard(food: f, onAdd: () => widget.onAdd(f))),
      if (items.isEmpty) const Text('No foods found.', style: TextStyle(color: muted)),
    ]);
  }
}

class FoodLogScreen extends StatelessWidget {
  final List<FoodEntry> entries;
  final ValueChanged<int> onRemove;
  const FoodLogScreen({super.key, required this.entries, required this.onRemove});
  @override
  Widget build(BuildContext context) {
    final groups = ['Breakfast', 'Lunch', 'Dinner', 'Snack'];
    return ListView(padding: const EdgeInsets.all(22), children: [
      const Center(child: Text('Food Log', style: TextStyle(fontSize: 27))),
      const SizedBox(height: 20),
      const InfoCard(icon: Icons.menu_book, title: 'Your food journal',
        body: 'Record meals and snacks to reflect on variety and regular eating patterns. This log does not score foods or set a calorie limit.'),
      const SizedBox(height: 20),
      ...groups.map((g) {
        final matches = entries.where((e) => e.food.meal == g).toList();
        return Card(color: panel, child: Padding(padding: const EdgeInsets.all(14), child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(g, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: green)),
            if (matches.isEmpty) const Padding(padding: EdgeInsets.symmetric(vertical: 12),
              child: Text('Nothing logged yet', style: TextStyle(color: muted))),
            ...matches.map((e) {
              final index = entries.indexOf(e);
              return ListTile(contentPadding: EdgeInsets.zero, title: Text(e.food.name),
                subtitle: Text(e.food.description),
                trailing: IconButton(icon: const Icon(Icons.close), onPressed: () => onRemove(index)));
            }),
          ],
        )));
      }),
    ]);
  }
}

class ExerciseScreen extends StatelessWidget {
  final double weight;
  const ExerciseScreen({super.key, required this.weight});
  @override
  Widget build(BuildContext context) {
    final activities = [
      ('Brisk Walking', 'A comfortable, purposeful walk outdoors or on a treadmill.', Icons.directions_walk, '20–30 min'),
      ('Cycling', 'Ride at a pace where you can still talk comfortably.', Icons.directions_bike, '20–30 min'),
      ('Dancing', 'Choose music you enjoy and move at your own pace.', Icons.music_note, '15–30 min'),
      ('Stretching', 'Gentle mobility and flexibility movements.', Icons.self_improvement, '5–15 min'),
      ('Swimming', 'Enjoy relaxed swimming if you have safe supervision.', Icons.pool, 'As comfortable'),
    ];
    return ListView(padding: const EdgeInsets.all(22), children: [
      const Center(child: Text('Exercise & Movement', style: TextStyle(fontSize: 27))),
      const SizedBox(height: 20),
      const InfoCard(icon: Icons.timer_outlined, title: 'Move in a way you enjoy',
        body: 'There is no need to exercise to burn a set number of calories. Start gently, take rest days, and stop if you feel unwell or in pain.'),
      const SizedBox(height: 20),
      const Text('Movement ideas', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
      const SizedBox(height: 12),
      ...activities.map((a) => Container(
        margin: const EdgeInsets.only(bottom: 14), padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(color: panel, borderRadius: BorderRadius.circular(22),
          border: Border.all(color: border)),
        child: Row(children: [
          CircleAvatar(radius: 28, backgroundColor: greenDark, child: Icon(a.$3, color: green, size: 28)),
          const SizedBox(width: 14),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(a.$1, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            Text(a.$2, style: const TextStyle(color: muted)),
            const SizedBox(height: 8),
            Text('Flexible guide: ${a.$4}', style: const TextStyle(color: green, fontWeight: FontWeight.w600)),
          ])),
        ]),
      )),
    ]);
  }
}

class FoodItem {
  final String name, meal, description, emoji;
  final List<String> ingredients;
  FoodItem(this.name, this.meal, this.description, this.emoji, this.ingredients);
}
class FoodEntry {
  final FoodItem food;
  final DateTime loggedAt;
  FoodEntry(this.food, this.loggedAt);
}

final List<FoodItem> foodItems = [
  FoodItem('Oatmeal & Greek Yogurt', 'Breakfast', 'Oats, yogurt and fresh fruit.', '🥣',
    ['Oatmeal with milk', 'Plain Greek yogurt', 'Fresh apple']),
  FoodItem('Idli with Sambar', 'Breakfast', 'Steamed idli with lentil and vegetable sambar.', '🍲',
    ['Idli', 'Sambar', 'Coconut chutney']),
  FoodItem('Vegetable Rice & Curd', 'Lunch', 'Rice with mixed vegetables and curd.', '🍚',
    ['Rice', 'Mixed vegetables', 'Curd']),
  FoodItem('Chapati & Channa', 'Lunch', 'Whole-wheat chapati with chickpea curry.', '🫓',
    ['Chapati', 'Channa masala', 'Cucumber']),
  FoodItem('Dosa & Sambar', 'Dinner', 'Crisp dosa with sambar and chutney.', '🥞',
    ['Dosa', 'Sambar', 'Chutney']),
  FoodItem('Fruit & Nuts', 'Snack', 'Seasonal fruit with a handful of nuts.', '🍎',
    ['Seasonal fruit', 'Mixed nuts']),
];

class FoodCard extends StatelessWidget {
  final FoodItem food;
  final VoidCallback onAdd;
  const FoodCard({super.key, required this.food, required this.onAdd});
  @override
  Widget build(BuildContext context) {
    return Container(margin: const EdgeInsets.only(bottom: 16), padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(color: panel, borderRadius: BorderRadius.circular(22),
        border: Border.all(color: border)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Text(food.emoji, style: const TextStyle(fontSize: 27)),
          const SizedBox(width: 10),
          Expanded(child: Text(food.meal, style: const TextStyle(color: green, fontWeight: FontWeight.bold))),
          const Icon(Icons.eco_outlined, color: green),
        ]),
        const SizedBox(height: 10),
        Text(food.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        Text(food.description, style: const TextStyle(color: muted)),
        const SizedBox(height: 12),
        Container(width: double.infinity, padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: const Color(0xFFF4F5F2), borderRadius: BorderRadius.circular(14)),
          child: Text('Includes: ${food.ingredients.join(' • ')}',
            style: const TextStyle(color: Color(0xFF267A70), fontWeight: FontWeight.w500))),
        const SizedBox(height: 12),
        SizedBox(width: double.infinity, child: FilledButton.icon(
          onPressed: onAdd, icon: const Icon(Icons.add_circle_outline), label: const Text('Add to Food Log'))),
      ]),
    );
  }
}

class NumberField extends StatelessWidget {
  final String label, value, suffix;
  final ValueChanged<String> onChanged;
  const NumberField({super.key, required this.label, required this.value,
    required this.suffix, required this.onChanged});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 12),
    child: TextFormField(initialValue: value, keyboardType: TextInputType.number,
      onChanged: onChanged,
      decoration: InputDecoration(labelText: label, suffixText: suffix,
        prefixIcon: Icon(label == 'Age' ? Icons.cake_outlined :
          label == 'Height' ? Icons.height : Icons.monitor_weight_outlined)),
    ));
  }
}

class SectionLabel extends StatelessWidget {
  final String text;
  const SectionLabel(this.text, {super.key});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Text(text, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w600)));
}

class SelectTile extends StatelessWidget {
  final String title, subtitle;
  final bool selected;
  final VoidCallback onTap;
  const SelectTile({super.key, required this.title, required this.subtitle,
    required this.selected, required this.onTap});
  @override
  Widget build(BuildContext context) => Card(
    color: selected ? greenDark : const Color(0xFF414941),
    child: ListTile(onTap: onTap, title: Text(title,
      style: TextStyle(fontWeight: FontWeight.bold, color: selected ? green : textMain)),
      subtitle: Text(subtitle, style: TextStyle(color: selected ? const Color(0xFFC0E2BD) : textMain.withOpacity(.75))),
      trailing: selected ? const Icon(Icons.check_circle, color: green) : null));
}

class InfoCard extends StatelessWidget {
  final IconData icon;
  final String title, body;
  const InfoCard({super.key, required this.icon, required this.title, required this.body});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(color: const Color(0xFF172A19),
      border: Border.all(color: const Color(0xFF315B35)), borderRadius: BorderRadius.circular(20)),
    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Icon(icon, color: green, size: 28),
      const SizedBox(width: 12),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: const TextStyle(color: green, fontWeight: FontWeight.bold, fontSize: 17)),
        const SizedBox(height: 7),
        Text(body, style: const TextStyle(color: textMain, height: 1.4)),
      ])),
    ]),
  );
}

class HabitRow extends StatelessWidget {
  final IconData icon;
  final String text;
  const HabitRow({super.key, required this.icon, required this.text});
  @override
  Widget build(BuildContext context) => ListTile(
    leading: Icon(icon, color: green), title: Text(text),
  );
}
