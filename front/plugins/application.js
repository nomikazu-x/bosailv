import Loading from '~/components/Loading.vue'
import Processing from '~/components/Processing.vue'
import Message from '~/components/Message.vue'

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
      this.$toasted.info('ログインしてください。')
      this.$auth.redirect('login') // Tips: ログイン後、元のページに戻す
    },
    redirectAlreadyAuth () {
      this.$toasted.info('既にログインしています。')
      this.$router.push({ path: '/' })
    },
    redirectSuccess (alert, notice) {
      this.$toasted.error(alert)
      this.$toasted.info(notice)
      this.$router.push({ path: '/' })
    },
    redirectSignIn (alert, notice) {
      this.$router.push({ path: '/users/sign_in', query: { alert, notice } })
    },
    async signOut (message = 'ログインしてください。', path = null, alert = null, notice = null) {
      try {
        await this.$auth.logout()
      } catch (error) {
        this.$toasted.error(this.$t(error.response == null ? '通信に失敗しました。しばらく時間をあけてから、やり直してください。' : '通信エラーが発生しました。しばらく時間をあけてから、やり直してください。'))
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
        this.$toasted.info(message)
      }
      if (path !== null) {
        this.$router.push({ path, query: { alert, notice } })
      }
    }
  }
}
