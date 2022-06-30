<template>
  <div>
    <ArticlesIdEditTemplate
      v-if="!success"
      :article="article"
      :errors="errors"
      :processing="processing"
      :loading="loading"
      :alert="alert"
      :notice="notice"
      @article-update="onArticleUpdate"
    />

    <ArticleCreateSuccessTemplate
      v-else
      :article="article"
      @to-edit="success = !success"
    />
  </div>
</template>

<script>
import Application from '~/plugins/application.js'

export default {
  name: 'ArticlesIdEdit',

  mixins: [Application],

  data () {
    return {
      errors: null,
      article: null,
      success: false
    }
  },

  async created () {
    if (!this.$auth.loggedIn) {
      return this.redirectAuth()
    }

    await this.$axios.get(this.$config.apiBaseURL + this.$config.articleDetailUrl.replace('_id', this.$route.params.id))
      .then((response) => {
        if (response.data == null) {
          this.$toasted.error(this.$t('system.error'))
          return this.$router.push({ path: '/' })
        } else {
          this.article = response.data.article
          console.log(this.article)
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
    this.processing = false
    this.loading = false
  },

  methods: {
    async onArticleUpdate (articleInfo) {
      this.processing = true

      const formData = new FormData()
      formData.append('article[title]', articleInfo.title)
      formData.append('article[content]', articleInfo.content)
      if (articleInfo.thumbnail) {
        formData.append('article[thumbnail]', articleInfo.thumbnail)
      }
      if (articleInfo.selectedGenres) {
        articleInfo.selectedGenres.forEach((genre) => {
          formData.append('article[genre_ids][]', genre)
        })
      }

      await this.$axios.post(this.$config.apiBaseURL + this.$config.articleUpdateUrl.replace('_id', this.$route.params.id), formData)
        .then((response) => {
          if (response.data == null) {
            this.$toasted.error(this.$t('system.error'))
          } else {
            this.$toasted.error(response.data.alert)
            this.$toasted.info(response.data.notice)
            this.article = response.data.article
            this.success = true
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
