import Loading from '~/components/organisms/items/Loading.vue'
import Processing from '~/components/organisms/items/Processing.vue'
import Message from '~/components/organisms/items/Message.vue'

export default {
  components: {
    Loading,
    Processing,
    Message
  },

  data () {
    return {
      loading: true,
      processing: true,
      alert: null,
      notice: null
    }
  },

  methods: {
    setQueryMessage () {
      this.alert = this.$route.query.alert
      this.notice = this.$route.query.notice
      this.$router.push({ path: this.$route.path }) // Tips: URLパラメータを消す為
    },
    redirectAuth () {
      this.$toasted.info(this.$t('auth.unauthenticated'))
      this.$auth.redirect('login') // Tips: ログイン後、元のページに戻す
    },
    redirectAlreadyAuth () {
      this.$toasted.info(this.$t('auth.already_authenticated'))
      this.$router.push({ path: '/' })
    },
    redirectSuccess (alert, notice) {
      this.$toasted.error(alert)
      this.$toasted.info(notice)
      this.$router.push({ path: '/' })
    },
    redirectSignIn (alert, notice) {
      this.$toasted.error(alert)
      this.$toasted.info(notice)
      this.$router.push({ path: '/signin', query: { alert, notice } })
    },
    async signOut (message = 'auth.unauthenticated', path = null, alert = null, notice = null) {
      try {
        await this.$auth.logout()
      } catch (error) {
        this.$toasted.error(this.$t(error.response == null ? 'network.failure' : 'network.error'))
      }
      // Devise Token Auth
      if (localStorage.getItem('token-type') === 'Bearer' && localStorage.getItem('access-token')) {
        localStorage.removeItem('token-type')
        localStorage.removeItem('uid')
        localStorage.removeItem('client')
        localStorage.removeItem('access-token')
        localStorage.removeItem('expiry')
      }

      if (message !== null) {
        this.$toasted.info(this.$t(message))
      }
      if (path !== null) {
        this.$router.push({ path, query: { alert, notice } })
      }
    }
  }
}
