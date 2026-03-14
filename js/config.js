// ─── Location ────────────────────────────────────────────────────────────────────────────────
// null = use browser geolocation (weather.js will prompt the user)
const LOCATION = null;

// ─── Search engines ───────────────────────────────────────────────────────────
const ENGINES = [
  {
    id:    'startpage',
    label: 'Startpage',
    icon:  'icons/startpage.png',
    url:   'https://startpage.com/?q=',
  },
  {
    id:    'ddg',
    label: 'DuckDuckGo',
    icon:  'icons/duckduckgo.png',
    url:   'https://duckduckgo.com/?q=',
  },
  {
    id:    'brave',
    label: 'Brave Search',
    icon:  'icons/brave.png',
    url:   'https://search.brave.com/search?q=',
  },
];

// ─── Link sections ────────────────────────────────────────────────────────────
// icon: path relative to index.html (put PNGs in icons/)
// Fallback shows the `fallback` letter+color if icon file not found
const LINK_SECTIONS = [
  {
    title: 'Work',
    links: [
      { label: 'Mail',     href: 'https://mail.proton.me',      icon: 'icons/proton-mail.png' },
      { label: 'Drive',     href: 'https://drive.proton.me',     icon: 'icons/proton-drive.png' },
    ],
  },
  {
    title: 'AI',
    links: [
      { label: 'Claude',      href: 'https://claude.ai',            icon: 'icons/claude.png',      fallback: { letter: '✦', color: '#d4a96a' } },
      { label: 'Lumo',      href: 'https://lumo.proton.me',    icon: 'icons/proton-lumo.png' },
    ],
  },
  {
    title: 'Social',
    links: [
      { label: 'GitHub',    href: 'https://github.com',         icon: 'icons/github.jpg' },
      { label: 'Reddit',    href: 'https://reddit.com',         icon: 'icons/reddit.png' },
    ],
  },
  {
    title: 'Misc',
    links: [
      { label: 'LinuxPorn',  href: 'https://www.reddit.com/r/unixporn/',                icon: 'icons/reddit.png' },
      { label: 'Hyprland',   href: 'https://www.reddit.com/r/hyprland/',                icon: 'icons/hyprland.png', fallback: { letter: 'H', color: '#58a6ff' } },
      { label: 'Tidal',    href: 'https://tidal.com',                          icon: 'icons/tidal.png' },
    ],
  },
];
