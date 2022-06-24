<template>
  <BaseTitleCard v-if="famousArticles != null && famousArticles.length > 0" class="pb-1" title="人気記事">
    <ArticlesRankingItem
      v-for="(article, i) in famousArticles.slice(0, 5)"
      :key="article.id"
      :article="article"
      :index="i"
    />
    <v-btn
      large
      class="mt-6 mb-2"
      color="#ef5350"
      outlined
      block
      to="/articles"
    >
      人気記事をもっと見る
    </v-btn>
  </BaseTitleCard>
</template>

<script>
export default {
  props: {
    famousArticles: {
      type: Array,
      default: () => []
    }
  }
}
</script>
