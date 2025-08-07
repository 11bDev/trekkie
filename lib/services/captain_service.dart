class CaptainInfo {
  final String name;
  final String rank;
  final String actor;
  final String description;

  CaptainInfo({
    required this.name,
    required this.rank,
    required this.actor,
    required this.description,
  });
}

class CaptainService {
  static final Map<String, CaptainInfo> _captains = {
    'archer': CaptainInfo(
      name: 'Jonathan Archer',
      rank: 'Captain',
      actor: 'Scott Bakula',
      description: 'First captain of the Enterprise NX-01',
    ),
    'pike': CaptainInfo(
      name: 'Christopher Pike',
      rank: 'Captain',
      actor: 'Anson Mount',
      description: 'Captain of the Enterprise before Kirk',
    ),
    'kirk': CaptainInfo(
      name: 'James T. Kirk',
      rank: 'Captain',
      actor: 'William Shatner',
      description: 'Legendary captain of the Enterprise',
    ),
    'picard': CaptainInfo(
      name: 'Jean-Luc Picard',
      rank: 'Captain',
      actor: 'Patrick Stewart',
      description: 'Captain of the Enterprise-D and E',
    ),
    'sisko': CaptainInfo(
      name: 'Benjamin Sisko',
      rank: 'Captain',
      actor: 'Avery Brooks',
      description: 'Commander/Captain of Deep Space Nine',
    ),
    'janeway': CaptainInfo(
      name: 'Kathryn Janeway',
      rank: 'Captain',
      actor: 'Kate Mulgrew',
      description: 'Captain of Voyager in the Delta Quadrant',
    ),
    'burnham': CaptainInfo(
      name: 'Michael Burnham',
      rank: 'Captain',
      actor: 'Sonequa Martin-Green',
      description: 'Captain of the Discovery',
    ),
    'freeman': CaptainInfo(
      name: 'Carol Freeman',
      rank: 'Captain',
      actor: 'Dawnn Lewis',
      description: 'Captain of the USS Cerritos',
    ),
    'dal': CaptainInfo(
      name: 'Dal R\'El',
      rank: 'Acting Captain',
      actor: 'Brett Gray',
      description: 'Young captain of the USS Protostar',
    ),
    'kirk_kelvin': CaptainInfo(
      name: 'James T. Kirk',
      rank: 'Captain',
      actor: 'Chris Pine',
      description: 'Kirk in the alternate Kelvin timeline',
    ),
  };

  static final Map<String, String> _showCaptainMapping = {
    // Series
    'ent': 'archer',
    'dis_early': 'burnham',
    'dis_future': 'burnham',
    'snw': 'pike',
    'tos': 'kirk',
    'tng': 'picard',
    'ds9': 'sisko',
    'voy': 'janeway',
    'ld': 'freeman',
    'pro': 'dal',
    'pic': 'picard',
    
    // Movies - TOS Era
    'tmp': 'kirk',
    'twok': 'kirk',
    'tsfs': 'kirk',
    'tvh': 'kirk',
    'tff': 'kirk',
    'tuc': 'kirk',
    
    // Movies - TNG Era
    'gen': 'picard', // Though Kirk is also in it, Picard is the main character
    'fc': 'picard',
    'ins': 'picard',
    'nem': 'picard',
    
    // Movies - Kelvin Timeline
    'st09': 'kirk_kelvin',
    'stid': 'kirk_kelvin',
    'stb': 'kirk_kelvin',
  };

  static CaptainInfo? getCaptainForShow(String showId) {
    final captainKey = _showCaptainMapping[showId];
    if (captainKey != null) {
      return _captains[captainKey];
    }
    return null;
  }

  static CaptainInfo? getCaptainByKey(String key) {
    return _captains[key];
  }

  static List<CaptainInfo> getAllCaptains() {
    return _captains.values.toList();
  }
}