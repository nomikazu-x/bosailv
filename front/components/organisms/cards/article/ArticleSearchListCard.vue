<template>
  <v-row v-if="articles != null" justify="center">
    <v-col cols="12">
      <BaseTitleCard title="記事検索">
        <v-row class="pa-5">
          <v-col cols="12">
            <BaseTextField
              v-model="keyword"
              name="keyword"
              label="キーワード検索"
              prepend-icon="mdi-magnify"
            />
          </v-col>
          <v-col cols="12">
            <GenresCheckbox v-model="selectedGenres" />
          </v-col>
          <v-col cols="12">
            <div class="text-center mt-5">
              <GreenBtn @click="onSearchArticlePagination">検索</GreenBtn>
            </div>
          </v-col>
        </v-row>
        <v-row justify="center">
          <v-col cols="12">
            <v-card-title v-if="info">検索結果：{{ info.total_count }}件</v-card-title>
          </v-col>
          <v-col cols="12">
            <ArticleListCardWithTab
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

<script>
import Application from '~/plugins/application.js'
import BaseTitleCard from '~/components/molecules/cards/BaseTitleCard.vue'
import BaseTextField from '~/components/molecules/textFields/BaseTextField.vue'
import GenresCheckbox from '~/components/organisms/checkbox/GenresCheckbox.vue'
import ArticleListCardWithTab from '~/components/organisms/tabItem/ArticleListCardWithTab.vue'
import GreenBtn from '~/components/atoms/btns/GreenBtn.vue'

export default {
  name: 'ArticleSearchListCard',

  components: {
    BaseTitleCard,
    BaseTextField,
    GenresCheckbox,
    ArticleListCardWithTab,
    GreenBtn
  },

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
