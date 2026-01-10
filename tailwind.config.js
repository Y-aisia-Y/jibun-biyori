module.exports = {
  content: [
    './app/views/**/*.html.erb',
    './app/views/**/*.html.slim',  // ← Slim を使っている場合
    './app/helpers/**/*.rb',
    './app/assets/stylesheets/**/*.css',
    './app/javascript/**/*.js'
  ],
  theme: {
    extend: {},
  },
  plugins: [],
}