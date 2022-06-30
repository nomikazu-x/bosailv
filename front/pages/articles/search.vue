<template>
  <ArticlesSearchTemplate
    :info="info"
    :articles="articles"
    :processing="processing"
    :loading="loading"
    :alert="alert"
    :notice="notice"
    @search-article-pagination="onSearchArticlePagination"
  />
</template>

<script>
import Application from '~/plugins/application.js'

export default {
  name: 'ArticlesSearch',

  mixins: [Application],

  data () {
    return {
      page: 1,
      info: null,
      articles: null
    }
  },

  created () {
    this.onSearchArticlePagination(this.page)
    this.processing = false
    this.loading = false
  },

  methods: {
    async onSearchArticlePagination (searchInfo) {
      this.processing = true

      await this.$axios.get(this.$config.apiBaseURL + this.$config.articlesSearchUrl, {
        params: {
          page: searchInfo.page,
          keyword: searchInfo.keyword,
          genre_ids: searchInfo.selectedGenres
        }
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
