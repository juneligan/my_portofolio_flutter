import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:storybook_flutter/storybook_flutter.dart';
import 'package:intl/intl.dart';

// use enum to avoid duplicate
enum DateRangeKey {
  story('story'),
  totalAnalytics('totalAnalytics'),
  shortAnalytics('shortAnalytics');

  final String _key;

  const DateRangeKey(this._key);

  String getKey() {
    return _key;
  }

  String getIndexedKey(String index) {
    return '${_key}_$index';
  }
}

// Enum for date range presets
enum DateRangePreset {
  custom,
  monthly,
  weekly,
  biWeekly,
  quarterly,
  semiAnnual,
  annual;
}

// Get first and last day of the current month
DateTime getFirstDayOfMonth() {
  final now = DateTime.now();
  return DateTime(now.year, now.month, 1);
}

DateTime getLastDayOfMonth() {
  final now = DateTime.now();
  return DateTime(now.year, now.month + 1, 0);
}

// Get start and end of the current week (Sunday - Saturday)
DateTime getStartOfWeek() {
  final now = DateTime.now();
  return now.subtract(Duration(days: now.weekday % 7));
}

DateTime getEndOfWeek() {
  return getStartOfWeek().add(Duration(days: 6));
}

// Get bi-weekly dates
DateTime getFirstBiWeeklyStart() => getFirstDayOfMonth();

DateTime getFirstBiWeeklyEnd() => getFirstDayOfMonth().add(Duration(days: 13));

DateTime getSecondBiWeeklyStart() =>
    getFirstBiWeeklyEnd().add(Duration(days: 1));

DateTime getSecondBiWeeklyEnd() => getLastDayOfMonth();

// Get quarterly dates
DateTime getStartOfQuarter() {
  final now = DateTime.now();
  int quarter = ((now.month - 1) ~/ 3) * 3 + 1;
  return DateTime(now.year, quarter, 1);
}

DateTime getEndOfQuarter() {
  final start = getStartOfQuarter();
  return DateTime(start.year, start.month + 3, 0);
}

// Get semi-annual dates
DateTime getFirstHalfStart() => DateTime(DateTime.now().year, 1, 1);

DateTime getFirstHalfEnd() => DateTime(DateTime.now().year, 6, 30);

DateTime getSecondHalfStart() => DateTime(DateTime.now().year, 7, 1);

DateTime getSecondHalfEnd() => DateTime(DateTime.now().year, 12, 31);

// Get annual range
DateTime getStartOfYear() => DateTime(DateTime.now().year, 1, 1);

DateTime getEndOfYear() => DateTime(DateTime.now().year, 12, 31);

// Riverpod providers

// Create a state class for managing date range
class DateRangeState {
  DateTime? startDate;
  DateTime? endDate;
  DateRangePreset? preset = DateRangePreset.annual;

  DateRangeState({this.startDate, this.endDate, this.preset});

  DateRangeState copyWith(
      {DateTime? startDate, DateTime? endDate, DateRangePreset? preset}) {
    return DateRangeState(
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      preset: preset ?? this.preset,
    );
  }
}

// Create a StateNotifier for handling date state per instance
class DateRangeNotifier extends StateNotifier<Map<String, DateRangeState>> {
  DateRangeNotifier() : super({});

  void setStartDate(String key, DateTime date, DateRangePreset preset) {
    if (state[key]?.startDate == date) return; // Avoid redundant state updates
    if (state[key]?.endDate == null ||
        date.isBefore(state[key]!.endDate!) ||
        date.isAtSameMomentAs(state[key]!.endDate!)) {
      state = {
        ...state,
        key: (state[key] ?? DateRangeState())
            .copyWith(startDate: date, preset: preset)
      };
    }
  }

  void setEndDate(String key, DateTime date, DateRangePreset preset) {
    if (state[key]?.endDate == date) return; // Avoid redundant state updates
    if (state[key]?.startDate == null ||
        date.isAfter(state[key]!.startDate!) ||
        date.isAtSameMomentAs(state[key]!.startDate!)) {
      state = {
        ...state,
        key: (state[key] ?? DateRangeState())
            .copyWith(endDate: date, preset: preset)
      };
    }
  }

  void setPresetDateTime(
      String key, DateTime start, DateTime end, DateRangePreset preset) {
    state = {
      ...state,
      key: state[key]
              ?.copyWith(startDate: start, endDate: end, preset: preset) ??
          DateRangeState(startDate: start, endDate: end, preset: preset)
    };
  }

  void setPresetType(String key, DateRangePreset preset) {
    state = {
      ...state,
      key:
          state[key]?.copyWith(preset: preset) ?? DateRangeState(preset: preset)
    };
  }

