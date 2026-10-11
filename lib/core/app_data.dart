import 'package:musuem_guide_app_ui/core/asset_res.dart';
import 'package:musuem_guide_app_ui/core/models/exhibit_model.dart';
import 'package:musuem_guide_app_ui/constants/string_const.dart';

class AppData {
  static const lincolnStand = ExhibitModel(
    id: 'lincoln-stand',
    title: 'Lincoln Stand',
    yearLabel: '189 BC',
    imagePath: AssetRes.lincolinStandImg,
    thumbnailPath: AssetRes.lincolinStandImg,
    directionLabel: StringConst.towardRight,
    description:
        'A classical bust of Abraham Lincoln presented as a museum standpiece, highlighting sculptural detail and presence in the gallery.',
  );

  static const restAndPray = ExhibitModel(
    id: 'rest-and-pray',
    title: 'Rest & Pray',
    yearLabel: '194 BC',
    imagePath: AssetRes.restPrayImg,
    thumbnailPath: AssetRes.restPrayImg,
    stepsAway: 20,
    description:
        'A sculptural group capturing a quiet moment of rest and devotion, arranged among the nearby gallery exhibits.',
  );

  static const royalAlbert = ExhibitModel(
    id: 'royal-albert',
    title: 'Royal Albert',
    yearLabel: '134-162 BC',
    imagePath: AssetRes.royalAlberImg,
    thumbnailPath: AssetRes.royalAlberImg,
    floorLabel: StringConst.firstFloor,
    description:
        'A commemorative sculpture associated with the Royal Albert collection, noted for its refined posture and carved detail.',
  );

  static const dioskouroi = ExhibitModel(
    id: 'dioskouroi',
    title: 'Dioskouroi',
    yearLabel: '211-170 BC',
    imagePath: AssetRes.detailPageImg,
    thumbnailPath: AssetRes.dioskouralImg,
    floorLabel: StringConst.firstFloor,
    description:
        'The mythical twin heroes, Kastor (Κάστωρ, beaver; Latin, Castor) and Polydeukes (Πολυδεύκης, much sweet wine; Latin, Polydeuces or Pollux) were known as the Dioskouroi (Greek ).Their mother was Leda, but they had different fathers; Castor was the mortal son of Tyndareus, the king of Sparta, while Pollux was the divine son of Zeus, who seduced Leda in the guise of a swan.',
  );

  static const theWhiteLie = ExhibitModel(
    id: 'the-white-lie',
    title: 'The White Lie',
    yearLabel: '111-124 BC',
    shortYearLabel: '110 BC',
    imagePath: AssetRes.theWhiteLieImg,
    thumbnailPath: AssetRes.theWhiteLieImg,
    floorLabel: StringConst.firstFloor,
    description:
        'A striking white sculpture nicknamed The White Lie, presented as a first-floor highlight within the AR museum guide.',
  );

  static const nearbyExhibits = <ExhibitModel>[
    lincolnStand,
    restAndPray,
  ];

  static const firstFloorExhibits = <ExhibitModel>[
    royalAlbert,
    dioskouroi,
    theWhiteLie,
  ];

  static const scanningExhibits = <ExhibitModel>[
    theWhiteLie,
    lincolnStand,
    restAndPray,
  ];

  static const allExhibits = <ExhibitModel>[
    lincolnStand,
    restAndPray,
    royalAlbert,
    dioskouroi,
    theWhiteLie,
  ];

  static ExhibitModel? exhibitById(String id) {
    for (final exhibit in allExhibits) {
      if (exhibit.id == id) return exhibit;
    }
    return null;
  }
}
