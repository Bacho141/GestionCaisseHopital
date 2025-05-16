import 'package:flutter/material.dart';
import 'package:migo/view/responsive.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';

class SearchAndProfileSection extends StatelessWidget {
  final int itemCount;

  const SearchAndProfileSection({
    Key? key,
    required this.itemCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Neumorphic(
      style: NeumorphicStyle(
        depth: 6, // Ajoute une élévation
        intensity: 0.8,
        shape: NeumorphicShape.flat,
        boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(16)),
        color: Colors.white,
        shadowLightColor: Colors.grey.shade200, // Lumière douce
        shadowDarkColor: Colors.grey.shade600, // Ombre réaliste
      ),
      child: SizedBox(
        width: !Responsive.isMobile(context)
            ? MediaQuery.of(context).size.width - 110
            : MediaQuery.of(context).size.width - 30,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Visibility(
                    visible: Responsive.isDesktop(context),
                    child: Text(
                      "Tous les services de l'hôpital ($itemCount)",
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    width: Responsive.isMobile(context) ? 350 : 450,
                    height: Responsive.isMobile(context) ? 40 : null,
                    child: TextField(
                      decoration: InputDecoration(
                        fillColor: Colors.transparent,
                        contentPadding: Responsive.isMobile(context)
                            ? const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 10.0)
                            : null,
                        prefixIcon: Icon(
                          Iconsax.search_normal,
                          size: Responsive.isMobile(context) ? 18 : 24,
                        ),
                        hintText: 'Recherche...',
                        hintStyle: TextStyle(
                          fontSize: Responsive.isMobile(context) ? 14 : 16,
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
    // SizedBox(
    //   width: !Responsive.isMobile(context)
    //       ? MediaQuery.of(context).size.width - 110
    //       : null,
    //   child: Padding(
    //     padding: const EdgeInsets.only(top: 20.0, bottom: 8),
    //     child: Row(
    //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //       children: [
    //         Row(
    //           mainAxisAlignment: MainAxisAlignment.start,
    //           children: [
    //             Visibility(
    //               visible: Responsive.isDesktop(context),
    //               child: Text(
    //                 "Tous les services de l'hôphital ($itemCount)",
    //                 style: const TextStyle(
    //                   fontSize: 28,
    //                   fontWeight: FontWeight.w800,
    //                 ),
    //               ),
    //             ),
    //             SizedBox(width: 10,),
    //             SizedBox(
    //               width: Responsive.isMobile(context) ? 380 : 450,
    //               height: Responsive.isMobile(context) ? 40 : null,
    //               child: TextField(
    //                 decoration: InputDecoration(
    //                   fillColor: Colors.transparent,
    //                   contentPadding: Responsive.isMobile(context)
    //                       ? EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0)
    //                       : null,
    //                   prefixIcon: Icon(
    //                     Iconsax.search_normal,
    //                     size: Responsive.isMobile(context) ? 18 : 24,
    //                   ),
    //                   hintText: 'Recherche...',
    //                   hintStyle: TextStyle(
    //                     fontSize: Responsive.isMobile(context) ? 14 : 16,
    //                   ),
    //                   enabledBorder: OutlineInputBorder(
    //                     borderRadius: BorderRadius.all(Radius.circular(8.0)),
    //                     borderSide: BorderSide(color: Colors.transparent),
    //                   ),
    //                   border: OutlineInputBorder(
    //                     borderRadius: BorderRadius.all(Radius.circular(8)),
    //                   ),
    //                 ),
    //               ),
    //             )
    //           ],
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  }
}
