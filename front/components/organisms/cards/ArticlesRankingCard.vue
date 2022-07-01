<template>
  <BaseTitleCard v-if="famousArticles != null && famousArticles.length > 0" class="pb-1" title="人気記事">
    <ArticlesRankingItem
      v-for="(article, i) in famousArticles.slice(0, 5)"
      :key="article.id"
      :article="article"
      :index="i"
    />
    <RedBtn
      large
      class="mt-6 mb-2"
      outlined
      block
      to="/articles"
    >
      人気記事をもっと見る
    </RedBtn>
  </BaseTitleCard>
</template>

<script>
export default {
  data () {
    return {
      famousArticles: null
    }
  },
  async created () {
    await this.$axios.get(this.$config.apiBaseURL + this.$config.articlesUrl, {
      params: { famous: true }
    })
      .then((response) => {
        if (response.data == null || response.data.article == null) {
          this.$toasted.error(this.$t('system.error'))
          return this.$router.push({ path: '/' })
        } else {
          this.famousArticles = response.data.articles
        }
      },
      (error) => {
        this.$toasted.error(this.$t(error.response == null ? 'network.failure' : 'network.error'))
        return this.$router.push({ path: '/' })
      })
  }
}
</script>
