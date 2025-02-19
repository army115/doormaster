class GetMenu {
  final dynamic page;
  final String icon;
  final String iconType;
  final String name;
  final int rowId;
  final bool permission;

  GetMenu({
    required this.page,
    required this.icon,
    required this.iconType,
    required this.name,
    required this.rowId,
    required this.permission,
  });
  GetMenu copyWith({
    dynamic page,
    String? icon,
    String? iconType,
    String? name,
    int? rowId,
    bool? permission,
  }) {
    return GetMenu(
      page: page ?? this.page,
      icon: icon ?? this.icon,
      iconType: iconType ?? this.iconType,
      name: name ?? this.name,
      rowId: rowId ?? this.rowId,
      permission: permission ?? this.permission,
    );
  }

  factory GetMenu.fromJson(Map<String, dynamic> json) {
    return GetMenu(
      page: json['page'],
      icon: json['icon'],
      iconType: json['icon_type'],
      name: json['name'],
      rowId: json['row_id'],
      permission: json['permission'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'page': page,
      'icon': icon,
      'icon_type': iconType,
      'name': name,
      'row_id': rowId,
      'permission': permission,
    };
  }
}

List<GetMenu> parseGetMenuList(List<dynamic> jsonList) {
  return jsonList.map((json) => GetMenu.fromJson(json)).toList();
}
