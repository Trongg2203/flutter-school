import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class ExpenseTrackerScreen extends StatefulWidget {
  @override
  _ExpenseTrackerScreenState createState() => _ExpenseTrackerScreenState();
}

class _ExpenseTrackerScreenState extends State<ExpenseTrackerScreen> {
  int _selectedIndex = 0;

  // Sample data for the line chart
  final List<FlSpot> incomeSpots = [
    FlSpot(0, 300),
    FlSpot(1, 250),
    FlSpot(2, 320),
    FlSpot(3, 280),
    FlSpot(4, 500),
    FlSpot(5, 350),
    FlSpot(6, 400),
    FlSpot(7, 480),
    FlSpot(8, 450),
    FlSpot(9, 380),
    FlSpot(10, 400),
  ];

  final List<FlSpot> expenseSpots = [
    FlSpot(0, 200),
    FlSpot(1, 300),
    FlSpot(2, 250),
    FlSpot(3, 350),
    FlSpot(4, 300),
    FlSpot(5, 320),
    FlSpot(6, 280),
    FlSpot(7, 300),
    FlSpot(8, 350),
    FlSpot(9, 380),
    FlSpot(10, 400),
  ];

  // Sample transaction data
  final List<TransactionData> transactions = [
    TransactionData(
      date: DateTime(2022, 4, 22),
      items: [
        TransactionItem(
          name: "Chăm sóc thú cưng",
          amount: -500000,
          category: "pets",
          icon: Icons.pets,
          color: Colors.purple,
        ),
      ],
    ),
    TransactionData(
      date: DateTime(2022, 4, 25),
      items: [
        TransactionItem(
          name: "Chữa bệnh",
          amount: -500000,
          category: "health",
          icon: Icons.medical_services,
          color: Colors.yellow,
        ),
        TransactionItem(
          name: "Di chuyển",
          amount: -20000,
          category: "transport",
          icon: Icons.emoji_transportation,
          color: Colors.blue,
        ),
        TransactionItem(
          name: "Hóa đơn nước",
          amount: -300000,
          category: "utilities",
          icon: Icons.water,
          color: Colors.lightBlue,
        ),
      ],
    ),
    TransactionData(
      date: DateTime(2022, 4, 23),
      items: [
        TransactionItem(
          name: "Ăn uống",
          amount: -100000,
          category: "food",
          icon: Icons.restaurant,
          color: Colors.orange,
        ),
        TransactionItem(
          name: "Du lịch",
          amount: -5000000,
          category: "travel",
          icon: Icons.card_travel,
          color: Colors.yellow,
        ),
        TransactionItem(
          name: "Tiền lương",
          amount: 30000000,
          category: "income",
          icon: Icons.attach_money,
          color: Colors.green,
        ),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    // Sort transactions by date (newest first)
    transactions.sort((a, b) => b.date.compareTo(a.date));

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Profile header
            _buildHeader(),

            // Chart section
            _buildChartSection(),

            // Transactions list
            Expanded(
              child: ListView.builder(
                itemCount: transactions.length,
                itemBuilder: (context, index) {
                  return _buildTransactionGroup(transactions[index]);
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.teal,
            child: Icon(Icons.person, color: Colors.white),
          ),
          SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Hi', style: TextStyle(color: Colors.grey)),
              Text(
                'Minh Hoa',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChartSection() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      height: 220,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _buildLegendItem('Thu nhập', Colors.pink),
              SizedBox(width: 16),
              _buildLegendItem('Chi phí', Colors.green),
            ],
          ),
          SizedBox(height: 8),
          Expanded(
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 100,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: Colors.grey.withOpacity(0.3),
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 22,
                      getTitlesWidget: (value, meta) {
                        int index = value.toInt();
                        return Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Text(
                            'Tháng ${index + 1}',
                            style: TextStyle(color: Colors.grey, fontSize: 8),
                          ),
                        );
                      },
                      interval: 1,
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 28,
                      interval: 100,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),
                          style: TextStyle(color: Colors.grey, fontSize: 10),
                        );
                      },
                    ),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(show: false),
                minX: 0,
                maxX: 10,
                minY: 0,
                maxY: 600,
                lineTouchData: LineTouchData(
                  enabled: true,
                  touchTooltipData: LineTouchTooltipData(
                    tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
                  ),
                ),
                lineBarsData: [
                  // Income line (pink)
                  LineChartBarData(
                    spots: incomeSpots,
                    isCurved: true,
                    curveSmoothness: 0.3,
                    color: Colors.pink,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(show: false),
                    belowBarData: BarAreaData(show: false),
                  ),
                  // Expense line (green)
                  LineChartBarData(
                    spots: expenseSpots,
                    isCurved: true,
                    curveSmoothness: 0.3,
                    color: Colors.green,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(show: false),
                    belowBarData: BarAreaData(show: false),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String title, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        SizedBox(width: 4),
        Text(title, style: TextStyle(color: Colors.grey, fontSize: 12)),
      ],
    );
  }

  Widget _buildTransactionGroup(TransactionData data) {
    final dateFormatter = DateFormat('dd/MM/yyyy');
    final dayName = _getVietnameseDayName(data.date.weekday);
    String formattedDate = dateFormatter.format(data.date);

    return ExpansionTile(
      initiallyExpanded: true,
      title: Row(
        children: [
          Text(
            formattedDate,
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
          SizedBox(width: 8),
          Text(dayName, style: TextStyle(color: Colors.grey, fontSize: 14)),
        ],
      ),
      collapsedTextColor: Colors.white,
      textColor: Colors.white,
      iconColor: Colors.white,
      children: data.items.map((item) => _buildTransactionItem(item)).toList(),
    );
  }

  String _getVietnameseDayName(int weekday) {
    switch (weekday) {
      case DateTime.monday:
        return 'Thứ hai';
      case DateTime.tuesday:
        return 'Thứ ba';
      case DateTime.wednesday:
        return 'Thứ tư';
      case DateTime.thursday:
        return 'Thứ năm';
      case DateTime.friday:
        return 'Thứ sáu';
      case DateTime.saturday:
        return 'Thứ bảy';
      case DateTime.sunday:
        return 'Chủ nhật';
      default:
        return '';
    }
  }

  Widget _buildTransactionItem(TransactionItem item) {
    final numberFormat = NumberFormat.decimalPattern('vi_VN');
    final formattedAmount = numberFormat.format(item.amount.abs());
    final sign = item.amount >= 0 ? '+' : '-';

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.withOpacity(0.2), width: 0.5),
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: item.color.withOpacity(0.2),
            child: Icon(item.icon, color: item.color, size: 20),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.name, style: TextStyle(fontWeight: FontWeight.w500)),
                Text(
                  'Ví của tôi',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
          Text(
            '$sign$formattedAmount đ',
            style: TextStyle(
              color: item.amount >= 0 ? Colors.green : Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey, width: 0.5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(0, Icons.home, 'Trang chính'),
          _buildNavItem(1, Icons.wallet, 'Ví tiền'),
          _buildAddButton(),
          _buildNavItem(3, Icons.pie_chart, 'Thống kê'),
          _buildNavItem(4, Icons.settings, 'Cài đặt'),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = _selectedIndex == index;
    return InkWell(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: isSelected ? Colors.blue : Colors.grey, size: 24),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.blue : Colors.grey,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddButton() {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(color: Colors.blue, shape: BoxShape.circle),
      child: IconButton(
        icon: Icon(Icons.add, color: Colors.white),
        onPressed: () {
          // Add new transaction action
        },
      ),
    );
  }
}

class TransactionData {
  final DateTime date;
  final List<TransactionItem> items;

  TransactionData({required this.date, required this.items});
}

class TransactionItem {
  final String name;
  final int amount;
  final String category;
  final IconData icon;
  final Color color;

  TransactionItem({
    required this.name,
    required this.amount,
    required this.category,
    required this.icon,
    required this.color,
  });
}
