
import 'package:flutter/material.dart';

void main() {
  runApp(const PhoneTechApp());
}

class PhoneTechApp extends StatelessWidget {
  const PhoneTechApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PhoneTech Pro',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF090810),
        colorScheme: ColorScheme.dark(
          primary: Color(0xFF9B6DFF),
          surface: Color(0xFF151222),
        ),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  final List<Map<String, dynamic>> sections = const [
    {'name': 'توافق قطع الغيار', 'icon': Icons.devices},
    {'name': 'المخططات الإلكترونية', 'icon': Icons.memory},
    {'name': 'مسارات الأعطال', 'icon': Icons.account_tree},
    {'name': 'دليل الصيانة', 'icon': Icons.build},
    {'name': 'المساعد الذكي', 'icon': Icons.smart_toy},
    {'name': 'المفضلة', 'icon': Icons.bookmark},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF090810),
        title: const Text(
          'PhoneTech Pro',
          style: TextStyle(
            color: Color(0xFFB99AFF),
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: const [
          Icon(Icons.notifications_none),
          SizedBox(width: 16),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'مرحباً بك في PhoneTech',
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'كل ما يحتاجه فني صيانة الهواتف',
                style: TextStyle(color: Colors.white60),
              ),
              const SizedBox(height: 22),
              TextField(
                decoration: InputDecoration(
                  hintText: 'ابحث عن هاتف أو قطعة غيار',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: const Color(0xFF151222),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 25),
              const Text(
                'الأقسام الرئيسية',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15),
              Expanded(
                child: GridView.builder(
                  itemCount: sections.length,
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.25,
                  ),
                  itemBuilder: (context, index) {
                    final item = sections[index];
                    return Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF151222),
                        borderRadius: BorderRadius.circular(17),
                        border: Border.all(
                          color: const Color(0xFF302442),
                        ),
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(17),
                        onTap: () {},
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              item['icon'],
                              size: 35,
                              color: const Color(0xFFB99AFF),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              item['name'],
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
