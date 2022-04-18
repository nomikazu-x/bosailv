import colors from 'vuetify/es5/util/colors'

export default {
  ssr: false,
  /*
  ** Headers of the page
  */
  head: {
    titleTemplate: '%s - ' + process.env.npm_package_name,
    title: process.env.npm_package_name || '',
    meta: [
      { charset: 'utf-8' },
      { name: 'viewport', content: 'width=device-width, initial-scale=1' },
      { hid: 'description', name: 'description', content: process.env.npm_package_description || '' }
    ],
    link: [
      { rel: 'icon', type: 'image/x-icon', href: '/favicon.ico' }
    ]
  },
  /*
  ** Customize the progress-bar color
  */
  loading: { color: '#fff' },
  /*
  ** Global CSS
  */
  css: [
  ],
  /*
  ** Plugins to load before mounting the App
  */
  plugins: [
    'plugins/axios'
  ],

  // Auto import components: https://go.nuxtjs.dev/config-components
  components: true,
  /*
  ** Nuxt.js dev-modules
  */
  buildModules: [
    // Doc: https://github.com/nuxt-community/eslint-module
    '@nuxtjs/eslint-module',
    '@nuxtjs/vuetify'
  ],
  /*
  ** Nuxt.js modules
  */
  modules: [
    '@nuxtjs/i18n',
    '@nuxtjs/axios',
    '@nuxtjs/auth',
    '@nuxtjs/toast'
  ],
  /*
  ** vuetify module configuration
  ** https://github.com/nuxt-community/vuetify-module
  */
  vuetify: {
    customVariables: ['~/assets/variables.scss'],
    theme: {
      dark: false,
      themes: {
        dark: {
          primary: colors.blue.darken2,
          accent: colors.grey.darken3,
          secondary: colors.amber.darken3,
          info: colors.teal.lighten1,
          warning: colors.amber.base,
          error: colors.deepOrange.accent4,
          success: colors.green.accent3
        },
        light: {
          main_color_theme: '#0b6fab'
        }
      }
    }
  },

  // I18n module configuration: https://i18n.nuxtjs.org/
  i18n: {
    locales: [
      { code: 'ja', iso: 'ja', file: 'ja.js' }
    ],
    defaultLocale: 'ja',
    lazy: true,
    langDir: 'locales/'
  },

  toast: {
    position: 'top-right',
    duration: 3000
  },

  auth: {
    redirect: {
      login: '/users/sign_in', // ログインURL
      logout: '/', // ログアウト後の遷移先
      callback: false,
      home: '/' // ログイン後の遷移先URL
    },
    strategies: {
      local: {
        token: {
          property: 'token',
          global: true
        },
        user: {
          property: 'user'
        },
        endpoints: {
          login: { url: '/users/auth/sign_in.json', method: 'post' },
          logout: { url: '/users/auth/sign_out.json', method: 'post' },
          user: { url: '/users/auth/validate_token.json', method: 'get' }
        }
      }
    }
  },

  /*
  ** Build configuration
  */
  build: {
    /*
    ** You can extend webpack config here
    */
    extend (config, ctx) {
    }
  }
}
