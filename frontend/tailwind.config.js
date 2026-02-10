/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    './app/**/*.{js,ts,jsx,tsx,mdx}',
    './components/**/*.{js,ts,jsx,tsx,mdx}',
  ],
  theme: {
    extend: {
      colors: {
        'maps-navy': '#1a3a5c',
        'maps-navy-light': '#2d5a87',
        'maps-blue': '#3d7ab5',
        'maps-teal': '#2a9d8f',
        'maps-teal-light': '#40c9b6',
        'maps-gold': '#e9c46a',
        'maps-coral': '#f4a261',
      },
    },
  },
  plugins: [],
};
