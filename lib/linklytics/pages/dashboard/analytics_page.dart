import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:my_portfolio_flutter/linklytics/design_system/app_button.dart';
import 'package:my_portfolio_flutter/linklytics/design_system/app_predefined_size.dart';
import 'package:my_portfolio_flutter/linklytics/design_system/app_sized_box.dart';
import 'package:my_portfolio_flutter/linklytics/design_system/app_sizes.dart';
import 'package:my_portfolio_flutter/linklytics/design_system/app_text.dart';

import 'dart:html' as html;
import 'analytics_provider.dart';
import 'anaylytics_data.dart';
import 'short_url_provider.dart';

class AnalyticsPage extends ConsumerWidget {
  final Map<String, int> clickData; // Data from API
  const AnalyticsPage({super.key, required this.clickData});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analyticsState = ref.watch(analyticsProvider);
    final hasData = false;

    return Padding(
      padding: EdgeInsets.all(AppPredefinedSize.md),
      child: analyticsState.when(
        data: (data) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const AppText(
                  "Total Clicks",
                  type: TextType.xs,
                ),
              ],
            ),
            SizedBox(
              height: 300,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Opacity(
                    opacity: data.isEmpty ? 0.1 : 1.0,
                    // Reduce opacity if no data
                    child: Padding(
                      padding: EdgeInsets.all(AppSizes.md),
                      child: BarChart(
                        data.isEmpty
                            ? _buildSampleBarChartData()
                            : BarChartData(
                                barGroups: _generateBarData(data),
                                borderData: FlBorderData(show: false),
                                titlesData: FlTitlesData(
                                  leftTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      reservedSize: 40,
                                      getTitlesWidget: (value, meta) {
                                        return Padding(
                                          padding: EdgeInsets.only(
                                              right: AppSizes.sm),
                                          child: AppText(
                                            value.toInt().toString(),
                                            type: TextType.xs,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  bottomTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      getTitlesWidget: (value, meta) {
                                        return Transform.rotate(
                                          angle: -0.5,
                                          child: AppText(
                                            _formatDate(
                                                data[value.toInt()].clickDate),
                                            type: TextType.xs,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                barTouchData: data.isEmpty
                                    ? null
                                    : BarTouchData(
                                        touchTooltipData: BarTouchTooltipData(
                                          getTooltipItem: (group, groupIndex,
                                              rod, rodIndex) {
                                            return BarTooltipItem(
                                              "${_formatDate(data[group.x.toInt()].clickDate)}\nTotal Clicks: ${rod.toY.toInt()}",
                                              const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            );
                                          },
                                        ),
                                      ),
                              ),
                      ),
                    ),
                  ),
                  // No Data UI
                  if (!hasData)
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "No Data For This Time Period",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "Share your short link to view where your engagements are coming from",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: AppSizes.txtSm, color: Colors.grey),
                        ),
                        AppSizedBox.lg(),
                        createShortUrlButton(context, ref),
                      ],
                    ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const AppText(
                  "Date",
                  type: TextType.sm,
                  bold: true,
                ),
              ],
            ),
            if (data.isNotEmpty)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  createShortUrlButton(context, ref),
                  AppSizedBox.xl(
                    horizontal: true,
                  )
                ],
              ),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) =>
            Center(child: Text("Error loading data: $error")),
      ),
    );
  }

  List<BarChartGroupData> _generateBarData(List<TotalClickEventResponse> data) {
    return List.generate(data.length, (index) {
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: data[index].count.toDouble(),
            color: Colors.blue,
            width: 15,
          ),
        ],
      );
    });
  }

  String _formatDate(String date) {
    // Convert "YYYY-MM-DD" into a more readable format
    final parsedDate = DateTime.parse(date);
    return DateFormat('MMM dd').format(parsedDate); // E.g., "Jul 01"
  }

  // Builds Bar Chart Data
  BarChartData _buildSampleBarChartData() {
    List<BarChartGroupData> barGroups = [];
    final data = [130, 50, 20, 100, 170, 250, 90, 300, 80, 150];

    barGroups = _generateBarData(data
        .asMap()
        .entries
        .map((entry) => TotalClickEventResponse(
            clickDate: 'yyyy-mm-${entry.key}', count: entry.value))
        .toList());

    return BarChartData(
      titlesData: FlTitlesData(
        leftTitles: AxisTitles(sideTitles: _sideTitles("Number Of Clicks")),
        bottomTitles: AxisTitles(sideTitles: _sideTitles("Date")),
      ),
      barGroups: barGroups,
    );
  }

  SideTitles _sideTitles(String title) {
    return SideTitles(
      showTitles: true,
      getTitlesWidget: (value, meta) {
        return Padding(
          padding: const EdgeInsets.all(4.0),
          child: Text(value.toInt().toString(),
              style: const TextStyle(fontSize: 12)),
        );
      },
    );
  }

  AppButton createShortUrlButton(BuildContext context, WidgetRef ref) {
    return AppButton(
      'Create a new Short URL',
      onPressed: () {
        showShortenUrlDialog(context, ref);
      },
      type: ButtonType.gradient,
      size: ButtonSize.large,
      fontSize: AppSizes.txtSm,
    );
  }

  void showShortenUrlDialog(BuildContext context, WidgetRef ref) {
    final TextEditingController urlController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: SizedBox(
            width: 400, // Set custom width
            height: 220, // Set custom height
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title + Divider
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      AppText('Create New Shorten Url',
                          type: TextType.xl, bold: true),
                      const SizedBox(height: 8),
                      Divider(thickness: 1, color: Colors.grey[400]),
                      // Separator line
                    ],
                  ),

                  // Form Content
                  const SizedBox(height: 16),
                  Form(
                    key: formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          controller: urlController,
                          decoration: InputDecoration(
                            labelText: "Enter URL",
                            hintText: "https://example.com",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8)),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "URL is required*";
                            }
                            Uri? uri = Uri.tryParse(value);
                            if (uri == null || !uri.isAbsolute) {
                              return "Invalid URL format!";
                            }
                            return null;
                          },
                        ),
                        AppSizedBox.sm(),
                        Consumer(builder: (context, ref, child) {
                          final state = ref.watch(shortUrlProvider);
                          if (state is ShortUrlError) {
                            return Text(state.message,
                                style: const TextStyle(color: Colors.red));
                          }
                          return const SizedBox.shrink();
                        }),
                      ],
                    ),
                  ),

                  const Spacer(),

                  // Actions (Create Button)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Consumer(builder: (context, ref, child) {
                      final state = ref.watch(shortUrlProvider);

                      return AppButton(
                        'Create',
                        fontSize: AppSizes.txtMd,
                        type: ButtonType.gradient,
                        size: ButtonSize.medium,
                        isLoading: state is ShortUrlLoading,
                        onPressed: state is ShortUrlLoading
                            ? null
                            : () async {
                                if (formKey.currentState!.validate()) {
                                  String? result = await ref
                                      .read(shortUrlProvider.notifier)
                                      .createShortUrl(urlController.text);
                                  if (result == null) {
                                    Fluttertoast.showToast(
                                      msg: "Opps! There's something wrong!",
                                      gravity: ToastGravity.BOTTOM,
                                    );
                                    Navigator.pop(context);
                                    return;
                                  }

                                  Navigator.pop(context);
                                  copyToClipboardWeb(result);
                                }
                              },
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void copyToClipboardWeb(String text) {
    html.window.navigator.clipboard?.writeText(text).then((_) {
      print("Copied successfully!");
      Fluttertoast.showToast(
        msg: "Copied to clipboard!",
        gravity: ToastGravity.BOTTOM_LEFT,
      );
    }).catchError((error) {
      print("Failed to copy: $error");
      Fluttertoast.showToast(
        msg: "Failed to copy: $error",
        gravity: ToastGravity.BOTTOM_LEFT,
      );
    });
  }

}
