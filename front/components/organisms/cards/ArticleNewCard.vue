<template>
  <v-card class="pa-6">
    <h2 class="mb-3 text-center">記事作成</h2>

    <v-row justify="center">
      <v-col cols="12" sm="8" md="6">
        <ArticleNewForm
          :processing="processing"
          @article-create="onArticleCreate"
        />
      </v-col>
    </v-row>
  </v-card>
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
