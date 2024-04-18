class OnboardingContents {
  String header;
  String desc;
  String image;

  OnboardingContents(
      {required this.header, required this.desc, required this.image});
}

List<OnboardingContents> contents = [
  OnboardingContents(
    header: "Youth Conference 2024",
    desc:
        "Hey! Its the time of the year again. Welcome to Calvary Chapel Youth Conference 2024! It is always exciting to work with group of leaders and worship the Lord!",
    image: "assets/scoreball.json",
  ),
  OnboardingContents(
    header: "Introducing YCSS",
    desc:
        "Designed to enhance your experience and interaction throughout the event. Track team scores and progress amongst your peers.",
    image: "assets/scoreball.json",
  ),
  OnboardingContents(
    header: "Score with Joy!",
    desc:
        "Let’s embrace each moment as an opportunity to honor the Lord with Joy! \"Worship the Lord with gladness; come before him with joyful songs. Know that the Lord is God. It is he who made us, and we are his. We are his people, The sheep of his pasture. \" -Psalm 100:2-3  ",
    image: "assets/scoreball.json",
  ),
];
