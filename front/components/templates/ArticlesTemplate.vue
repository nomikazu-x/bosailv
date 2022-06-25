<template>
  <TwoColumnContainer
    :left-cols="12"
    :left-sm="8"
    :right-cols="12"
    :right-sm="4"
  >
    <template #top>
      <Loading v-if="loading" />
      <Message v-if="!loading" :alert="alert" :notice="notice" />
    </template>

    <template #left>
      <v-row v-if="!loading" justify="center">
        <v-col cols="12">
          <BaseTitleCard title="災害時役立つ記事一覧">
            <v-tabs v-model="tab" background-color="#FFFCFC" color="#ef5350" grow>
              <v-tab v-for="title in titles" :key="title.name">{{ title.name }}</v-tab>
            </v-tabs>
            <v-tabs-items v-model="tab">
              <v-tab-item>
                <TabArticleList
                  :processing="processing"
                  :articles="articles"
                  :info="articleInfo"
                  @pagination="onArticlePagination"
                />
              </v-tab-item>
              <v-tab-item>
                <TabArticleList
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

    <template #right>
      <DefaultRightColumnTemplate :loading="loading" />
    </template>
  </TwoColumnContainer>
</template>

<script>
export default {
  props: {
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
