const String APP_NAME = "Eastside C3";

// Bottom navigation names
const String PAGE_TWO = 'Calender';
const String PAGE_THREE = 'Sermons';
const String PAGE_FOUR = 'Find us';

// Information about the location, time of services, message, etc.
const String ADDRESS = '269 Hills Road\nMairehau';
const String TIME_OF_SERVICE = 'Sunday: 10AM & 6PM';

const String SERVICE_MESSAGE_ONE =
    "WELCOME\nIf you're new, you're not alone! There are new people who join our church each week. We think this is a great family to be part of and we hope that you feel right at home.  Here are the some great ways to get involved at church";
const String SERVICE_MESSAGE_TWO =
    "WHAT TO EXPECT ON SUNDAY\nAnyone and everyone is welcome at our Sunday services! There is no dress code --just wear whatever you feel comfortable in. We have kids programmes for ages 0-12 yr olds. The style of worship is modern and upbeat and one of our pastors will share a 30 minute message from the Bible. Stay afterwards for a cuppa and meet some new people.";

const String CREATED_FOR = 'C3 Church\nEastside, Christchurch\nNew Zealand';

const String WEBSITE = 'http://c3chch.org';
const String PHONE_NUMBER = '+6433850170';
const String EMAIL = 'office@c3chch.org';

const String PODCAST = 'https://c3churchchch.podbean.com/feed.xml';

const String FACEBOOK = 'https://www.facebook.com/eastsidec3/';
const String TWITTER = 'https://twitter.com/c3christchurch';
const String INSTAGRAM = 'https://www.instagram.com/c3chch/';

// Exact location of the facility. For locating via map service (Google/Apple)
const double LAT = -43.5029809;
const double LON = 172.649236;

const String GOOGLE_MAP_URL = 'https://goo.gl/maps/YdgaWWT8NCo';
const String APPLE_MAP_URL = 'https://maps.apple.com/?sll=$LAT,$LON';

// Misc App information
const String PRIVACY_POLICY =
    'C3 Church Eastside and the App Developer do not collect personal information. No data is stored by C3 Eastside or the App Developer. This app does/will make connections to external services for retrieval of relevant data. These services are, but not limited to, Google, Firebase, and PodBean. C3 Eastside or the App Developer have no connection with these service providers.';

// Misc images
const String SERVICE_IMG_URL = 'https://via.placeholder.com/2000x1500';
const String GET_IN_TOUCH_IMG_URL = 'https://via.placeholder.com/2000x1500';
const String LOCATION_IMG_URL = 'assets/placeholder.png';
const String PODCAST_IMG_URL = 'assets/itunes-thumb.jpg';

// Facebook Graph API url

const String FACEBOOK_URL =
    "https://graph.facebook.com/v6.0/eastsidec3?fields=";

const String FACEBOOK_POST_URL = FACEBOOK_URL +
    'posts{permalink_url,created_time,full_picture,id,message,comments{id,created_time,message}}';

const String FACEBOOK_EVENT_URL = FACEBOOK_URL + "events";
