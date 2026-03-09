// ─── Location ────────────────────────────────────────────────────────────────────────────────
// null = use browser geolocation (weather.js will prompt the user)
const LOCATION = null;

// ─── Search engines ───────────────────────────────────────────────────────────
const ENGINES = [
  {
    id:    'google',
    label: 'Google',
    icon:  'icons/google.png',
    url:   'https://www.google.com/search?q=',
  },
  {
    id:    'ddg',
    label: 'DuckDuckGo',
    icon:  'icons/duckduckgo.png',
    url:   'https://duckduckgo.com/?q=',
  },
  {
    id:    'bing',
    label: 'Bing',
    icon:  'icons/bing.png',
    url:   'https://www.bing.com/search?q=',
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
      { label: 'Gmail',     href: 'https://mail.google.com',      icon: 'icons/gmail.png' },
      { label: 'Moodle',    href: 'https://moodle.org',           icon: 'icons/moodle.png',    fallback: { letter: 'M', color: '#ff8c00' } },
      { label: 'Classroom', href: 'https://classroom.google.com', icon: 'icons/classroom.png' },
      { label: 'Drive',     href: 'https://drive.google.com',     icon: 'icons/drive.png' },
    ],
  },
  {
    title: 'AI',
    links: [
      { label: 'Claude',      href: 'https://claude.ai',            icon: 'icons/claude.png',      fallback: { letter: '✦', color: '#d4a96a' } },
      { label: 'Gemini',      href: 'https://gemini.google.com',    icon: 'icons/gemini.png' },
      { label: 'ChatGPT',     href: 'https://chat.openai.com',      icon: 'icons/chatgpt.png',     fallback: { letter: '⬡', color: '#10a37f' } },
      { label: 'Perplexity',  href: 'https://www.perplexity.ai',    icon: 'icons/perplexity.png' },
    ],
  },
  {
    title: 'Social',
    links: [
      { label: 'GitHub',    href: 'https://github.com',         icon: 'icons/github.png' },
      { label: 'Reddit',    href: 'https://reddit.com',         icon: 'icons/reddit.png' },
      { label: 'Discord',   href: 'https://discord.com/app',    icon: 'icons/discord.png' },
      { label: 'WhatsApp',  href: 'https://web.whatsapp.com',   icon: 'icons/whatsapp.png', fallback: { letter: '💬', color: '#25d366' } },
    ],
  },
  {
    title: 'Misc',
    links: [
      { label: 'Zusqii',     href: 'https://github.com/zusqii',                         icon: 'icons/zusqii.png',   fallback: { letter: 'Z', color: '#7c6af0' } },
      { label: 'LinuxPorn',  href: 'https://www.reddit.com/r/unixporn/',                icon: 'icons/reddit.png' },
      { label: 'Hyprland',   href: 'https://www.reddit.com/r/hyprland/',                icon: 'icons/hyprland.png', fallback: { letter: 'H', color: '#58a6ff' } },
      { label: 'Spotify',    href: 'https://open.spotify.com',                          icon: 'icons/spotify.png' },
    ],
  },
];
