<template>
  <div>
    <Processing v-if="processing" />
    <v-card tile>
      <v-card v-if="articles != null && articles.length === 0">
        <v-card-title class="ml-1">記事はありません。</v-card-title>
        <v-divider class="my-4" />
      </v-card>
      <div v-for="article in articles" :key="article.id">
        <ArticleListCard
          :article="article"
        />
      </div>

      <Pagination
        class="mt-5"
        :info="info"
        @pagination="onPagination"
      />
    </v-card>
  </div>
</template>

<script>
import Application from '~/plugins/application.js'

export default {
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
    this.processing = false
  },
  methods: {
    async onPagination (page) {
      this.processing = true
      await this.$axios.get(this.$config.apiBaseURL + this.$config.userGenreArticlesUrl.replace('_username', this.$route.params.username).replace('_id', this.$route.params.id), {
        params: { favorite: true }, page
      })
        .then((response) => {
          if (response.data == null) {
            this.$toasted.error(this.$t('system.error'))
            if (this.info == null) {
              return this.$router.push({ path: '/' })
            }
            this.page = this.info.current_page
          } else {
            this.genre = response.data.genre
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
