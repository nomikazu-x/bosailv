<template>
  <div>
    <Processing v-if="processing" />
    <v-card-title>新着記事</v-card-title>
    <v-row>
      <v-col cols="12">
        <v-card v-if="articles != null && articles.length === 0">
          <v-card-title class="ml-1">記事はありません。</v-card-title>
          <v-divider class="my-4" />
        </v-card>
        <div v-for="article in articles" :key="article.id">
          <ArticleListCard
            :article="article"
          />
        </div>

        <ArticlesPagination
          :info="info"
          @pagination="onPagination"
        />
      </v-col>
    </v-row>
  </div>
</template>

<script>
export default {
  props: {
    articles: {
      type: Array,
      default: () => []
    },
    info: {
      type: Object,
      default: null
    },
    processing: {
      type: Boolean,
      default: false
    }
  },
  methods: {
    onPagination (value) {
      return this.$emit('pagination', value)
    }
  }
}
</script>
