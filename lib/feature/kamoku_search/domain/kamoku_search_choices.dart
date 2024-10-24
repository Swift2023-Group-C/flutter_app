enum KamokuSearchChoices {
  term(
    choice: ['前期', '後期', '通年'],
  ),
  grade(
    choice: ['1年', '2年', '3年', '4年'],
  ),
  course(
    choice: ['情報システム', '情報デザイン', '複雑', '知能', '高度ICT'],
    displayString: ['情シス', '情デザ', '複雑', '知能', '高度ICT'],
  ),
  classification(
    choice: ['必修', '選択'],
  ),
  education(
    choice: ['社会', '人間', '科学', '健康', 'コミュ'],
  ),
  masterField(
    choice: ['情報ア', '高度ICT', 'デザ', '複雑', '知能'],
  );

  const KamokuSearchChoices({required this.choice, this.displayString});
  final List<String> choice;
  final List<String>? displayString;
}
