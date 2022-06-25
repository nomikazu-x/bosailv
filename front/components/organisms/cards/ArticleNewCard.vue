<template>
  <v-row justify="center">
    <v-col cols="12" sm="10" md="10">
      <BaseTitleCard title="記事作成" />
      <ArticleNewForm
        :processing="processing"
        @article-create="onArticleCreate"
      />
    </v-col>
  </v-row>
</template>

<script>
export default {
  props: {
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
    onArticleCreate (value) {
      return this.$emit('article-create', value)
    }
  }
}
</script>
