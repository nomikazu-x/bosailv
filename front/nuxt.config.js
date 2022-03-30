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
    '@nuxtjs/axios',
    '@nuxtjs/auth'
  ],
  /*
  ** vuetify module configuration
  ** https://github.com/nuxt-community/vuetify-module
  */
  vuetify: {
    customVariables: ['~/assets/variables.scss'],
    theme: {
      dark: true,
      themes: {
        dark: {
          primary: colors.blue.darken2,
          accent: colors.grey.darken3,
          secondary: colors.amber.darken3,
          info: colors.teal.lighten1,
          warning: colors.amber.base,
          error: colors.deepOrange.accent4,
          success: colors.green.accent3
        }
      }
    }
  },

  auth: {
    redirect: {
      login: '/login', // middleware:authを設定したURLにアクセスがあった場合のリダイレクト先
      logout: '/', // ログアウト後のリダイレクト先
      callback: false,
      home: '/' // ログイン後のリダイレクト先
     },
    strategies: {
      local: {
        endpoints: {
          // ログイン処理に関する設定
          login: { url: '/api/auth/sign_in', method: 'post',propertyName: 'access_token'}, 
          // ログアウト処理に関する設定
          logout: { url: '/api/auth/sign_out', method: 'delete' },
          // ログイン時にユーザー情報を保存するか
          user: false 
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
