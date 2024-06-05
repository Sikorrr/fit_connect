import 'package:fit_connect/features/account/presentation/widgets/user_input.dart';
import 'package:flutter/material.dart';

class RangeSelector extends StatefulWidget {
  const RangeSelector({
    super.key,
    required this.title,
    required this.selectedMinValue,
    required this.selectedMaxValue,
    required this.sliderMin,
    required this.sliderMax,
    required this.onRangeSelected,
    this.isEditing = false,
  });

  final String title;
  final double selectedMinValue;
  final double selectedMaxValue;
  final double sliderMin;
  final double sliderMax;
  final bool isEditing;
  final Function(RangeValues) onRangeSelected;

  @override
  State<RangeSelector> createState() => _RangeSelectorState();
}

class _RangeSelectorState extends State<RangeSelector> {
  late RangeValues _currentRangeValues;

  @override
  void initState() {
    super.initState();
    _currentRangeValues =
        RangeValues(widget.selectedMinValue, widget.selectedMaxValue);
  }

  @override
  Widget build(BuildContext context) {
    return UserInput(
      title: widget.title,
      onPressed: () => widget.onRangeSelected(_currentRangeValues),
      isEditing: widget.isEditing,
      child: Column(
        children: [
          RangeSlider(
            min: widget.sliderMin,
            max: widget.sliderMax,
            divisions: (widget.sliderMax - widget.sliderMin).round(),
            values: _currentRangeValues,
            labels: RangeLabels(
              _currentRangeValues.start.round().toString(),
              _currentRangeValues.end.round().toString(),
            ),
            onChanged: (RangeValues values) {
              setState(() {
                _currentRangeValues = values;
              });
            },
          ),
          Text(
            'Selected Range: ${_currentRangeValues.start.round()} - ${_currentRangeValues.end.round()}',
            style: const TextStyle(fontSize: 16),
          )
        ],
      ),
    );
  }
}
