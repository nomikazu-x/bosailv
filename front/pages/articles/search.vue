<template>
  <OneColumnContainer>
    <Loading v-if="loading" />
    <v-card v-if="!loading">
      <ValidationProvider v-slot="{ errors }" name="keyword" rules="required">
        <v-text-field
          v-model="keyword"
          label="検索"
          prepend-icon="mdi-magnify"
          :error-messages="errors"
        />
      </ValidationProvider>
      <GenresCheckbox v-model="selectedGenres" />
      <RedBtn @click="onSearchArticles">検索</RedBtn>
      <v-row v-if="!loading" justify="center">
        <v-col cols="12" sm="10" md="10">
          <ArticleLists
            :articles="articles"
            :info="info"
            :processing="processing"
            @pagination="onSearchArticles"
          />
        </v-col>
      </v-row>
    </v-card>
  </OneColumnContainer>
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
      articles: null,
      keyword: '',
      selectedGenres: []
    }
  },

  created () {
    this.onSearchArticles(this.page)
    this.processing = false
    this.loading = false
  },

  methods: {
    async onSearchArticles (page) {
      this.processing = true

      await this.$axios.get(this.$config.apiBaseURL + this.$config.articlesSearchUrl, {
        params: { page, keyword: this.keyword, genre_ids: this.selectedGenres }
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
