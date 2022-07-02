<template>
  <TwoColumnContainer
    :left-cols="12"
    :left-sm="8"
    :right-cols="12"
    :right-sm="4"
  >
    <template #top>
      <TheLoading v-if="loading" />
      <TheMessage v-if="!loading" :alert="alert" :notice="notice" />
    </template>

    <template #left>
      <v-row v-if="!loading" justify="center">
        <v-col cols="12">
          <BaseTitleCard title="記事検索">
            <v-row class="pa-5">
              <v-col cols="12">
                <ArticleSearchTextField v-model="keyword" />
              </v-col>
              <v-col cols="12">
                <GenresCheckbox v-model="selectedGenres" />
              </v-col>
              <v-col cols="12">
                <div class="text-center mt-5">
                  <RedBtn @click="onSearchArticlePagination">検索</RedBtn>
                </div>
              </v-col>
            </v-row>
            <v-row justify="center">
              <v-col cols="12">
                <v-card-title v-if="info">検索結果：{{ info.total_count }}件</v-card-title>
              </v-col>
              <v-col cols="12">
                <ArticleCardWithTab
                  :articles="articles"
                  :info="info"
                  :processing="processing"
                  @pagination="onSearchArticlePagination"
                />
              </v-col>
            </v-row>
          </BaseTitleCard>
        </v-col>
      </v-row>
    </template>

    <template v-if="!loading" #right>
      <DefaultRightColumnTemplate />
    </template>
  </TwoColumnContainer>
</template>

<script>
import Application from '~/plugins/application.js'

export default {
  name: 'ArticlesSearch',

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
    this.onSearchArticlePagination(this.page)
    this.processing = false
    this.loading = false
  },

  methods: {
    async onSearchArticlePagination (value) {
      this.processing = true

      await this.$axios.get(this.$config.apiBaseURL + this.$config.articlesSearchUrl, {
        params: {
          page: value,
          keyword: this.keyword,
          genre_ids: this.selectedGenres
        }
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
