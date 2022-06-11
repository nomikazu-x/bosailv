<template>
  <div>
    <v-card v-if="articles != null && articles.length === 0">
      <v-card-title class="ml-1">記事はありません。</v-card-title>
      <v-divider class="my-4" />
    </v-card>
    <div v-for="article in articles" :key="article.id">
      <ArticleListItem
        :article="article"
      />
    </div>
  </div>
</template>

<script>
export default {
  props: {
    articles: {
      type: Array,
      default: () => []
    }
  }
}
</script>
