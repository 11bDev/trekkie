import '../models/star_trek_models.dart';

class ViewingOrderService {
  static List<ViewingEra> getRecommendedViewingOrder() {
    return [
      ViewingEra(
        title: '1. Pre-Federation Era',
        description: 'The earliest chronological period, showing humanity\'s first steps into space',
        items: [
          ViewingItem(
            id: 'ent_all',
            title: 'Star Trek: Enterprise',
            type: 'series',
            subtitle: 'Seasons 1–4',
            note: 'Shows humanity\'s first warp-capable starship and formation of the Federation',
          ),
        ],
      ),
      
      ViewingEra(
        title: '2. Pre-Original Series Era',
        description: 'The period leading up to Kirk\'s five-year mission',
        items: [
          ViewingItem(
            id: 'dis_early',
            title: 'Star Trek: Discovery',
            type: 'series',
            subtitle: 'Seasons 1–2',
            note: 'Set 10 years before TOS, introduces Spock\'s adoptive sister',
          ),
          ViewingItem(
            id: 'snw_all',
            title: 'Star Trek: Strange New Worlds',
            type: 'series',
            subtitle: 'Seasons 1–2',
            note: 'Direct prequel to TOS featuring Pike\'s Enterprise',
          ),
          ViewingItem(
            id: 'short_treks',
            title: 'Star Trek: Short Treks',
            type: 'series',
            subtitle: 'Select episodes',
            note: 'Especially those tied to Discovery S1–2',
            isOptional: true,
          ),
        ],
      ),
      
      ViewingEra(
        title: '3. The Original Series Era',
        description: 'Kirk\'s five-year mission and the early movie era',
        items: [
          ViewingItem(
            id: 'tos_pilot',
            title: 'The Cage',
            type: 'episode',
            subtitle: 'TOS Pilot',
            note: 'Original pilot with Captain Pike (optional but recommended)',
            isOptional: true,
          ),
          ViewingItem(
            id: 'tos_all',
            title: 'Star Trek: The Original Series',
            type: 'series',
            subtitle: 'Seasons 1–3',
            note: 'Kirk, Spock, and McCoy\'s legendary adventures',
          ),
          ViewingItem(
            id: 'tas_all',
            title: 'Star Trek: The Animated Series',
            type: 'series',
            subtitle: 'Seasons 1–2',
            note: 'Continuation of TOS with original cast voices',
            isOptional: true,
          ),
          ViewingItem(
            id: 'tmp',
            title: 'Star Trek: The Motion Picture',
            type: 'movie',
            note: 'Kirk returns to the Enterprise',
          ),
          ViewingItem(
            id: 'twok',
            title: 'Star Trek II: The Wrath of Khan',
            type: 'movie',
            note: 'Widely considered the best Star Trek film',
          ),
          ViewingItem(
            id: 'tsfs',
            title: 'Star Trek III: The Search for Spock',
            type: 'movie',
            note: 'Direct sequel to Wrath of Khan',
          ),
          ViewingItem(
            id: 'tvh',
            title: 'Star Trek IV: The Voyage Home',
            type: 'movie',
            note: 'The crew travels to 1986 to save whales',
          ),
          ViewingItem(
            id: 'tff',
            title: 'Star Trek V: The Final Frontier',
            type: 'movie',
            note: 'Spock\'s half-brother seeks God',
            isOptional: true,
          ),
          ViewingItem(
            id: 'tuc',
            title: 'Star Trek VI: The Undiscovered Country',
            type: 'movie',
            note: 'The original crew\'s final adventure',
          ),
        ],
      ),
      
      ViewingEra(
        title: '4. The Next Generation Era (24th Century)',
        description: 'The golden age of Star Trek with multiple overlapping series',
        items: [
          ViewingItem(
            id: 'tng_all',
            title: 'Star Trek: The Next Generation',
            type: 'series',
            subtitle: 'Seasons 1–7',
            note: 'Picard\'s Enterprise-D crew, 100 years after Kirk',
          ),
          ViewingItem(
            id: 'ds9_all',
            title: 'Star Trek: Deep Space Nine',
            type: 'series',
            subtitle: 'Seasons 1–7',
            note: 'Darker, serialized stories on a space station (overlaps with TNG S6-7)',
          ),
          ViewingItem(
            id: 'gen',
            title: 'Star Trek Generations',
            type: 'movie',
            note: 'Kirk and Picard team up (watch after TNG S7)',
          ),
          ViewingItem(
            id: 'voy_all',
            title: 'Star Trek: Voyager',
            type: 'series',
            subtitle: 'Seasons 1–7',
            note: 'Stranded in the Delta Quadrant (overlaps with DS9)',
          ),
          ViewingItem(
            id: 'fc',
            title: 'Star Trek: First Contact',
            type: 'movie',
            note: 'The Borg travel back to prevent first contact',
          ),
          ViewingItem(
            id: 'ins',
            title: 'Star Trek: Insurrection',
            type: 'movie',
            note: 'Picard defies Starfleet orders',
          ),
          ViewingItem(
            id: 'nem',
            title: 'Star Trek: Nemesis',
            type: 'movie',
            note: 'The TNG crew\'s final film adventure',
          ),
        ],
      ),
      
      ViewingEra(
        title: '5. 21st–32nd Century (Modern Era)',
        description: 'Sequels, spin-offs, and far future adventures',
        items: [
          ViewingItem(
            id: 'pic_all',
            title: 'Star Trek: Picard',
            type: 'series',
            subtitle: 'Seasons 1–3',
            note: 'Picard\'s retirement and return to adventure',
          ),
          ViewingItem(
            id: 'ld_all',
            title: 'Star Trek: Lower Decks',
            type: 'series',
            subtitle: 'Seasons 1–4',
            note: 'Animated comedy about lower-ranking officers',
          ),
          ViewingItem(
            id: 'pro_all',
            title: 'Star Trek: Prodigy',
            type: 'series',
            subtitle: 'Seasons 1–2',
            note: 'Animated series for younger audiences, set after Voyager',
          ),
          ViewingItem(
            id: 'dis_future',
            title: 'Star Trek: Discovery',
            type: 'series',
            subtitle: 'Seasons 3–5',
            note: 'Far future adventures in the 32nd century',
          ),
        ],
      ),
      
      ViewingEra(
        title: '6. Alternate Timeline (Kelvin Timeline)',
        description: 'The reboot movie trilogy in an alternate timeline',
        items: [
          ViewingItem(
            id: 'st09',
            title: 'Star Trek (2009)',
            type: 'movie',
            note: 'Young Kirk and Spock in an alternate timeline',
          ),
          ViewingItem(
            id: 'stid',
            title: 'Star Trek Into Darkness',
            type: 'movie',
            note: 'The alternate timeline\'s version of Khan',
          ),
          ViewingItem(
            id: 'stb',
            title: 'Star Trek Beyond',
            type: 'movie',
            note: 'The crew faces Krall\'s revenge plot',
          ),
        ],
      ),
    ];
  }
}