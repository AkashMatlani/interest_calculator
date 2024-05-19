import 'package:flutter/material.dart';
import 'package:interest_calculator/provider/config_provider.dart';
import 'package:interest_calculator/provider/form_state_provider.dart';
import 'package:provider/provider.dart';

class InterestForm extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  InterestForm({super.key});

  @override
  Widget build(BuildContext context) {
    final config = Provider.of<ConfigProvider>(context).getConfig;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Compound Interest Calculator'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Consumer<FormStateProvider>(
                builder: (context, formState, child) {
                  return DropdownButtonFormField<double>(
                    decoration: InputDecoration(
                      labelText: config['rateOfInterest']['labelText'],
                      labelStyle: TextStyle(
                        color: Color(int.parse(config['rateOfInterest']
                                ['textColor']
                            .replaceAll('#', '0xff'))),
                        fontSize:
                            config['rateOfInterest']['textSize'].toDouble(),
                      ),
                    ),
                    value: formState.rateOfInterest,
                    items: config['rateOfInterest']['values']
                        .entries
                        .map<DropdownMenuItem<double>>((entry) {
                      return DropdownMenuItem<double>(
                        value: entry.value.toDouble(),
                        child: Text(entry.key),
                      );
                    }).toList(),
                    onChanged: (value) {
                      context
                          .read<FormStateProvider>()
                          .setRateOfInterest(value!);
                    },
                  );
                },
              ),
              Consumer<FormStateProvider>(
                builder: (context, formState, child) {
                  return TextFormField(
                    decoration: InputDecoration(
                      hintText: config['principalAmount']['hintText'],
                      hintStyle: TextStyle(
                        color: Color(int.parse(config['principalAmount']
                                ['textColor']
                            .replaceAll('#', '0xff'))),
                        fontSize:
                            config['principalAmount']['textSize'].toDouble(),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      final amount = double.tryParse(value ?? '');
                      final minAmount = _getMinPrincipalAmount(
                          formState.rateOfInterest, config);
                      if (amount == null ||
                          amount < minAmount ||
                          amount > config['principalAmount']['maxAmount']) {
                        return config['principalAmount']['errorMessage'];
                      }
                      return null;
                    },
                    onSaved: (value) {
                      context
                          .read<FormStateProvider>()
                          .setPrincipalAmount(double.tryParse(value!)!);
                    },
                  );
                },
              ),
              Consumer<FormStateProvider>(
                builder: (context, formState, child) {
                  return DropdownButtonFormField<int>(
                    decoration: InputDecoration(
                      labelText: config['compoundFrequency']['labelText'],
                      labelStyle: TextStyle(
                        color: Color(int.parse(config['compoundFrequency']
                                ['textColor']
                            .replaceAll('#', '0xff'))),
                        fontSize:
                            config['compoundFrequency']['textSize'].toDouble(),
                      ),
                    ),
                    value: formState.compoundFrequency,
                    items: _getCompoundFrequencyItems(
                        formState.rateOfInterest, config),
                    onChanged: (value) {
                      context
                          .read<FormStateProvider>()
                          .setCompoundFrequency(value!);
                    },
                  );
                },
              ),
              Consumer<FormStateProvider>(
                builder: (context, formState, child) {
                  return DropdownButtonFormField<int>(
                    decoration: InputDecoration(
                      labelText: config['years']['labelText'],
                      labelStyle: TextStyle(
                        color: Color(int.parse(config['years']['textColor']
                            .replaceAll('#', '0xff'))),
                        fontSize: config['years']['textSize'].toDouble(),
                      ),
                    ),
                    value: formState.years,
                    items: _getYearsItems(formState.compoundFrequency, config),
                    onChanged: (value) {
                      context.read<FormStateProvider>().setYears(value!);
                    },
                  );
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    context.read<FormStateProvider>().calculate();
                  }
                },
                child: const Text('Calculate'),
              ),
              Consumer<FormStateProvider>(
                builder: (context, formState, child) {
                  if (formState.result != null) {
                    return Text(
                      'Compound Interest: ${formState.result}',
                      style: TextStyle(
                        color: Color(int.parse(config['output']['textColor']
                            .replaceAll('#', '0xff'))),
                        fontSize: config['output']['textSize'].toDouble(),
                      ),
                    );
                  }
                  return Container();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  int _getMinPrincipalAmount(
      double rateOfInterest, Map<String, dynamic> config) {
    final minAmounts = config['principalAmount']['minAmounts'];
    if (rateOfInterest >= 1 && rateOfInterest <= 3) return minAmounts['1-3'];
    if (rateOfInterest >= 4 && rateOfInterest <= 7) return minAmounts['4-7'];
    if (rateOfInterest >= 8 && rateOfInterest <= 12) return minAmounts['8-12'];
    return minAmounts['default'];
  }

  List<DropdownMenuItem<int>> _getCompoundFrequencyItems(
      double rateOfInterest, Map<String, dynamic> config) {
    final frequencies = config['compoundFrequency']['values']['default'];
    if (config['compoundFrequency']['values']['specific']
        .containsKey(rateOfInterest.toInt().toString())) {
      return config['compoundFrequency']['values']['specific']
              [rateOfInterest.toInt().toString()]
          .entries
          .map<DropdownMenuItem<int>>((entry) {
        return DropdownMenuItem<int>(
          value: entry.value,
          child: Text(entry.key.toString()),
        );
      }).toList();
    }
    return frequencies.entries.map<DropdownMenuItem<int>>((entry) {
      return DropdownMenuItem<int>(
        value: entry.value,
        child: Text(entry.key.toString()),
      );
    }).toList();
  }

  List<DropdownMenuItem<int>> _getYearsItems(
      int compoundFrequency, Map<String, dynamic> config) {
    final yearsRange = config['years']['values'][compoundFrequency.toString()];
    return List.generate(yearsRange[1] - yearsRange[0] + 1, (index) {
      return DropdownMenuItem<int>(
        value: yearsRange[0] + index,
        child: Text((yearsRange[0] + index).toString()),
      );
    });
  }
}
