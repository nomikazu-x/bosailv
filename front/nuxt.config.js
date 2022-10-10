import colors from 'vuetify/es5/util/colors'
import commonConfig from './config/common.js'

const environment = process.env.NODE_ENV || 'development'
const envConfig = require(`./config/${environment}.js`)

export default {
  publicRuntimeConfig: Object.assign(envConfig, commonConfig),

  ssr: false,
  /*
  ** Headers of the page
  */
  head: {
    htmlAttrs: { lang: 'ja' },
    titleTemplate: '%s | Bosai Lv',
    title: 'Bosai Lv',
    meta: [
      { charset: 'utf-8' },
      { name: 'viewport', content: 'width=device-width, initial-scale=1' },
      { hid: 'description', name: 'description', content: 'あなたの防災レベルはいくつ？' }
    ],
    link: [
      { rel: 'icon', type: 'image/x-icon', href: '/favicon.ico' },
      { rel: 'stylesheet', href: 'https://fonts.googleapis.com/css?family=Marck+Script' }
    ]
  },
  /*
  ** Customize the progress-bar color
  */
  loading: { color: '#fff' },
  /*
  ** Global CSS
  */
  css: [{
    src: '~/assets/scss/app.scss', lang: 'scss'
  }],
  /*
   ** Style Resources configuration
   */
  styleResources: {
    scss: ['~/assets/scss/variable.scss', '~/assets/scss/functions/**.scss']
  },
  /*
  ** Plugins to load before mounting the App
  */
  plugins: [
    'plugins/axios',
    'plugins/utils',
    { src: '~/plugins/vue-quill-editor', mode: 'client' },
    { src: '~/plugins/vue2-google-maps.js' }
  ],

  // Auto import components: https://go.nuxtjs.dev/config-components
  // components: [
  //   {
  //     path: '@/components/',
  //     pathPrefix: false
  //   }
  // ],
  /*
  ** Nuxt.js dev-modules
  */
  buildModules: [
    // Doc: https://github.com/nuxt-community/eslint-module
    '@nuxtjs/eslint-module',
    '@nuxtjs/vuetify',
    '@nuxtjs/style-resources'
  ],
  /*
  ** Nuxt.js modules
  */
  modules: [
    '@nuxtjs/i18n',
    '@nuxtjs/axios',
    '@nuxtjs/auth',
    '@nuxtjs/toast',
    '@nuxtjs/pwa'
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
          info: '#117768',
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
    duration: 3000,
    theme: 'outline',
    closeOnSwipe: true
  },

  // PWA module configuration: https://go.nuxtjs.dev/pwa
  pwa: {
    manifest: {
      name: 'Bosai Lv|あなたの防災レベルはいくつ？',
      lang: 'ja',
      short_name: 'Bosai Lv',
      title: 'Bosai Lv',
      'og:title': 'Bosai Lv',
      description: 'あなたの防災レベルはいくつ？',
      'og:description': 'あなたの防災レベルはいくつ？'
    }
  },

  auth: {
    redirect: {
      login: commonConfig.authRedirectSignInURL, // ログインURL
      logout: commonConfig.authRedirectLogOutURL, // ログアウト後の遷移先
      callback: false,
      home: false
      // home: commonConfig.authRedirectHomeURL // ログイン後の遷移先URL
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
          login: { url: envConfig.apiBaseURL + commonConfig.authSignInURL, method: 'post' },
          logout: { url: envConfig.apiBaseURL + commonConfig.authSignOutURL, method: 'post' },
          user: { url: envConfig.apiBaseURL + commonConfig.authUserURL, method: 'get' }
        }
      }
    }
  },
  /*
  ** Build configuration
  */
  build: {
    babel: {
      plugins: [
        ['@babel/plugin-proposal-private-methods', { loose: true }]
      ]
    },
    transpile: [/^vue2-google-maps($|\/)/]
  }
}
