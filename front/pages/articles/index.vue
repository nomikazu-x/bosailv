<template>
  <div>
    <Loading v-if="loading" />
    <v-container v-if="!loading">
      <Processing v-if="processing" />
      <v-card-title>記事一覧</v-card-title>
      <v-row v-if="info != null && info.total_count > info.limit_value">
        <v-col cols="auto" md="5" align-self="center">
          {{ info.total_count.toLocaleString() }}件中 {{ $pageFirstNumber(info).toLocaleString() }}-{{ $pageLastNumber(info).toLocaleString() }}件を表示
        </v-col>
        <v-col cols="auto" md="7" class="d-flex justify-end">
          <v-pagination id="pagination" v-model="page" :length="info.total_pages" @input="onPagination()" />
        </v-col>
      </v-row>

      <v-row>
        <v-col cols="12">
          <v-card v-if="articles != null && articles.length === 0">
            <v-card-title class="ml-1">記事はありません。</v-card-title>
            <v-divider class="my-4" />
          </v-card>
          <div v-for="article in articles" :key="article.id">
            <v-card :to="{ name: 'articles-id___ja', params: { id: article.id }}" class="my-5" max-width="600">
              <v-row>
                <v-col cols="4" align="center">
                  <v-img :src="article.thumbnail_url.large" max-height="128" max-width="192" class="ml-5 mt-2 rounded-lg" />
                </v-col>
                <v-col cols="8">
                  <v-card-title class="font-weight-bold">
                    {{ article.title }}
                  </v-card-title>
                  <v-card-text class="mt-10 text-right">
                    <v-icon small>mdi-calendar-range</v-icon>
                    {{ $dateFormat(article.created_at, 'ja') }}
                  </v-card-text>
                </v-col>
              </v-row>
            </v-card>
          </div>

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
