<template>
  <v-card>
    <Processing v-if="processing" />
    <v-row>
      <v-col cols="12">
        <v-card-title>新着一覧</v-card-title>
        <v-card v-if="articles != null && articles.length === 0">
          <v-card-title class="ml-1">記事はありません。</v-card-title>
          <v-divider class="my-4" />
        </v-card>
        <div v-for="article in articles" :key="article.id">
          <ArticleListCard
            :article="article"
          />
        </div>

        <Pagination
          class="mt-5"
          :info="info"
          @pagination="onPagination"
        />
      </v-col>
    </v-row>
  </v-card>
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
