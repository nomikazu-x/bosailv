<template>
  <ArticleNewTemplate
    :errors="errors"
    :processing="processing"
    :loading="loading"
    :alert="alert"
    :notice="notice"
    @article-create="onArticleCreate"
  />
</template>

<script>
import Application from '~/plugins/application.js'

export default {
  name: 'ArticleNew',

  mixins: [Application],
  data () {
    return {
      errors: null
    }
  },
  created () {
    if (!this.$auth.loggedIn) {
      return this.redirectAuth()
    }
    this.processing = false
    this.loading = false
  },

  methods: {
    async onArticleCreate (articleInfo) {
      this.processing = true

      const formData = new FormData()
      formData.append('article[title]', articleInfo.title)
      formData.append('article[content]', articleInfo.content)
      formData.append('article[thumbnail]', articleInfo.thumbnail)
      articleInfo.selectedCategories.forEach((category) => {
        formData.append('article[category][]', category)
      })

      await this.$axios.post(this.$config.apiBaseURL + this.$config.articleCreateUrl, formData)
        .then((response) => {
          if (response.data == null) {
            this.$toasted.error(this.$t('system.error'))
          } else {
            this.$store.commit('user/setPoint', response.data.article.user, { root: true })
            this.$store.commit('user/setRequiredPoint', response.data.required_exp, { root: true })
            this.$store.commit('articles/addArticles', response.data.article, { root: true })
            this.$toasted.error(response.data.alert)
            this.$toasted.info(response.data.notice)
            return this.$router.push({ path: '/articles' })
          }
        },
        (error) => {
          if (error.response == null) {
            this.$toasted.error(this.$t('network.failure'))
          } else if (error.response.data == null) {
            this.$toasted.error(this.$t('network.error'))
          } else {
            this.alert = error.response.data.alert
            this.notice = error.response.data.notice
          }
        })

      this.processing = false
    }
  }
}
</script>
