<template>
  <div>
    <Loading v-if="loading" />
    <v-container v-if="!loading">
      <Processing v-if="processing" />
      <v-card-title>記事一覧</v-card-title>
      <v-row>
        <v-col cols="12">
          <ArticleLists :articles="articles" />

          <div v-if="info != null && info.total_pages > 1">
            <v-pagination id="pagination2" v-model="page" :length="info.total_pages" @input="onPagination()" />
          </div>
        </v-col>
      </v-row>
    </v-container>
  </div>
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
    async onPagination () {
      this.processing = true

      await this.$axios.get(this.$config.apiBaseURL + this.$config.articlesUrl, {
        params: { page: this.page }
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
