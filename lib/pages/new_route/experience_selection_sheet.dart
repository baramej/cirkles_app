import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pages/routes/route_experience_icon.dart';
import 'package:flutter/material.dart';

class ExperienceSelectionSheet extends StatefulWidget {
  final List<Map<String, dynamic>> experiences;

  const ExperienceSelectionSheet({
    super.key,
    required this.experiences,
  });

  @override
  State<ExperienceSelectionSheet> createState() => _ExperienceSelectionSheetState();
}

class _ExperienceSelectionSheetState extends State<ExperienceSelectionSheet> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _filteredExperiences = [];

  @override
  void initState() {
    super.initState();
    _filteredExperiences = List.from(widget.experiences);
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredExperiences = widget.experiences.where((item) => item["name"].toLowerCase().contains(query)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      height: screenHeight * 0.75,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                L10n.of(context).selectAnAttribute,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              labelText: L10n.of(context).search,
              prefixIcon: const Icon(Icons.search),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: _filteredExperiences.isEmpty
                ? Center(child: Text(L10n.of(context).noMatchingAttributeFound))
                : ListView.builder(
                    itemCount: _filteredExperiences.length,
                    itemBuilder: (context, index) {
                      final item = _filteredExperiences[index];
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Icon(RouteExperienceIcon.toIconData(item["icon"])),
                        title:
                            Text(Localizations.localeOf(context).languageCode == 'ar' ? item['name_ar'] : item['name']),
                        onTap: () {
                          Navigator.pop(context, item);
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
