class Customer {
  final String name;
  final String joinDate;
  final double netSpend;
  final String imageUrl;
  final bool? hasBirthday;

  Customer(
      {required this.name,
      required this.joinDate,
      required this.netSpend,
      required this.imageUrl,
      this.hasBirthday});
}
