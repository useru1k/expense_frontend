String formatCurrency(double amount, {String symbol = '\$'}) {
  final fixed = amount.abs().toStringAsFixed(2);
  final parts = fixed.split('.');
  final whole = parts.first;
  final buffer = StringBuffer();
  for (var index = 0; index < whole.length; index++) {
    if (index > 0 && (whole.length - index) % 3 == 0) {
      buffer.write(',');
    }
    buffer.write(whole[index]);
  }
  final prefix = amount < 0 ? '-$symbol' : symbol;
  return '$prefix${buffer.toString()}.${parts.last}';
}

String formatCompactCurrency(double amount, {String symbol = '\$'}) {
  if (amount.abs() >= 1000) {
    return '$symbol${(amount / 1000).toStringAsFixed(1)}k';
  }
  return '$symbol${amount.toStringAsFixed(0)}';
}

String formatDate(DateTime date) {
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  return '${months[date.month - 1]} ${date.day}, ${date.year}';
}

String formatMonth(DateTime date) {
  const months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];
  return '${months[date.month - 1]} ${date.year}';
}
