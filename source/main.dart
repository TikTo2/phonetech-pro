import 'package:flutter/material.dart';
import 'phone_data.dart';

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
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF9B6DFF),
          surface: Color(0xFF151222),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF090810),
          elevation: 0,
        ),
      ),
      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: child!,
        );
      },
      home: const HomePage(),
    );
  }
}

// ============================================================
// الصفحة الرئيسية
// ============================================================

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController searchController = TextEditingController();

  List<PhoneModel> searchResults = [];

  final List<Map<String, dynamic>> sections = const [
    {
      'name': 'توافق قطع الغيار',
      'icon': Icons.devices,
      'type': 'parts',
    },
    {
      'name': 'المخططات الإلكترونية',
      'icon': Icons.memory,
      'type': 'diagrams',
    },
    {
      'name': 'مسارات الأعطال',
      'icon': Icons.account_tree,
      'type': 'faults',
    },
    {
      'name': 'دليل الصيانة',
      'icon': Icons.build,
      'type': 'repair',
    },
    {
      'name': 'المساعد الذكي',
      'icon': Icons.smart_toy,
      'type': 'assistant',
    },
    {
      'name': 'المفضلة',
      'icon': Icons.bookmark,
      'type': 'favorites',
    },
  ];

  @override
  void initState() {
    super.initState();
    searchController.addListener(searchPhones);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void searchPhones() {
    final query = searchController.text.trim().toLowerCase();

    setState(() {
      if (query.isEmpty) {
        searchResults = [];
        return;
      }

      searchResults = phoneDatabase.where((phone) {
        return phone.name.toLowerCase().contains(query) ||
            phone.brand.toLowerCase().contains(query) ||
            phone.modelNumber.toLowerCase().contains(query) ||
            phone.commonFaults.any(
              (fault) => fault.toLowerCase().contains(query),
            ) ||
            phone.parts.any(
              (part) => part.toLowerCase().contains(query),
            );
      }).toList();
    });
  }

  void openSection(String type) {
    if (type == 'assistant') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const AssistantPage(),
        ),
      );
      return;
    }

    if (type == 'favorites') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const SimpleInfoPage(
            title: 'المفضلة',
            icon: Icons.bookmark,
            message: 'ستتم إضافة نظام المفضلة في المرحلة القادمة.',
          ),
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PhoneListPage(
          title: sectionTitle(type),
          type: type,
        ),
      ),
    );
  }

  String sectionTitle(String type) {
    switch (type) {
      case 'parts':
        return 'توافق قطع الغيار';
      case 'diagrams':
        return 'المخططات الإلكترونية';
      case 'faults':
        return 'مسارات الأعطال';
      case 'repair':
        return 'دليل الصيانة';
      default:
        return 'الأجهزة';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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

              // البحث
              TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: 'ابحث عن هاتف أو قطعة غيار أو عطل',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            searchController.clear();
                          },
                        )
                      : null,
                  filled: true,
                  fillColor: const Color(0xFF151222),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              // نتائج البحث
              if (searchResults.isNotEmpty) ...[
                const SizedBox(height: 12),
                Expanded(
                  child: ListView.builder(
                    itemCount: searchResults.length,
                    itemBuilder: (context, index) {
                      final phone = searchResults[index];

                      return PhoneCard(
                        phone: phone,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => PhoneDetailsPage(
                                phone: phone,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ] else if (searchController.text.isNotEmpty) ...[
                const SizedBox(height: 25),
                const Center(
                  child: Text(
                    'لم يتم العثور على نتائج',
                    style: TextStyle(
                      color: Colors.white60,
                      fontSize: 16,
                    ),
                  ),
                ),
                const Spacer(),
              ] else ...[
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

                      return SectionCard(
                        name: item['name'],
                        icon: item['icon'],
                        onTap: () {
                          openSection(item['type']);
                        },
                      );
                    },
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// بطاقة القسم
// ============================================================

class SectionCard extends StatelessWidget {
  final String name;
  final IconData icon;
  final VoidCallback onTap;

  const SectionCard({
    super.key,
    required this.name,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
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
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 35,
              color: const Color(0xFFB99AFF),
            ),
            const SizedBox(height: 12),
            Text(
              name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// صفحة قائمة الأجهزة
// ============================================================

class PhoneListPage extends StatelessWidget {
  final String title;
  final String type;

  const PhoneListPage({
    super.key,
    required this.title,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    final brands = phoneDatabase
        .map((phone) => phone.brand)
        .toSet()
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'اختر الشركة',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 15),

          ...brands.map(
            (brand) {
              final phones = phoneDatabase
                  .where((phone) => phone.brand == brand)
                  .toList();

              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFF151222),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: const Color(0xFF302442),
                  ),
                ),
                child: ExpansionTile(
                  leading: const Icon(
                    Icons.phone_android,
                    color: Color(0xFFB99AFF),
                  ),
                  title: Text(
                    brand,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  children: phones.map(
                    (phone) {
                      return ListTile(
                        leading: const Icon(
                          Icons.smartphone,
                          color: Colors.white70,
                        ),
                        title: Text(phone.name),
                        subtitle: Text(phone.modelNumber),
                        trailing: const Icon(
                          Icons.arrow_forward_ios,
                          size: 15,
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => PhoneDetailsPage(
                                phone: phone,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ).toList(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// ============================================================
// بطاقة الهاتف
// ============================================================

class PhoneCard extends StatelessWidget {
  final PhoneModel phone;
  final VoidCallback onTap;

  const PhoneCard({
    super.key,
    required this.phone,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF151222),
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: Color(0xFF251B3B),
          child: Icon(
            Icons.phone_android,
            color: Color(0xFFB99AFF),
          ),
        ),
        title: Text(
          phone.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          '${phone.brand} • ${phone.modelNumber}',
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}

// ============================================================
// صفحة تفاصيل الهاتف
// ============================================================

class PhoneDetailsPage extends StatelessWidget {
  final PhoneModel phone;

  const PhoneDetailsPage({
    super.key,
    required this.phone,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(phone.name),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // رأس الجهاز
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF151222),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: const Color(0xFF302442),
              ),
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.phone_android,
                  size: 65,
                  color: Color(0xFFB99AFF),
                ),
                const SizedBox(height: 12),
                Text(
                  phone.name,
                  style: const TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '${phone.brand} • ${phone.modelNumber}',
                  style: const TextStyle(
                    color: Colors.white60,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          // المواصفات
          DetailSection(
            title: 'معلومات الجهاز',
            icon: Icons.info_outline,
            children: [
              InfoRow(
                title: 'المعالج',
                value: phone.chipset,
              ),
              InfoRow(
                title: 'البطارية',
                value: phone.battery,
              ),
              InfoRow(
                title: 'منفذ الشحن',
                value: phone.chargingPort,
              ),
            ],
          ),

          // المخططات
          DetailSection(
            title: 'المخططات الإلكترونية',
            icon: Icons.memory,
            children: phone.diagrams
                .map(
                  (item) => ActionRow(
                    icon: Icons.description_outlined,
                    title: item,
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'سيتم إضافة ملف المخطط: $item',
                          ),
                        ),
                      );
                    },
                  ),
                )
                .toList(),
          ),

          // الأعطال
          DetailSection(
            title: 'الأعطال الشائعة',
            icon: Icons.warning_amber_outlined,
            children: phone.commonFaults
                .map(
                  (fault) => ActionRow(
                    icon: Icons.build_circle_outlined,
                    title: fault,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => FaultDetailsPage(
                            phone: phone,
                            fault: fault,
                          ),
                        ),
                      );
                    },
                  ),
                )
                .toList(),
          ),

          // دليل الصيانة
          DetailSection(
            title: 'دليل الصيانة',
            icon: Icons.build,
            children: phone.repairGuides
                .map(
                  (guide) => ActionRow(
                    icon: Icons.check_circle_outline,
                    title: guide,
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'دليل الصيانة: $guide',
                          ),
                        ),
                      );
                    },
                  ),
                )
                .toList(),
          ),

          // قطع الغيار
          DetailSection(
            title: 'قطع الغيار',
            icon: Icons.settings_outlined,
            children: phone.parts
                .map(
                  (part) => ActionRow(
                    icon: Icons.inventory_2_outlined,
                    title: part,
                  ),
                )
                .toList(),
          ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }
}

// ============================================================
// صفحة تفاصيل العطل
// ============================================================

class FaultDetailsPage extends StatelessWidget {
  final PhoneModel phone;
  final String fault;

  const FaultDetailsPage({
    super.key,
    required this.phone,
    required this.fault,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(fault),
      ),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          Text(
            phone.name,
            style: const TextStyle(
              color: Color(0xFFB99AFF),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 20),

          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF151222),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'تشخيص: $fault',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
    
