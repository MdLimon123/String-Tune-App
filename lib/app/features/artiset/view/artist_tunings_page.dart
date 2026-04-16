import 'package:demo_project/app/core/utils/custom_appbar.dart';
import 'package:demo_project/app/features/artiset/view/artist_tunings_details_page.dart';
import 'package:demo_project/app/features/tuning/controller/tuning_workbench_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class ArtistTuningsPage extends StatefulWidget {
  const ArtistTuningsPage({super.key});

  @override
  State<ArtistTuningsPage> createState() => _ArtistTuningsPageState();
}

class _ArtistTuningsPageState extends State<ArtistTuningsPage> {
  final c = Get.find<TuningWorkbenchController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(title: 'Artist Tunings'),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: GetBuilder<TuningWorkbenchController>(
            builder: (_) {
              final filters = c.genres;
              final artists = c.filteredArtists;

              return Column(
                children: [
                  TextFormField(
                    style: const TextStyle(
                      color: Color(0xFFFFFFFF),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                    onChanged: c.setArtistSearch,
                    decoration: InputDecoration(
                      hint: const Text(
                        'Search by artist, band, or tuning....',
                        style: TextStyle(
                          color: Color(0xFF64748B),
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      fillColor: const Color(0xFF0F172A),
                      filled: true,
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(60)),
                        borderSide: BorderSide(color: Color(0xFF94A3B8)),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(60)),
                        borderSide: BorderSide(color: Color(0xFF9D4EDD)),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(60)),
                        borderSide: BorderSide(color: Color(0xFF94A3B8)),
                      ),
                      suffixIcon: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SvgPicture.asset('assets/icon/search.svg'),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: filters.map((label) {
                        final isSelected = c.artistFilter == label;
                        return GestureDetector(
                          onTap: () => c.setArtistFilter(label),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.easeInOut,
                            margin: const EdgeInsets.only(right: 10),
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color(0xFF9333EA)
                                  : const Color(0xFF0F172A),
                              borderRadius: BorderRadius.circular(50),
                              border: Border.all(
                                color: isSelected
                                    ? const Color(0xFF9333EA)
                                    : const Color(0xFF475569),
                                width: 1,
                              ),
                            ),
                            child: Text(
                              label,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.separated(
                      itemBuilder: (context, index) {
                        final artist = artists[index];
                        return _customContainer(
                          title: c.resolveTuningLabel(artist.tuning),
                          subtitle: artist.name,
                          text: '${artist.band} - ${artist.era}',
                          image: 'assets/image/1 25.png',
                          tag: artist.instrument == 'bass' ? 'Bass' : 'Guitar',
                          onTap: () {
                            c.loadArtist(artist);
                            Get.to(() => const ArtistTuningsDetailsPage());
                          },
                        );
                      },
                      separatorBuilder: (context, index) => const SizedBox(height: 20),
                      itemCount: artists.length,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _customContainer({
    required String title,
    required String subtitle,
    required String text,
    required String image,
    required String tag,
    required Function()? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: 144,
        decoration: BoxDecoration(
          color: const Color(0xFF1A1D2E),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF6B46A0), width: 1),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFFA070D0),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      FittedBox(
                        child: Text(
                          text,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Colors.white.withValues(alpha: 0.5),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: 56,
                        padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF334155),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: const Color(0xFF64748B), width: 1),
                        ),
                        child: Center(
                          child: Text(
                            tag,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFFC084FC),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: 120,
                height: double.infinity,
                child: Image.asset(image, fit: BoxFit.cover),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
