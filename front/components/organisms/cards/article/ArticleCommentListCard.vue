<template>
  <BaseTitleCard class="mt-3" title="コメント一覧">
    <div class="pa-5">
      <article v-if="articleComments != null && articleComments.length === 0">
        <v-card-text>この記事にコメントはありません。</v-card-text>
        <v-divider class="my-4" />
      </article>
      <ArticleCommentListCardText v-for="articleComment in articleComments" :key="articleComment.id" :article-comment="articleComment" />
      <ArticleCommentTextarea v-if="$auth.loggedIn" :article="article" />
    </div>
  </BaseTitleCard>
</template>

<script>
export default {
  props: {
    articleComments: {
      type: Array,
      default: () => []
    },
    article: {
      type: Object,
      default: null
    }
  }
}
</script>
