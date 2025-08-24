import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/plan.dart';
import '../../viewmodels/plan_view_model.dart';
import '../widgets/app_text_field.dart';
import '../widgets/enhanced_button.dart';
import '../widgets/loading_view.dart';
import '../widgets/time_picker_field.dart';

class PlanEditorScreen extends StatefulWidget {
  static const route = '/editor';
  const PlanEditorScreen({super.key});
  @override
  State<PlanEditorScreen> createState() => _PlanEditorScreenState();
}

class _PlanEditorScreenState extends State<PlanEditorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _level = TextEditingController();
  final _time = TextEditingController();
  final _room = TextEditingController();
  final _trainer = TextEditingController();
  final List<Plan> _buffer = [];

  final List<String> _fitnessLevels = ['Beginner', 'Intermediate', 'Advanced'];
  String? _selectedLevel;
  void _addToBuffer() {
    if (_formKey.currentState?.validate() ?? false) {
      _buffer.add(
        Plan(
          title: _title.text.trim(),
          level: _selectedLevel ?? _level.text.trim(),
          time: _time.text.trim(),
          room: _room.text.trim(),
          trainer: _trainer.text.trim(),
        ),
      );
      _title.clear();
      _level.clear();
      _time.clear();
      _room.clear();
      _trainer.clear();
      _selectedLevel = null;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<PlanViewModel>();
    return Scaffold(
      appBar: AppBar(title: const Text('Add / Update Plans')),
      body: vm.loading
          ? const LoadingView()
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    AppTextField(
                      controller: _title,
                      label: 'Title',
                      validator: (v) => v!.isEmpty ? 'Title required' : null,
                    ),
                    const SizedBox(height: 12),
                    _buildLevelDropdown(),
                    const SizedBox(height: 12),
                    TimePickerField(
                      controller: _time,
                      label: 'Time (e.g.14:00-15:00)',
                      validator: (v) => v!.isEmpty ? 'Time required' : null,
                    ),
                    const SizedBox(height: 12),
                    AppTextField(
                      controller: _room,
                      label: 'Room',
                      validator: (v) => v!.isEmpty ? 'Room required' : null,
                    ),
                    const SizedBox(height: 12),
                    AppTextField(
                      controller: _trainer,
                      label: 'Trainer',
                      validator: (v) => v!.isEmpty ? 'Trainer required' : null,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: _addToBuffer,
                            icon: const Icon(Icons.add),
                            label: const Text('Add to list'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    if (_buffer.isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'To be submitted (${_buffer.length})',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          ..._buffer.map(
                            (p) => ListTile(
                              leading: const Icon(Icons.fitness_center),
                              title: Text(p.title),
                              subtitle: Text('${p.level} • ${p.time}'),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete_outline),
                                onPressed: () {
                                  setState(() {
                                    _buffer.remove(p);
                                  });
                                },
                              ),
                            ),
                          ),
                          const Divider(height: 24),
                        ],
                      ),
                    EnhancedButton(
                      label: 'Submit to Server',
                      icon: Icons.cloud_upload,
                      isLoading: vm.loading,
                      onPressed: _buffer.isEmpty
                          ? null
                          : () async {
                              final msg = await vm.save(_buffer);
                              if (!context.mounted) return;
                              if (msg != null) {
                                ScaffoldMessenger.of(
                                  context,
                                ).showSnackBar(SnackBar(content: Text(msg)));

                                Navigator.pop(context);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Failed')),
                                );
                              }
                            },
                      width: double.infinity,
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildLevelDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedLevel,
      decoration: InputDecoration(
        labelText: 'Fitness Level',
        prefixIcon: const Icon(Icons.fitness_center),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      items: _fitnessLevels.map((String level) {
        IconData levelIcon;
        Color levelColor;

        switch (level) {
          case 'Beginner':
            levelIcon = Icons.sentiment_satisfied;
            levelColor = Colors.green;
            break;
          case 'Intermediate':
            levelIcon = Icons.sentiment_neutral;
            levelColor = Colors.orange;
            break;
          case 'Advanced':
            levelIcon = Icons.sentiment_very_satisfied;
            levelColor = Colors.red;
            break;
          default:
            levelIcon = Icons.fitness_center;
            levelColor = Colors.grey;
        }

        return DropdownMenuItem<String>(
          value: level,
          child: Row(
            children: [
              Icon(levelIcon, color: levelColor, size: 20),
              const SizedBox(width: 8),
              Text(level),
            ],
          ),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          _selectedLevel = newValue;
          _level.text = newValue ?? '';
        });
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select a fitness level';
        }
        return null;
      },
    );
  }
}
