<template>
  <ArticlesTemplate
    :article-info="articleInfo"
    :articles="articles"
    :famous-article-info="famousArticleInfo"
    :famous-articles="famousArticles"
    :processing="processing"
    :loading="loading"
    :alert="alert"
    :notice="notice"
    @article-pagination="onArticlePagination"
    @famous-article-pagination="onFamousArticlePagination"
  />
</template>

<script>
import Application from '~/plugins/application.js'

export default {
  name: 'Articles',

  mixins: [Application],

  data () {
    return {
      articlePage: 1,
      famousArticlePage: 1,
      articleInfo: null,
      famousArticleInfo: null,
      articles: null,
      famousArticles: null
    }
  },

  async created () {
    await this.onArticlePagination(this.articlePage)
    await this.onFamousArticlePagination(this.famousArticlePage)
    this.loading = false
  },

  methods: {
    async onArticlePagination (articlePage) {
      this.processing = true
      await this.$axios.get(this.$config.apiBaseURL + this.$config.articlesUrl, {
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

    async onFamousArticlePagination (famousArticlePage) {
      this.processing = true
      await this.$axios.get(this.$config.apiBaseURL + this.$config.articlesUrl, {
        params: { page: famousArticlePage, famous: true }
      })
        .then((response) => {
          if (response.data == null) {
            this.$toasted.error(this.$t('system.error'))
            if (this.famousArticleInfo == null) {
              return this.$router.push({ path: '/' })
            }
            this.famousArticlePage = this.famousArticleInfo.current_page
          } else {
            this.famousArticleInfo = response.data.article
            this.famousArticles = response.data.articles
          }
        },
        (error) => {
          this.$toasted.error(this.$t(error.response == null ? 'network.failure' : 'network.error'))
          if (this.famousArticleInfo == null) {
            return this.$router.push({ path: '/' })
          }
          this.famousArticlePage = this.famousArticleInfo.current_page
        })

      this.processing = false
    }
  }
}
</script>
