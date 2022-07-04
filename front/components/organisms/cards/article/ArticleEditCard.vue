<template>
  <v-row v-if="article != null" justify="center">
    <v-col v-if="!success" cols="12" sm="10" md="10">
      <BaseTitleCard title="編集" />
      <ArticleEditForm
        :article="article"
        :processing="processing"
        @article-update="onArticleUpdate"
      />
    </v-col>
    <v-col v-else cols="12" sm="10" md="10">
      <ArticleCreateSuccessCard
        :article="article"
        @to-edit="success = !success"
      />
    </v-col>
  </v-row>
</template>

<script>
import Application from '~/plugins/application.js'

export default {
  name: 'ArticleEditCard',

  mixins: [Application],

  data () {
    return {
      errors: null,
      article: null,
      success: false
    }
  },

  async created () {
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
