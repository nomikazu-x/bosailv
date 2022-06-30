<template>
  <ArticlesIdTemplate
    :user="user"
    :article="article"
    :article-comments="articleComments"
    :likers="likers"
    :errors="errors"
    :processing="processing"
    :loading="loading"
    :alert="alert"
    :notice="notice"
    @article-delete="onArticleDelete"
  />
</template>

<script>
import { mapGetters } from 'vuex'
import Application from '~/plugins/application.js'

export default {
  name: 'ArticlesId',

  mixins: [Application],

  data () {
    return {
      user: null,
      errors: null,
      content: ''
    }
  },
  computed: {
    ...mapGetters({
      article: 'articles/article',
      articleComments: 'articleComments/articleComments',
      likers: 'articles/likers'
    })
  },

  async created () {
    await this.$axios.get(this.$config.apiBaseURL + this.$config.articleDetailUrl.replace('_id', this.$route.params.id))
      .then((response) => {
        if (response.data == null) {
          this.$toasted.error(this.$t('system.error'))
          return this.$router.push({ path: '/' })
        }
        this.user = response.data.article.user
        this.$store.commit('articles/setArticle', response.data.article, { root: true })
        this.$store.commit('articleComments/setArticleComments', response.data.article.comments, { root: true })
        this.$store.commit('articles/setLikers', response.data.article.likers, { root: true })
      },
      (error) => {
        if (error.response == null) {
          this.$toasted.error(this.$t('network.failure'))
          return this.$router.push({ path: '/' })
        } else if (error.response.data == null && error.response.status !== 404) {
          this.$toasted.error(this.$t('network.error'))
          return this.$router.push({ path: '/' })
        } else {
          if (error.response.data != null) {
            this.$toasted.error(error.response.data.alert)
            this.$toasted.info(error.response.data.notice)
          }
          return this.$nuxt.error({ statusCode: error.response.status })
        }
      })

    this.processing = false
    this.loading = false
  },

  methods: {
    async onArticleDelete (articleId) {
      this.processing = true

      await this.$axios.post(this.$config.apiBaseURL + this.$config.articleDeleteUrl.replace('_id', this.$route.params.id))
        .then((response) => {
          if (response.data == null) {
            this.$toasted.error(this.$t('system.error'))
          } else {
            this.$store.commit('user/setPoint', response.data.article.user, { root: true })
            this.$store.commit('user/setRequiredPoint', response.data.required_exp, { root: true })
            this.$store.commit('articles/deleteArticle', articleId, { root: true })
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
            this.$toasted.error(error.response.data.alert)
            this.$toasted.info(error.response.data.notice)
          }
        })

      this.processing = false
    }
  }
}
</script>
