<template>
  <v-row justify="center">
    <v-col cols="12">
      <BaseTitleCard v-if="articles != null" title="災害時役立つ記事一覧">
        <v-tabs v-model="tab" background-color="#FFFCFC" color="#117768" grow>
          <v-tab v-for="title in titles" :key="title.name">{{ title.name }}</v-tab>
        </v-tabs>
        <v-tabs-items v-model="tab">
          <v-tab-item>
            <ArticleListCardWithTab
              :processing="processing"
              :articles="articles"
              :info="articleInfo"
              @pagination="onArticlePagination"
            />
          </v-tab-item>
          <v-tab-item>
            <ArticleListCardWithTab
              :processing="processing"
              :articles="famousArticles"
              :info="famousArticleInfo"
              @pagination="onFamousArticlePagination"
            />
          </v-tab-item>
        </v-tabs-items>
      </BaseTitleCard>
    </v-col>
  </v-row>
</template>

<script>
import Application from '~/plugins/application.js'
import BaseTitleCard from '~/components/molecules/cards/BaseTitleCard.vue'
import ArticleListCardWithTab from '~/components/organisms/tabItem/ArticleListCardWithTab.vue'

export default {
  name: 'UsefulArticleListCard',

  components: {
    BaseTitleCard,
    ArticleListCardWithTab
  },

  mixins: [Application],

  data () {
    return {
      tab: null,
      titles: [
        { name: '新着一覧' },
        { name: 'ランキング' }
      ],
      articlePage: 1,
      famousArticlePage: 1,
      articleInfo: null,
      famousArticleInfo: null,
      articles: null,
      famousArticles: null
    }
  },

  async created () {
    await this.onArticlePagination(this.articlePage)
    await this.onFamousArticlePagination(this.famousArticlePage)
    this.loading = false
  },

  methods: {
    async onArticlePagination (articlePage) {
      this.processing = true
      await this.$axios.get(this.$config.apiBaseURL + this.$config.articlesUrl, {
        params: { page: articlePage }
      })
        .then((response) => {
          if (response.data == null) {
            this.$toasted.error(this.$t('system.error'))
            if (this.articleInfo == null) {
              return this.$router.push({ path: '/home' })
            }
            this.articlePage = this.articleInfo.current_page
          } else {
            this.articleInfo = response.data.article
            this.articles = response.data.articles
          }
        },
        (error) => {
          this.$toasted.error(this.$t(error.response == null ? 'network.failure' : 'network.error'))
          if (this.articleInfo == null) {
            return this.$router.push({ path: '/home' })
          }
          this.articlePage = this.articleInfo.current_page
        })

      this.processing = false
    },

    async onFamousArticlePagination (famousArticlePage) {
      this.processing = true
      await this.$axios.get(this.$config.apiBaseURL + this.$config.articlesUrl, {
        params: { page: famousArticlePage, famous: true }
      })
        .then((response) => {
          if (response.data == null) {
            this.$toasted.error(this.$t('system.error'))
            if (this.famousArticleInfo == null) {
              return this.$router.push({ path: '/home' })
            }
            this.famousArticlePage = this.famousArticleInfo.current_page
          } else {
            this.famousArticleInfo = response.data.article
            this.famousArticles = response.data.articles
          }
        },
        (error) => {
          this.$toasted.error(this.$t(error.response == null ? 'network.failure' : 'network.error'))
          if (this.famousArticleInfo == null) {
            return this.$router.push({ path: '/home' })
          }
          this.famousArticlePage = this.famousArticleInfo.current_page
        })

      this.processing = false
    }
  }
}
</script>