  DateRangeState? getState(String key) {
    return state[key];
  }
}

// Provider for generating unique DateRangeNotifier instances
final dateRangeProvider = StateNotifierProvider.autoDispose<DateRangeNotifier,
    Map<String, DateRangeState>>((ref) => DateRangeNotifier());

class AppDateRangeSelector extends ConsumerWidget {
  final String keyId; // Unique identifier for this instance
  const AppDateRangeSelector({required this.keyId, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dateState = ref.watch(
      dateRangeProvider.select((state) => state[keyId] ?? DateRangeState()),
    );
    final notifier = ref.read(dateRangeProvider.notifier);

    final selectedPreset = dateState.preset;
    final startDate = dateState.startDate;
    final endDate = dateState.endDate;

    void updateDateRange(DateRangePreset preset) {
      switch (preset) {
        case DateRangePreset.monthly:
          notifier.setPresetDateTime(
              keyId, getFirstDayOfMonth(), getLastDayOfMonth(), preset);
          break;
        case DateRangePreset.weekly:
          notifier.setPresetDateTime(
              keyId, getStartOfWeek(), getEndOfWeek(), preset);
          break;
        case DateRangePreset.biWeekly:
          notifier.setPresetDateTime(
              keyId, getFirstBiWeeklyStart(), getFirstBiWeeklyEnd(), preset);
          break;
        case DateRangePreset.quarterly:
          notifier.setPresetDateTime(
              keyId, getStartOfQuarter(), getEndOfQuarter(), preset);
          break;
        case DateRangePreset.semiAnnual:
          notifier.setPresetDateTime(
              keyId, getFirstHalfStart(), getFirstHalfEnd(), preset);
          break;
        case DateRangePreset.annual:
          notifier.setPresetDateTime(
              keyId, getStartOfYear(), getEndOfYear(), preset);
          break;
        case DateRangePreset.custom:
          notifier.setPresetType(keyId, preset);
          break;
      }
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        DropdownButton<DateRangePreset>(
          value: selectedPreset ?? DateRangePreset.weekly,
          onChanged: (preset) {
            if (preset != null) {
              updateDateRange(preset);
            }
          },
          items: [
            DropdownMenuItem(
                value: DateRangePreset.custom, child: Text('Custom')),
            DropdownMenuItem(
                value: DateRangePreset.monthly, child: Text('Monthly')),
            DropdownMenuItem(
                value: DateRangePreset.weekly, child: Text('Weekly')),
            DropdownMenuItem(
                value: DateRangePreset.biWeekly, child: Text('Bi-Weekly')),
            DropdownMenuItem(
                value: DateRangePreset.quarterly, child: Text('Quarterly')),
            DropdownMenuItem(
                value: DateRangePreset.semiAnnual, child: Text('Semi-Annual')),
            DropdownMenuItem(
                value: DateRangePreset.annual, child: Text('Annual')),
          ],
        ),
        SizedBox(width: 16),
        _buildDateSelector(
          context,
          'Start Date',
          dateState.startDate,
          (date) {
            if (endDate == null ||
                date.isBefore(endDate) ||
                date.isAtSameMomentAs(endDate)) {
              notifier.setStartDate(keyId, date, DateRangePreset.custom);
            }
          },
          firstDate: DateTime(2000),
          lastDate: endDate ?? DateTime(2101),
        ),
        SizedBox(width: 16),
        _buildDateSelector(
          context,
          'End Date',
          endDate,
          (date) {
            if (startDate == null ||
                date.isAfter(startDate) ||
                date.isAtSameMomentAs(startDate)) {
              notifier.setEndDate(keyId, date, DateRangePreset.custom);
            }
          },
          firstDate: startDate ?? DateTime(2000),
          lastDate: DateTime(2101),
        ),
      ],
    );
  }

  Widget _buildDateSelector(
    BuildContext context,
    String label,
    DateTime? selectedDate,
    Function(DateTime) onDateSelected, {
    required DateTime firstDate,
    required DateTime lastDate,
  }) {
    return GestureDetector(
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: selectedDate ?? DateTime.now(),
          firstDate: firstDate,
          lastDate: lastDate,
        );
        if (pickedDate != null) {
          onDateSelected(pickedDate);
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(selectedDate == null
            ? label
            : DateFormat('yyyy-MM-dd').format(selectedDate)),
      ),
    );
  }


}

final dateRangeStories = [
  Story(
    name: 'DateRangeSelector',
    builder: (context) => Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AppDateRangeSelector(keyId: 'story_id1'),
      ],
    ),
  ),
];
