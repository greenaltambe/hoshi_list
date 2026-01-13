import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hoshi_list/features/media/providers/staff_details_provider.dart';
import 'package:hoshi_list/features/media/providers/staff_list_provider.dart';
import 'package:markdown_widget/markdown_widget.dart';

class StaffListTab extends ConsumerWidget {
  const StaffListTab({super.key, required this.mediaId});

  final int mediaId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final staffList = ref.watch(mediaStaffListProvider(mediaId));
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: staffList.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Center(
              child: Text(
                'Error: $error',
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
            ),
            data: (staffList) => ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: staffList.length + 1,
              itemBuilder: (context, index) {
                if (index == staffList.length) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: ElevatedButton(
                      onPressed: () {
                        ref
                            .read(mediaStaffListProvider(mediaId).notifier)
                            .loadNextPage();
                      },
                      child: const Text('Load more'),
                    ),
                  );
                }
                final staff = staffList[index];
                return ListTile(
                  leading: ClipRRect(
                    clipBehavior: Clip.hardEdge,
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      staff.imageUrl,
                      width: 50,
                      height: 70,
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: Text(staff.name),
                  subtitle: Text('Role: ${staff.role}'),
                  onTap: () {
                    _showStaffDetails(context, staff);
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  void _showStaffDetails(BuildContext context, staff) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (ctx) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.6,
          minChildSize: 0.4,
          maxChildSize: 0.9,
          builder: (context, scrollController) {
            return Consumer(
              builder: (context, ref, child) {
                final staffDetails = ref.watch(
                  mediaStaffDetailsProvider(staff.id),
                );
                return SingleChildScrollView(
                  controller: scrollController,
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Container(
                        width: 40,
                        height: 4,
                        margin: EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),

                      // Staff   Image
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          staff
                              .imageUrl, // Use passed staff img while loading details
                          width: 120,
                          height: 180,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Name
                      Text(
                        staff.name,
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        staff.role,
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                      const Divider(height: 32),

                      staffDetails.when(
                        loading: () => const Padding(
                          padding: EdgeInsets.all(20.0),
                          child: CircularProgressIndicator(),
                        ),
                        error: (err, _) =>
                            Text('Could not load description: $err'),
                        data: (details) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Description",
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: 8),
                              // Markdown Widget Configuration
                              MarkdownWidget(
                                data:
                                    details.description ??
                                    'No description available.',
                                shrinkWrap:
                                    true, // Vital when inside SingleChildScrollView
                                physics:
                                    const NeverScrollableScrollPhysics(), // Let parent scroll
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
