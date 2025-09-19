import 'package:mango/data/manga/chapter/bokunohero/bokunohero.dart';
import 'package:mango/data/manga/chapter/demonslayers/demonslayer.dart';
import 'package:mango/data/manga/chapter/jujutsukaisen/jujutsukaisen.dart';
import 'package:mango/data/manga/chapter/onepieces/onepiece_chapters.dart';
import 'package:mango/data/manhua/chapter/battlethroughtheheavens/battlethroughttheheavens.dart';
import 'package:mango/data/manhua/chapter/magicemperor/magicemperor.dart';
import 'package:mango/data/manhua/chapter/talesofdemonsandgods/talesofdemonsandgods.dart';
import 'package:mango/data/manhwa/chapter/sololeveling/sololeveling.dart';
import 'package:mango/data/manhwa/chapter/thegotofhighschool/thegotofhighschool.dart';
import 'package:mango/data/manhwa/chapter/windbreaker/windbreaker.dart';
import '../models/chapter.dart';

Map<String, List<Chapter>> allComicChapters = {
  ...onepieceChapters,
  ...jujutsukaisenChapters,
  ...demonslayerChapters,
  ...bokunoheroChapters,
  ...talesofdemonsandgodsChapters,
  ...battlethroughttheheavensChapters,
  ...magicemperorChapters,
  ...sololevelingChapters,
  ...thegotofhighschoolChapters,
  ...windbreakerChapters,
};

List<Chapter> getSampleChapters(String comicId) {
  return allComicChapters[comicId] ?? [];
}


