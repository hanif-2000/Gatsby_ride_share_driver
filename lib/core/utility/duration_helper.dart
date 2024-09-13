String formatDuration(int totalSeconds) {
  final duration = Duration(seconds: totalSeconds);

  // Calculate hours, minutes, and seconds
  final hours = duration.inHours;
  final minutes = duration.inMinutes.remainder(60);
  final seconds = duration.inSeconds.remainder(60);

  // Initialize the final string
  String formattedTime = '';

  // Conditionally add hours, minutes, and seconds to the final string
  if (hours > 0) {
    formattedTime += '${hours.toString().padLeft(2, '0')} hr';
  }

  if (minutes > 0) {
    if (formattedTime.isNotEmpty) {
      formattedTime += ':';
    }
    formattedTime += '${minutes.toString().padLeft(2, '0')} min';
  }

  if (seconds > 0) {
    if (formattedTime.isNotEmpty) {
      formattedTime += ':';
    }
    formattedTime += '${seconds.toString().padLeft(2, '0')} sec';
  }

  // If all components are 0, return "00 sec" to handle edge cases
  if (formattedTime.isEmpty) {
    formattedTime = '00 sec';
  }

  print(formattedTime);
  return formattedTime;
}

