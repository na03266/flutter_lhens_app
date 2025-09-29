import 'package:flutter/services.dart';

class TelFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldV,
    TextEditingValue newV,
  ) {
    final digits = newV.text.replaceAll(RegExp(r'\D'), '');

    String fmt(String d) {
      if (d.isEmpty) return '';

      // 휴대전화: 01x → 3-4-4
      if (RegExp(r'^01[0-9]').hasMatch(d)) {
        final a = d.substring(0, d.length.clamp(0, 3));
        if (d.length <= 3) return a;
        final b = d.substring(3, d.length.clamp(3, 7));
        if (d.length <= 7) return '$a-$b';
        final c = d.substring(7, d.length.clamp(7, 11));
        return '$a-$b-$c';
      }

      // 서울 지역번호: 02
      if (d.startsWith('02')) {
        final a = d.substring(0, 2);
        final rem = d.length - 2;
        if (rem <= 0) return a;

        if (rem <= 3) {
          // 02-xxx
          final b = d.substring(2);
          return '$a-$b';
        }
        if (rem <= 7) {
          // 02-xxx-xxxx (최대 9자리)
          final b = d.substring(2, 5);
          final c = d.substring(5, d.length.clamp(5, 9));
          return '$a-$b${c.isEmpty ? '' : '-$c'}';
        }
        // 02-xxxx-xxxx (10자리)
        final b = d.substring(2, 6);
        final c = d.substring(6, d.length.clamp(6, 10));
        return '$a-$b-$c';
      }

      // 그 외 지역번호(3자리)
      if (d.length <= 3) return d;
      final a = d.substring(0, 3);
      final rem = d.length - 3;

      if (rem <= 3) {
        // 3-3
        final b = d.substring(3);
        return '$a-$b';
      }
      if (rem <= 7) {
        // 3-3-xxxx (최대 10자리)
        final b = d.substring(3, 6);
        final c = d.substring(6, d.length.clamp(6, 10));
        return '$a-$b${c.isEmpty ? '' : '-$c'}';
      }
      // 3-4-4 (11자리)
      final b = d.substring(3, 7);
      final c = d.substring(7, d.length.clamp(7, 11));
      return '$a-$b-$c';
    }

    final formatted = fmt(digits);
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
