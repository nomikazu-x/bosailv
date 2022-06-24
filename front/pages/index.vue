<template>
  <AppTemplate
    :genres="genres"
    :info="info"
    :articles="articles"
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
  name: 'Index',
  mixins: [Application],
  data () {
    return {
      genres: null,
      page: 1,
      info: null,
      articles: null
    }
  },
  async created () {
    await this.onPagination(this.page)

    await this.$axios.get(this.$config.apiBaseURL + this.$config.genresUrl)
      .then((response) => {
        if (response.data == null) {
          this.$toasted.error(this.$t('system.error'))
          this.genres = null
        } else {
          this.genres = response.data.genres
        }
      },
      (error) => {
        this.$toasted.error(this.$t(error.response == null ? 'network.failure' : 'network.error'))
      })

    await this.$axios.get(this.$config.apiBaseURL + this.$config.articlesUrl, {
      params: { famous: true }
    })
      .then((response) => {
        if (response.data == null || response.data.article == null) {
          this.$toasted.error(this.$t('system.error'))
          return this.$router.push({ path: '/' })
        } else {
          this.famousArticles = response.data.articles
        }
      },
      (error) => {
        this.$toasted.error(this.$t(error.response == null ? 'network.failure' : 'network.error'))
        return this.$router.push({ path: '/' })
      })

    this.loading = false
    this.processing = false
  },

  methods: {
    async onPagination (page) {
      this.processing = true

      await this.$axios.get(this.$config.apiBaseURL + this.$config.articlesUrl, {
        params: { page }
      })
        .then((response) => {
          if (response.data == null || response.data.article == null) {
            this.$toasted.error(this.$t('system.error'))
            if (this.info == null) {
              return this.$router.push({ path: '/' })
            }
            this.page = this.info.current_page
          } else {
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
