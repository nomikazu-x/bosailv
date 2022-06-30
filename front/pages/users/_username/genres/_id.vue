<template>
  <UsernameGenresIdTemplate
    :can-action="canAction"
    :current-username="currentUsername"
    :user="user"
    :genre="genre"
    :article-info="articleInfo"
    :articles="articles"
    :favorite-article-info="favoriteArticleInfo"
    :favorite-articles="favoriteArticles"
    :required-point="requiredPoint"
    :processing="processing"
    :loading="loading"
    :alert="alert"
    :notice="notice"
    @article-pagination="onArticlePagination"
    @favorite-article-pagination="onFavoriteArticlePagination"
  />
</template>

<script>
import Application from '~/plugins/application.js'

export default {
  name: 'UsersUsernameGenresId',
  mixins: [Application],

  data () {
    return {
      user: null,
      articlePage: 1,
      favoriteArticlePage: 1,
      articleInfo: null,
      favoriteArticleInfo: null,
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

    await this.onArticlePagination(this.articlePage)
    await this.onFavoriteArticlePagination(this.favoriteArticlePage)
    this.processing = false
    this.loading = false
  },
  methods: {
    async onArticlePagination (articlePage) {
      this.processing = true
      await this.$axios.get(this.$config.apiBaseURL + this.$config.userGenreArticlesUrl.replace('_username', this.currentUsername).replace('_id', this.$route.params.id), {
        params: { page: articlePage }
      })
        .then((response) => {
          if (response.data == null) {
            this.$toasted.error(this.$t('system.error'))
            if (this.articleInfo == null) {
              return this.$router.push({ path: '/' })
            }
            this.articlePage = this.articleInfo.current_page
          } else {
            this.genre = response.data.genre
            this.articleInfo = response.data.article
            this.articles = response.data.articles
          }
        },
        (error) => {
          this.$toasted.error(this.$t(error.response == null ? 'network.failure' : 'network.error'))
          if (this.articleInfo == null) {
            return this.$router.push({ path: '/' })
          }
          this.articlePage = this.articleInfo.current_page
        })

      this.processing = false
    },

    async onFavoriteArticlePagination (favoriteArticlePage) {
      this.processing = true
      await this.$axios.get(this.$config.apiBaseURL + this.$config.userGenreArticlesUrl.replace('_username', this.currentUsername).replace('_id', this.$route.params.id), {
        params: { page: favoriteArticlePage, favorite: true }
      })
        .then((response) => {
          if (response.data == null) {
            this.$toasted.error(this.$t('system.error'))
            if (this.favoriteArticleInfo == null) {
              return this.$router.push({ path: '/' })
            }
            this.favoriteArticlePage = this.favoriteArticleInfo.current_page
          } else {
            this.genre = response.data.genre
            this.favoriteArticleInfo = response.data.article
            this.favoriteArticles = response.data.articles
          }
        },
        (error) => {
          this.$toasted.error(this.$t(error.response == null ? 'network.failure' : 'network.error'))
          if (this.favoriteArticleInfo == null) {
            return this.$router.push({ path: '/' })
          }
          this.favoriteArticlePage = this.favoriteArticleInfo.current_page
        })

      this.processing = false
    }
  }
}
</script>
