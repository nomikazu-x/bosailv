<template>
  <div>
    <OneColumnContainer v-if="!success" class="pos-relative" fluid>
      <TheLoading v-if="loading" />
      <TheMessage v-if="!loading" :alert="alert" :notice="notice" />

      <v-row v-if="!loading" justify="center">
        <v-col cols="12" sm="10" md="10">
          <ArticleNewCard
            :processing="processing"
            @article-create="onArticleCreate"
          />
        </v-col>
      </v-row>
    </OneColumnContainer>
    <ArticleCreateSuccessCard
      v-else
      :article="article"
    />
  </div>
</template>

<script>
import Application from '~/plugins/application.js'

export default {
  name: 'ArticlesNew',

  mixins: [Application],
  data () {
    return {
      errors: null,
      success: false,
      article: null
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
      articleInfo.selectedGenres.forEach((genre) => {
        formData.append('article[genre_ids][]', genre)
      })

      console.log(formData)

      await this.$axios.post(this.$config.apiBaseURL + this.$config.articleCreateUrl, formData)
        .then((response) => {
          if (response.data == null) {
            this.$toasted.error(this.$t('system.error'))
          } else {
            this.$store.commit('user/setPoint', response.data.article.user, { root: true })
            this.$store.commit('user/setRequiredPoint', response.data.required_point, { root: true })
            this.$store.commit('articles/addArticles', response.data.article, { root: true })
            this.$toasted.error(response.data.alert)
            this.$toasted.info(response.data.notice)
            this.success = true
            this.article = response.data.article
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
