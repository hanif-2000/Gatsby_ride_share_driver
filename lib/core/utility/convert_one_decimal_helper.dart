String convertToOneDecimal(String input) {
  try {
    // Parse the input string to a double
    double inputValue = double.parse(input);

    // Convert to a string with only one decimal place
    String result = inputValue.toStringAsFixed(1);

    // Simulate an asynchronous operation

    // Return the result
    return result;
  } catch (e) {
    // Handle parsing errors
    return 'Error: $e';
  }
}
