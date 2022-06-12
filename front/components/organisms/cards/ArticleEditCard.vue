<template>
  <v-card class="pa-6">
    <h2 class="mb-3 text-center">記事編集</h2>

    <v-row justify="center">
      <v-col cols="12" sm="8" md="6">
        <ArticleEditForm
          :article="article"
          :processing="processing"
          @article-update="onArticleUpdate"
        />
      </v-col>
    </v-row>
  </v-card>
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
