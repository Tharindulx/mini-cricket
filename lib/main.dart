import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const MiniCricketApp());
}

class MiniCricketApp extends StatelessWidget {
  const MiniCricketApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mini Cricket',
      theme: ThemeData(
        useMaterial3: false,
        fontFamily: 'Roboto',
        primarySwatch: Colors.blue,
      ),
      home: const CricketHomePage(),
    );
  }
}

class CricketHomePage extends StatefulWidget {
  const CricketHomePage({super.key});

  @override
  State<CricketHomePage> createState() => _CricketHomePageState();
}

class _CricketHomePageState extends State<CricketHomePage> {
  final Random _random = Random();

  int runs = 0;
  int balls = 6;
  int lastRuns = 0;

  void playBall() {
    if (balls == 0) return;

    final score = _random.nextInt(7); // 0 to 6

    setState(() {
      runs += score;
      lastRuns = score;
      balls--;
    });
  }

  void restartGame() {
    setState(() {
      runs = 0;
      balls = 6;
      lastRuns = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool gameOver = balls == 0;

    return Scaffold(
      backgroundColor: const Color(0xFF0B80D8),
      appBar: AppBar(
        title: const Text(
          'Mini Cricket',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF075A9D),
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 74),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _ScoreCard(
                  type: ScoreCardType.bat,
                  label: 'Runs',
                  value: runs,
                ),
                const SizedBox(width: 16),
                _ScoreCard(
                  type: ScoreCardType.ball,
                  label: 'Balls',
                  value: balls,
                ),
              ],
            ),

            const SizedBox(height: 12),

            SizedBox(
              height: 24,
              child: Center(
                child: Text(
                  gameOver
                      ? (lastRuns == 0 ? 'No Runs' : '$lastRuns Runs')
                      : lastRuns == 0
                          ? ''
                          : (lastRuns == 1
                              ? '1 Run'
                              : '$lastRuns Runs'),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 2),

            if (!gameOver)
              ElevatedButton(
                onPressed: playBall,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF075EA8),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 3,
                  ),
                  minimumSize: const Size(0, 30),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(3),
                  ),
                  elevation: 2,
                ),
                child: const Text(
                  'Bat',
                  style: TextStyle(fontSize: 10),
                ),
              )
            else
              ElevatedButton(
                onPressed: restartGame,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 3,
                  ),
                  minimumSize: const Size(0, 30),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(3),
                  ),
                  elevation: 2,
                ),
                child: const Text(
                  'Restart',
                  style: TextStyle(fontSize: 10),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

enum ScoreCardType { bat, ball }

class _ScoreCard extends StatelessWidget {
  final ScoreCardType type;
  final String label;
  final int value;

  const _ScoreCard({
    required this.type,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 56,
          height: 56,
          color: Colors.white,
          child: CustomPaint(
            painter: type == ScoreCardType.bat
                ? _BatPainter()
                : _BallPainter(),
          ),
        ),
        const SizedBox(height: 3),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 9,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          '$value',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _BatPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..isAntiAlias = true;

    // Cricket bat blade.
    final blade = Path()
      ..moveTo(10, 39)
      ..lineTo(38, 11)
      ..lineTo(44, 17)
      ..lineTo(16, 45)
      ..close();

    paint.color = const Color(0xFFF0C47C);
    canvas.drawPath(blade, paint);

    // Bat handle.
    paint.color = const Color(0xFF3D4655);
    final handle = Path()
      ..moveTo(37, 12)
      ..lineTo(47, 2)
      ..lineTo(50, 5)
      ..lineTo(41, 16)
      ..close();
    canvas.drawPath(handle, paint);

    // Bat edge.
    paint.color = const Color(0xFF697386);
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 1.4;
    canvas.drawPath(blade, paint);
    paint.style = PaintingStyle.fill;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _BallPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = 25.5;

    final paint = Paint()..isAntiAlias = true;
    paint.color = const Color(0xFFFF3B3B);
    canvas.drawCircle(center, radius, paint);

    paint.color = Colors.white;
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 1.5;

    final seam1 = Path()
      ..moveTo(16, 9)
      ..cubicTo(27, 17, 32, 30, 46, 44);
    final seam2 = Path()
      ..moveTo(12, 15)
      ..cubicTo(23, 22, 30, 34, 42, 47);
    final seam3 = Path()
      ..moveTo(10, 21)
      ..cubicTo(21, 28, 27, 39, 36, 48);

    canvas.drawPath(seam1, paint);
    canvas.drawPath(seam2, paint);
    canvas.drawPath(seam3, paint);

    paint.style = PaintingStyle.fill;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
