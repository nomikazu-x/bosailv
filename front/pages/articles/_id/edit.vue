<template>
  <div>
    <OneColumnContainer v-if="!success" class="pos-relative" fluid>
      <TheLoading v-if="loading" />
      <TheMessage v-if="!loading" :alert="alert" :notice="notice" />

      <v-row v-if="!loading" justify="center">
        <v-col cols="12" sm="10" md="10">
          <ArticleEditCard
            :article="article"
            :processing="processing"
            @article-update="onArticleUpdate"
          />
        </v-col>
      </v-row>
    </OneColumnContainer>

    <ArticleCreateSuccessCard
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

      const params = new FormData()
      params.append('article[title]', articleInfo.title)
      params.append('article[content]', articleInfo.content)
      if (articleInfo.thumbnail) {
        params.append('article[thumbnail]', articleInfo.thumbnail)
      }
      if (articleInfo.selectedGenres) {
        articleInfo.selectedGenres.forEach((genre) => {
          params.append('article[genre_ids][]', genre)
        })
      }

      await this.$axios.post(this.$config.apiBaseURL + this.$config.articleUpdateUrl.replace('_id', this.$route.params.id), params)
        .then((response) => {
          if (response.data == null) {
            this.$toasted.error(this.$t('system.error'))
          } else {
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
