import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/budget.dart';
import '../models/expense_transaction.dart';

class ApiClient {
  ApiClient({
    String? baseUrl,
    String? userId,
    http.Client? client,
  })  : baseUrl = (baseUrl ??
                const String.fromEnvironment(
                  'API_BASE_URL',
                  defaultValue: 'http://127.0.0.1:8000',
                ))
            .replaceFirst(RegExp(r'\/$'), ''),
        userId = userId ??
            const String.fromEnvironment(
              'API_USER_ID',
              defaultValue: 'demo-user',
            ),
        _client = client ?? http.Client();

  final String baseUrl;
  final String userId;
  final http.Client _client;

  Future<List<ExpenseTransaction>> fetchTransactions() async {
    final response = await _client.get(
      Uri.parse('$baseUrl/api/v1/transactions'),
      headers: _headers(),
    );
    final body = _decodeResponse(response);
    return (body as List<dynamic>)
        .map(
            (item) => ExpenseTransaction.fromJson(item as Map<String, dynamic>))
        .toList(growable: false);
  }

  Future<List<CategoryBudget>> fetchBudgets() async {
    final response = await _client.get(
      Uri.parse('$baseUrl/api/v1/budgets'),
      headers: _headers(),
    );
    final body = _decodeResponse(response);
    return (body as List<dynamic>)
        .map((item) => CategoryBudget.fromJson(item as Map<String, dynamic>))
        .toList(growable: false);
  }

  Future<ExpenseTransaction> createTransaction(
    ExpenseTransaction transaction,
  ) async {
    final response = await _client.post(
      Uri.parse('$baseUrl/api/v1/transactions'),
      headers: _headers(),
      body: jsonEncode(transaction.toApiJson()),
    );
    final body = _decodeResponse(response);
    return ExpenseTransaction.fromJson(body as Map<String, dynamic>);
  }

  Future<void> deleteTransaction(String transactionId) async {
    final response = await _client.delete(
      Uri.parse('$baseUrl/api/v1/transactions/$transactionId'),
      headers: _headers(),
    );
    _decodeResponse(response);
  }

  Future<void> deleteAllTransactions() async {
    final response = await _client.delete(
      Uri.parse('$baseUrl/api/v1/transactions'),
      headers: _headers(),
    );
    _decodeResponse(response);
  }

  void dispose() {
    _client.close();
  }

  Map<String, String> _headers() {
    return {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'X-User-Id': userId,
    };
  }

  dynamic _decodeResponse(http.Response response) {
    dynamic body;
    try {
      body = response.body.isEmpty ? null : jsonDecode(response.body);
    } on FormatException {
      body = null;
    }

    if (response.statusCode < 200 || response.statusCode >= 300) {
      final detail = body is Map<String, dynamic> ? body['detail'] : null;
      throw ApiException(
        detail is String
            ? detail
            : 'Request failed with status ${response.statusCode}',
        response.statusCode,
      );
    }
    return body;
  }
}

class ApiException implements Exception {
  const ApiException(this.message, this.statusCode);

  final String message;
  final int statusCode;

  @override
  String toString() => message;
}
