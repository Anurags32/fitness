import 'package:flutter/material.dart';

class SeatBookingScreen extends StatefulWidget {
  static const route = '/seat-booking';

  const SeatBookingScreen({super.key});

  @override
  State<SeatBookingScreen> createState() => _SeatBookingScreenState();
}

class _SeatBookingScreenState extends State<SeatBookingScreen> {
  Set<int> selectedSeats = {}; // Initially no seats selected
  Set<int> reservedSeats = {6, 7, 18, 22}; // Example reserved seats

  void _showBottomCard(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.35,
          minChildSize: 0.2,
          maxChildSize: 0.6,
          builder: (_, controller) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.only(bottom: 12),
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const Text(
                    "Cinema Max",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      _bottomInfo("08.04", "Date"),
                      _bottomInfo("21:55", "Hour"),
                      _bottomInfo(
                        selectedSeats.join(", "),
                        "Seats",
                      ), // Show seats
                      _bottomInfo("2,5", "Row"),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const Text(
                        "\$35,50",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF9C88FF),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: const Text(
                          "Buy",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _bottomInfo(String value, String label) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5DC), // Beige background
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildTitle(),
            _buildSeatsLayout(),
            _buildLegend(),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          const CircleAvatar(
            backgroundImage: NetworkImage(
              "https://images.pexels.com/photos/1239291/pexels-photo-1239291.jpeg",
            ),
            radius: 20,
          ),
          const SizedBox(width: 12),
          const Text(
            "Anurag",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const Spacer(),
          const Icon(Icons.search, size: 24, color: Colors.black87),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          const Icon(Icons.arrow_back, color: Colors.black87),
          const SizedBox(width: 16),
          const Text(
            "Choose Seats",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildSeatsLayout() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Expanded(child: _buildSeatGrid(0, 24)), // Left side
          // const SizedBox(width: 20),
          Expanded(child: _buildSeatGrid(24, 48)), // Right side
        ],
      ),
    );
  }

  Widget _buildSeatGrid(int start, int end) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: end - start,
      itemBuilder: (context, index) {
        int seat = start + index;
        return _buildSeat(seat);
      },
    );
  }

  Widget _buildSeat(int seat) {
    bool isSelected = selectedSeats.contains(seat);
    bool isReserved = reservedSeats.contains(seat);

    Color color;
    if (isSelected) {
      color = const Color(0xFF9C88FF); // Purple
    } else if (isReserved) {
      color = Colors.black; // Reserved
    } else {
      color = const Color(0xFFD3D3D3); // Available
    }

    return GestureDetector(
      onTap: () {
        if (!isReserved) {
          setState(() {
            if (isSelected) {
              selectedSeats.remove(seat);
            } else {
              selectedSeats.add(seat);
            }
          });
          _showBottomCard(context); // <-- Show bottom sheet on tap
        }
      },
      child: Container(
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
    );
  }

  Widget _buildLegend() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _legendDot(const Color(0xFF9C88FF), "Selected"),
          _legendDot(Colors.black, "Reserved"),
          _legendDot(const Color(0xFFD3D3D3), "Available"),
        ],
      ),
    );
  }

  Widget _legendDot(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
