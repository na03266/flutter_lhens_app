String insertWrapHints(String s, {int chunk = 8, int threshold = 16}) {
  if (s.isEmpty) return s;
  final re = RegExp(
    r'([^\s]{'
            r'16'
            r',})'
        .replaceFirst('16', '$threshold'),
    unicode: true,
  );
  return s.splitMapJoin(
    re,
    onMatch: (m) {
      final t = m.group(0)!;
      final sb = StringBuffer();
      for (int i = 0; i < t.length; i++) {
        sb.write(t[i]);
        if ((i + 1) % chunk == 0) sb.write('\u200B');
      }
      return sb.toString();
    },
    onNonMatch: (n) => n,
  );
}
