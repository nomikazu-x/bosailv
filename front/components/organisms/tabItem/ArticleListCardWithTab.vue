<template>
  <div>
    <TheProcessing v-if="processing" />
    <v-card tile>
      <v-card v-if="articles != null && articles.length === 0">
        <v-card-title class="ml-1">記事はありません。</v-card-title>
        <v-divider class="my-4" />
      </v-card>
      <div v-for="article in articles" :key="article.id">
        <ArticleCardText
          :article="article"
        />
      </div>

      <ThePagination
        class="mt-5"
        :info="info"
        @pagination="onPagination"
      />
    </v-card>
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
