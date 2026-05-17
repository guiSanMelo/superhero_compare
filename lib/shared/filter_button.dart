import 'package:flutter/material.dart';

enum AlignmentFilter { all, hero, villain, neutral }

class FilterButton extends StatefulWidget {
  final AlignmentFilter selectedAlignment;
  final double powerMin;
  final Function(AlignmentFilter, double) onApply;

  const FilterButton({
    super.key,
    required this.selectedAlignment,
    required this.powerMin,
    required this.onApply,
  });

  @override
  State<FilterButton> createState() => _FilterButtonState();
}

class _FilterButtonState extends State<FilterButton> {
  late AlignmentFilter _alignment;
  late double _power;

  @override
  void initState() {
    super.initState();
    _alignment = widget.selectedAlignment;
    _power = widget.powerMin;
  }

  void _openModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Filtrar Heróis",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 16),

                  RadioListTile(
                    title: const Text("Todos"),
                    value: AlignmentFilter.all,
                    groupValue: _alignment,
                    onChanged: (value) {
                      setModalState(() {
                        _alignment = value!;
                      });
                    },
                  ),

                  RadioListTile(
                    title: const Text("Heróis"),
                    value: AlignmentFilter.hero,
                    groupValue: _alignment,
                    onChanged: (value) {
                      setModalState(() {
                        _alignment = value!;
                      });
                    },
                  ),

                  RadioListTile(
                    title: const Text("Vilões"),
                    value: AlignmentFilter.villain,
                    groupValue: _alignment,
                    onChanged: (value) {
                      setModalState(() {
                        _alignment = value!;
                      });
                    },
                  ),

                  RadioListTile(
                    title: const Text("Neutros"),
                    value: AlignmentFilter.neutral,
                    groupValue: _alignment,
                    onChanged: (value) {
                      setModalState(() {
                        _alignment = value!;
                      });
                    },
                  ),

                  const SizedBox(height: 16),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Poder mínimo: ${_power.toInt()}",
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      Slider(
                        value: _power,
                        min: 0,
                        max: 600,
                        divisions: 60,
                        onChanged: (value) {
                          setModalState(() {
                            _power = value;
                          });
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                      ),
                      onPressed: () {
                        widget.onApply(_alignment, _power);
                        Navigator.pop(context);
                      },
                      child: const Text("Aplicar filtros"),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _openModal,
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.black, width: 1.5),
          boxShadow: const [
            BoxShadow(
              color: Color(0x33000000),
              blurRadius: 0,
              offset: Offset(2, 2),
            ),
          ],
        ),
        child: const Icon(Icons.filter_list, color: Colors.black),
      ),
    );
  }
}