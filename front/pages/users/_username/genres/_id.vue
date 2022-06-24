<template>
  <UsernameGenresIdTemplate
    :can-action="canAction"
    :current-username="currentUsername"
    :user="user"
    :genre="genre"
    :info="info"
    :articles="articles"
    :required-point="requiredPoint"
    :processing="processing"
    :loading="loading"
    :alert="alert"
    :notice="notice"
    @pagination="onPagination"
  />
</template>

<script>
import Application from '~/plugins/application.js'

export default {
  name: 'UsersId',
  mixins: [Application],

  data () {
    return {
      page: 1,
      user: null,
      info: null,
      articles: null,
      favoriteArticles: null,
      genre: null,
      requiredPoint: 0
    }
  },
  computed: {
    authUsername () {
      return this.$auth.user.username
    },
    canAction () {
      return this.$auth.loggedIn
        ? this.currentUsername === this.authUsername
        : false
    },
    currentUsername () {
      return this.$route.params.username
    }
  },
  async created () {
    try {
      await this.$auth.fetchUser()
    } catch (error) {
      if (error.response == null) {
        this.$toasted.error(this.$t('network.failure'))
      } else if (error.response.status === 401) {
        return this.signOut()
      } else {
        this.$toasted.error(this.$t('network.error'))
      }
      return this.$router.push({ path: '/' })
    }

    if (!this.$auth.loggedIn) {
      return this.redirectAuth()
    }

    await this.$axios.get(this.$config.apiBaseURL + this.$config.userShowUrl.replace('_username', this.currentUsername))
      .then((response) => {
        if (response.data == null) {
          this.$toasted.error(this.$t('system.error'))
          return this.$router.push({ path: '/' })
        } else {
          this.user = response.data.user
          this.requiredPoint = response.data.required_point
        }
      },
      (error) => {
        if (error.response == null) {
          this.$toasted.error(this.$t('network.failure'))
        } else if (error.response.status === 401) {
          return this.signOut()
        } else {
          this.$toasted.error(this.$t('network.error'))
        }
        return this.$router.push({ path: '/' })
      })

    await this.onPagination(this.page)
    this.processing = false
    this.loading = false
  },
  methods: {
    async onPagination (page) {
      this.processing = true
      await this.$axios.get(this.$config.apiBaseURL + this.$config.userGenreArticlesUrl.replace('_username', this.currentUsername).replace('_id', this.$route.params.id), {
        params: { page }
      })
        .then((response) => {
          if (response.data == null) {
            this.$toasted.error(this.$t('system.error'))
            if (this.info == null) {
              return this.$router.push({ path: '/' })
            }
            this.page = this.info.current_page
          } else {
            this.genre = response.data.genre
            this.info = response.data.article
            this.articles = response.data.articles
          }
        },
        (error) => {
          this.$toasted.error(this.$t(error.response == null ? 'network.failure' : 'network.error'))
          if (this.info == null) {
            return this.$router.push({ path: '/' })
          }
          this.page = this.info.current_page
        })

      this.processing = false
    }
  }
}
</script>
