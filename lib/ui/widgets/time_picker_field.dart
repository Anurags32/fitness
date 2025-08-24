import 'package:flutter/material.dart';


class TimePickerField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String? Function(String?)? validator;
  final bool allowDurationSelection;
  final VoidCallback? onChanged;

  const TimePickerField({
    super.key,
    required this.controller,
    required this.label,
    this.validator,
    this.allowDurationSelection = true,
    this.onChanged,
  });

  @override
  State<TimePickerField> createState() => _TimePickerFieldState();
}

class _TimePickerFieldState extends State<TimePickerField> {
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  Duration? _duration;

  @override
  void initState() {
    super.initState();
    _parseExistingTime();
  }

  void _parseExistingTime() {
    final text = widget.controller.text;
    if (text.contains('-')) {
      final parts = text.split('-');
      if (parts.length == 2) {
        _startTime = _parseTimeString(parts[0].trim());
        _endTime = _parseTimeString(parts[1].trim());
        if (_startTime != null && _endTime != null) {
          _calculateDuration();
        }
      }
    }
  }

  TimeOfDay? _parseTimeString(String timeStr) {
    try {
      final parts = timeStr.split(':');
      if (parts.length == 2) {
        final hour = int.parse(parts[0]);
        final minute = int.parse(parts[1]);
        return TimeOfDay(hour: hour, minute: minute);
      }
    } catch (e) {
      // Invalid time format
    }
    return null;
  }

  void _calculateDuration() {
    if (_startTime != null && _endTime != null) {
      final startMinutes = _startTime!.hour * 60 + _startTime!.minute;
      final endMinutes = _endTime!.hour * 60 + _endTime!.minute;
      final durationMinutes = endMinutes - startMinutes;
      
      if (durationMinutes > 0) {
        _duration = Duration(minutes: durationMinutes);
      } else {
        // Handle next day scenario
        _duration = Duration(minutes: durationMinutes + 24 * 60);
      }
    }
  }

  String _formatTime(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    return '${minutes}m';
  }

  Future<void> _selectStartTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _startTime ?? TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            timePickerTheme: TimePickerThemeData(
              backgroundColor: Theme.of(context).colorScheme.surface,
              hourMinuteTextColor: Theme.of(context).colorScheme.primary,
              dayPeriodTextColor: Theme.of(context).colorScheme.primary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _startTime = picked;
        _updateControllerText();
        _calculateDuration();
      });
      widget.onChanged?.call();
    }
  }

  Future<void> _selectEndTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _endTime ?? 
          (_startTime != null 
              ? TimeOfDay(hour: _startTime!.hour + 1, minute: _startTime!.minute)
              : TimeOfDay.now()),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            timePickerTheme: TimePickerThemeData(
              backgroundColor: Theme.of(context).colorScheme.surface,
              hourMinuteTextColor: Theme.of(context).colorScheme.primary,
              dayPeriodTextColor: Theme.of(context).colorScheme.primary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _endTime = picked;
        _updateControllerText();
        _calculateDuration();
      });
      widget.onChanged?.call();
    }
  }

  void _updateControllerText() {
    if (_startTime != null && _endTime != null) {
      widget.controller.text = '${_formatTime(_startTime!)}-${_formatTime(_endTime!)}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: widget.controller,
          decoration: InputDecoration(
            labelText: widget.label,
            hintText: 'e.g. 14:00-15:00',
            suffixIcon: const Icon(Icons.access_time),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          validator: widget.validator,
          readOnly: true,
          onTap: _selectStartTime,
        ),
        if (widget.allowDurationSelection) ...[
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _selectStartTime,
                  icon: const Icon(Icons.schedule, size: 18),
                  label: Text(_startTime != null 
                      ? 'Start: ${_formatTime(_startTime!)}'
                      : 'Select Start Time'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _selectEndTime,
                  icon: const Icon(Icons.schedule_outlined, size: 18),
                  label: Text(_endTime != null 
                      ? 'End: ${_formatTime(_endTime!)}'
                      : 'Select End Time'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (_duration != null) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.timer,
                    size: 16,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Duration: ${_formatDuration(_duration!)}',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ],
    );
  }
}
