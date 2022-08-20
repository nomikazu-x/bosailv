<template>
  <v-row v-if="articles != null" justify="center">
    <v-col cols="12">
      <v-img :src="genre.image_url.xlarge" max-height="150" gradient="to top right, rgba(100,115,201,.33), rgba(25,32,72,.3)">
        <v-card-title class="genre-name mt-8 white--text justify-center align-center text-shadow">{{ genre.name }}</v-card-title>
      </v-img>
      <v-card-text>
        {{ genre.description }}
      </v-card-text>
      <v-tabs v-model="tab" background-color="#FFFCFC" color="#117768" class="mt-4" grow>
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
    </v-col>
  </v-row>
</template>

<script>
import Application from '~/plugins/application.js'
import ArticleListCardWithTab from '~/components/organisms/tabItem/ArticleListCardWithTab.vue'

export default {
  name: 'GenreShowCard',

  components: {
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
      genre: null,
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
    this.processing = false
  },

  methods: {
    async onArticlePagination (articlePage) {
      this.processing = true
      await this.$axios.get(this.$config.apiBaseURL + this.$config.genreShowUrl.replace('_id', this.$route.params.id), {
        params: { page: articlePage }
      })
        .then((response) => {
          if (response.data == null) {
            this.$toasted.error(this.$t('system.error'))
            if (this.articleInfo == null) {
              return this.$router.push({ path: '/' })
            }
            this.articlePage = this.articleInfo.current_page
          } else {
            this.genre = response.data.genre
            this.articleInfo = response.data.article
            this.articles = response.data.articles
          }
        },
        (error) => {
          this.$toasted.error(this.$t(error.response == null ? 'network.failure' : 'network.error'))
          if (this.articleInfo == null) {
            return this.$router.push({ path: '/' })
          }
          this.articlePage = this.articleInfo.current_page
        })

      this.processing = false
    },

    async onFamousArticlePagination (famousArticlePage) {
      this.processing = true
      await this.$axios.get(this.$config.apiBaseURL + this.$config.genreShowUrl.replace('_id', this.$route.params.id), {
        params: { page: famousArticlePage, famous: true }
      })
        .then((response) => {
          if (response.data == null) {
            this.$toasted.error(this.$t('system.error'))
            if (this.famousArticleInfo == null) {
              return this.$router.push({ path: '/' })
            }
            this.famousArticlePage = this.famousArticleInfo.current_page
          } else {
            this.genre = response.data.genre
            this.famousArticleInfo = response.data.article
            this.famousArticles = response.data.articles
          }
        },
        (error) => {
          this.$toasted.error(this.$t(error.response == null ? 'network.failure' : 'network.error'))
          if (this.famousArticleInfo == null) {
            return this.$router.push({ path: '/' })
          }
          this.famousArticlePage = this.famousArticleInfo.current_page
        })

      this.processing = false
    }
  }
}
</script>
