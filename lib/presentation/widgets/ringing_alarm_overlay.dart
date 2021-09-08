import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:location_alarm/shared/providers.dart';

class RingingAlarmOverlay extends ConsumerWidget {
  final bool isRinging;
  const RingingAlarmOverlay({
    Key? key,
    required this.isRinging,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IgnorePointer(
      ignoring: !isRinging,
      child: GestureDetector(
        onDoubleTap: () => ref.read(alarmListNotifierProvider.notifier).turnOffAlarm(), 
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          color: isRinging ? Colors.black.withOpacity(0.8) : Colors.transparent,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Visibility(
            visible: isRinging,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.alarm),
                const SizedBox(height: 8),
                Text(
                  'Double tap to off alarm',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
