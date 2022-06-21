<template>
  <v-row justify="center">
    <v-col cols="12" sm="10" md="10">
      <BaseTitleCard title="編集" />
      <ArticleEditForm
        :article="article"
        :processing="processing"
        @article-update="onArticleUpdate"
      />
    </v-col>
  </v-row>
</template>

<script>
export default {
  props: {
    article: {
      type: Object,
      default: undefined
    },
    errors: {
      type: Object,
      default: undefined
    },
    processing: {
      type: Boolean,
      default: false
    }
  },
  methods: {
    onArticleUpdate (value) {
      return this.$emit('article-update', value)
    }
  }
}
</script>
