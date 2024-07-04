class Customer {
  String name;

  Customer(this.name);

  void greet() {
    print('Welcome, $name!');
  }
}

class MenuItem {
  String name;
  double price;
  String category;

  MenuItem(this.name, this.price, this.category);

  @override
  String toString() {
    return '$name: \$${price.toStringAsFixed(2)} ($category)';
  }
}

class Order {
  String orderId;
  int tableNumber;
  List<MenuItem> items;
  bool isCompleted;

  Order(this.orderId, this.tableNumber)
      : items = [],
        isCompleted = false;

  void addItem(MenuItem item) {
    items.add(item);
  }

  void removeItem(MenuItem item) {
    items.remove(item);
  }

  void completeOrder() {
    isCompleted = true;
  }

  @override
  String toString() {
    String itemList = items.map((item) => item.name).join(', ');
    return 'Order $orderId (Table $tableNumber): $itemList - ${isCompleted ? 'Completed' : 'Not Completed'}';
  }
}

class Restaurant {
  List<MenuItem> menu;
  List<Order> orders;
  Map<int, String> tables; // เปลี่ยนจาก Map<int, bool> เป็น Map<int, String>

  Restaurant(int numberOfTables)
      : menu = [],
        orders = [],
        tables = Map.fromIterable(List.generate(numberOfTables, (i) => i + 1),
            value: (_) => 'Available');

  void cleanTable(int tableNumber) {
    if (tables.containsKey(tableNumber)) {
      tables[tableNumber] = 'Cleaning';
    } else {
      print("Table $tableNumber does not exist.");
    }
  }

  void markOutOfService(int tableNumber) {
    if (tables.containsKey(tableNumber)) {
      tables[tableNumber] = 'Out of Service';
    } else {
      print("Table $tableNumber does not exist.");
    }
  }

  void addMenuItem(MenuItem item) {
    menu.add(item);
  }

  void removeMenuItem(MenuItem item) {
    menu.remove(item);
  }

  void placeOrder(Order order) {
    bool allItemsExist = true;
    for (var item in order.items) {
      if (!menu.contains(item)) {
        print("The item '${item.name}' is not available in the menu.");
        allItemsExist = false;
      }
    }

    if (allItemsExist) {
      if (tables.containsKey(order.tableNumber)) {
        if (tables[order.tableNumber] == 'Available') {
          orders.add(order);
          tables[order.tableNumber] = 'Reserved';
        } else {
          print(
              "Table ${order.tableNumber} is already reserved or occupied. Cannot place order.");
        }
      } else {
        print("Table ${order.tableNumber} does not exist.");
      }
    } else {
      print(
          "Order from Table ${order.tableNumber} has rejected due to order items that not available in the menu, Please carefully read the menu before order.");
      for (var existingOrder in orders) {
        if (existingOrder.tableNumber == order.tableNumber &&
            !existingOrder.isCompleted) {
          existingOrder.isCompleted = true;
          break;
        }
      }
    }
  }

  void completeOrder(String orderId) {
    for (var order in orders) {
      if (order.orderId == orderId) {
        order.completeOrder();
        tables[order.tableNumber] = 'Occupied';
        break;
      }
    }
  }

  MenuItem? getMenuItem(String name) {
    var item = menu.firstWhere((item) => item.name == name, orElse: null);
    return item;
  }

  Order? getOrder(String orderId) {
    return orders.firstWhere((order) => order.orderId == orderId, orElse: null);
  }

  void displayMenu() {
    print("menu:");
    for (int i = 0; i < menu.length; i++) {
      print("${i + 1}. ${menu[i]}");
    }
  }

  MenuItem? selectMenuItem(int index) {
    if (index < 1 || index > menu.length) {
      print("Invalid selection.");
      return null;
    }
    return menu[index - 1];
  }
}

void main() {
  var customer = Customer('Customer');
  customer.greet();
  MenuItem item1 = MenuItem("Pad Thai", 3.25, "Meal");
  MenuItem item2 = MenuItem("Mango Sticky Rice", 4.00, "Dessert");
  MenuItem item3 = MenuItem("Thai Iced Tea", 2.72, "Drink");

  Restaurant restaurant = Restaurant(5);
  restaurant.addMenuItem(item1);
  restaurant.addMenuItem(item2);
  restaurant.addMenuItem(item3);

  MenuItem sandwich = MenuItem("Sandwich", 4.00, "Meal");
  restaurant.addMenuItem(sandwich);
  MenuItem hamburger = MenuItem("Hamburger", 5.00, "Meal");
  restaurant.addMenuItem(hamburger);
  MenuItem? padThai = restaurant.getMenuItem("Pad Thai");
  if (padThai != null) {
    padThai.price = 3.30;
    print("The price of Pad Thai has incresed from 3.25 to 3.30");
  }

  restaurant.removeMenuItem(sandwich);

  restaurant.displayMenu();
  print("Sandwich has been removed");

  Order order1 = Order("1", 1);
  order1.addItem(restaurant.selectMenuItem(1)!);
  order1.addItem(restaurant.selectMenuItem(1)!);
  order1.addItem(restaurant.selectMenuItem(3)!);
  order1.addItem(restaurant.selectMenuItem(2)!);
  print("Table 1 has added Pad Thai in Order");
  print("Table 1 has added Mango Sticky Rice in Order");
  order1.removeItem(restaurant.selectMenuItem(2)!);
  print("Table 1 has removed Mango Sticky Rice in Order");

  Order order2 = Order("2", 2);
  order2.addItem(restaurant.selectMenuItem(2)!);
  order2.addItem(MenuItem("Sushi", 5.50, "Meal"));
  Order order3 = Order("3", 3);
  order3.addItem(restaurant.selectMenuItem(1)!);
  order3.addItem(restaurant.selectMenuItem(2)!);
  restaurant.cleanTable(4);
  restaurant.markOutOfService(5);
  restaurant.placeOrder(order1);
  restaurant.placeOrder(order2);
  restaurant.placeOrder(order3);

  MenuItem? thaiIcedTea = restaurant.getMenuItem("Thai Iced Tea");
  if (thaiIcedTea != null) {
    print("The result is Found Menu Item: $thaiIcedTea");
  } else {
    print("Menu Item Thai Iced Tea not found.");
  }
  for (var item in order1.items.toList()) {
    if (item.name == "Mango Sticky Rice" "4.00" "Dessert") {
      order1.removeItem(item);
    }
  }
  print("\nTables that ordered Pad Thai and Mango Sticky Rice:");
  for (var order in restaurant.orders) {
    bool hasPadThai = false;
    bool hasMangoStickyRice = false;

    for (var item in order.items) {
      if (item.name == "Pad Thai") {
        hasPadThai = true;
      }
      if (item.name == "Mango Sticky Rice") {
        hasMangoStickyRice = true;
      }
    }

    if (hasPadThai && hasMangoStickyRice) {
      print("Table ${order.tableNumber}: ${order}");
    }
  }
  restaurant.completeOrder("1");
  restaurant.completeOrder("3");
  print("\nTables status:");
  for (var entry in restaurant.tables.entries) {
    print("table ${entry.key}: ${entry.value}");
  }

  print("\nOrders Status:");
  for (var order in restaurant.orders) {
    print(order);
  }
}
