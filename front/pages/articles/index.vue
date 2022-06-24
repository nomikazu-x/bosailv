<template>
  <ArticlesTemplate
    :articles="articles"
    :info="info"
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
  name: 'Articles',

  mixins: [Application],

  data () {
    return {
      page: 1,
      info: null,
      articles: null
    }
  },

  async created () {
    await this.onPagination(this.page)
    this.loading = false
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
