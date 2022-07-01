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
          <v-img :src="genre.image_url.xlarge" max-height="150" gradient="to top right, rgba(100,115,201,.33), rgba(25,32,72,.3)">
            <v-card-title class="genre-name mt-8 white--text justify-center align-center text-shadow">{{ genre.name }}</v-card-title>
          </v-img>
          <v-tabs v-model="tab" background-color="#FFFCFC" color="#ef5350" class="mt-4" grow>
            <v-tab v-for="title in titles" :key="title.name">{{ title.name }}</v-tab>
          </v-tabs>
          <v-tabs-items v-model="tab">
            <v-tab-item>
              <ArticleCardWithTab
                :processing="processing"
                :articles="articles"
                :info="articleInfo"
                @pagination="onArticlePagination"
              />
            </v-tab-item>
            <v-tab-item>
              <ArticleCardWithTab
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

    <template #right>
      <DefaultRightColumnTemplate :loading="loading" />
    </template>
  </TwoColumnContainer>
</template>

<script>
export default {
  props: {
    genre: {
      type: Object,
      default: null
    },
    articleInfo: {
      type: Object,
      default: null
    },
    famousArticleInfo: {
      type: Object,
      default: null
    },
    articles: {
      type: Array,
      default: () => []
    },
    famousArticles: {
      type: Array,
      default: () => []
    },
    processing: {
      type: Boolean,
      default: false
    },
    loading: {
      type: Boolean,
      default: false
    },
    alert: {
      type: String,
      default: null
    },
    notice: {
      type: String,
      default: null
    }
  },
  data () {
    return {
      tab: null,
      titles: [
        { name: '新着一覧' },
        { name: 'ランキング' }
      ]
    }
  },
  methods: {
    onArticlePagination (value) {
      return this.$emit('article-pagination', value)
    },
    onFamousArticlePagination (value) {
      return this.$emit('famous-article-pagination', value)
    }
  }
}
</script>
