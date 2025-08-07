class CardData {
  final String uid;
  final String backgroundImage;
  final String profileImage;
  final String name;
  final String subtitle;
  final String location;
  final String description;
  final List<CardData>? collection;

  const CardData({
    required this.uid,
    required this.backgroundImage,
    required this.profileImage,
    required this.name,
    required this.subtitle,
    required this.location,
    required this.description,
    this.collection,
  });

  /// Clones the current card with a collection that includes itself + others
  CardData withCollection(List<CardData> others) {
    return CardData(
      uid: uid,
      backgroundImage: backgroundImage,
      profileImage: profileImage,
      name: name,
      subtitle: subtitle,
      location: location,
      description: description,
      collection: [this, ...others],
    );
  }
}

final List<CardData> userCards = [
  CardData(
    uid: 'emma-amazon-forest',
    backgroundImage: 'assets/pictures/nature/nat1.jpg',
    profileImage: 'assets/pictures/profile/profile1.jpg',
    name: 'Emma Wallace',
    subtitle: '13 Photos',
    location: 'Amazon Rainforest',
    description:
        'A nature enthusiast capturing the serenity of the Amazon’s deep forests.',
  ).withCollection([
    CardData(
      uid: 'emma-canopy',
      backgroundImage: 'assets/pictures/nature/nat6.jpg',
      profileImage: 'assets/pictures/profile/profile1.jpg',
      name: 'Emma Wallace',
      subtitle: '4 Photos',
      location: 'Amazon Canopy',
      description: 'Aerial views above the forest canopy.',
    ),
    CardData(
      uid: 'emma-wildlife',
      backgroundImage: 'assets/pictures/nature/nat7.jpg',
      profileImage: 'assets/pictures/profile/profile1.jpg',
      name: 'Emma Wallace',
      subtitle: '4 Photos',
      location: 'Amazon Wildlife',
      description: 'Capturing the creatures of the rainforest.',
    ),
  ]),

  CardData(
    uid: 'jason-lee-mountain',
    backgroundImage: 'assets/pictures/nature/nat2.jpg',
    profileImage: 'assets/pictures/profile/profile2.jpg',
    name: 'Jason Lee',
    subtitle: '22 Photos',
    location: 'Rocky Mountains, USA',
    description:
        'Photographer and climber capturing breathtaking views from mountain summits.',
  ).withCollection([
    CardData(
      uid: 'jason-glacier-lake',
      backgroundImage: 'assets/pictures/nature/nat10.jpg',
      profileImage: 'assets/pictures/profile/profile2.jpg',
      name: 'Jason Lee',
      subtitle: '7 Photos',
      location: 'Glacier Lake',
      description: 'Serenity captured by the icy lake banks.',
    ),
    CardData(
      uid: 'jason-fog-valley',
      backgroundImage: 'assets/pictures/nature/nat11.jpg',
      profileImage: 'assets/pictures/profile/profile2.jpg',
      name: 'Jason Lee',
      subtitle: '7 Photos',
      location: 'Fog Valley',
      description: 'Eerie beauty of fog-filled valleys at dawn.',
    ),
  ]),

  CardData(
    uid: 'amara-savannah-sunset',
    backgroundImage: 'assets/pictures/nature/nat3.jpg',
    profileImage: 'assets/pictures/profile/profile3.jpg',
    name: 'Amara Okafor',
    subtitle: '18 Photos',
    location: 'Savannah, Kenya',
    description: 'Wildlife photographer chasing golden hour magic.',
  ).withCollection([
    CardData(
      uid: 'amara-elephant-herd',
      backgroundImage: 'assets/pictures/nature/nat8.jpg',
      profileImage: 'assets/pictures/profile/profile3.jpg',
      name: 'Amara Okafor',
      subtitle: '6 Photos',
      location: 'Savannah',
      description: 'Documenting the majestic elephant herds.',
    ),
    CardData(
      uid: 'amara-lioness-hunt',
      backgroundImage: 'assets/pictures/nature/nat9.jpg',
      profileImage: 'assets/pictures/profile/profile3.jpg',
      name: 'Amara Okafor',
      subtitle: '6 Photos',
      location: 'Savannah',
      description: 'Moments from a lioness’ early morning hunt.',
    ),
  ]),

  CardData(
    uid: 'liam-glacier-expedition',
    backgroundImage: 'assets/pictures/nature/nat4.jpg',
    profileImage: 'assets/pictures/profile/profile4.jpg',
    name: 'Liam Chen',
    subtitle: '16 Photos',
    location: 'Patagonia, Argentina',
    description: 'Exploring frozen landscapes and icy frontiers.',
  ).withCollection([
    CardData(
      uid: 'liam-ice-cave',
      backgroundImage: 'assets/pictures/nature/nat12.jpg',
      profileImage: 'assets/pictures/profile/profile4.jpg',
      name: 'Liam Chen',
      subtitle: '5 Photos',
      location: 'Patagonia',
      description: 'Inside the mesmerizing blue ice caves.',
    ),
    CardData(
      uid: 'liam-mountain-range',
      backgroundImage: 'assets/pictures/nature/nat13.jpg',
      profileImage: 'assets/pictures/profile/profile4.jpg',
      name: 'Liam Chen',
      subtitle: '5 Photos',
      location: 'Patagonia',
      description: 'Snow-capped peaks under sunset hues.',
    ),
  ]),

  CardData(
    uid: 'sophia-kim-canyon',
    backgroundImage: 'assets/pictures/nature/nat5.jpg',
    profileImage: 'assets/pictures/profile/profile5.jpg',
    name: 'Sophia Kim',
    subtitle: '27 Photos',
    location: 'Grand Canyon, USA',
    description: 'Adventurer and visual storyteller across vast terrains.',
  ).withCollection([
    CardData(
      uid: 'sophia-canyon-light',
      backgroundImage: 'assets/pictures/nature/nat14.jpg',
      profileImage: 'assets/pictures/profile/profile5.jpg',
      name: 'Sophia Kim',
      subtitle: '9 Photos',
      location: 'Grand Canyon',
      description: 'Golden light beaming through canyon walls.',
    ),
    CardData(
      uid: 'sophia-river-trail',
      backgroundImage: 'assets/pictures/nature/nat15.jpg',
      profileImage: 'assets/pictures/profile/profile5.jpg',
      name: 'Sophia Kim',
      subtitle: '9 Photos',
      location: 'Grand Canyon',
      description: 'A hike along the winding river trail.',
    ),
  ]),
];
