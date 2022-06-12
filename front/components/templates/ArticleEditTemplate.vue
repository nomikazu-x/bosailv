<template>
  <OneColumnContainer class="pos-relative" fluid>
    <Loading v-if="loading" />
    <Message v-if="!loading" :alert="alert" :notice="notice" />

    <ArticleEditCard
      v-if="!loading"
      :article="article"
      :processing="processing"
      @article-update="onArticleUpdate"
    />
  </OneColumnContainer>
</template>

<script>
export default {
  props: {
    article: {
      type: Object,
      default: null
    },
    errors: {
      type: Object,
      default: undefined
    },
    processing: {
      type: Boolean,
      default: false
    },
    loading: {
      type: Boolean,
      default: false
    },
    alert: {
      type: String,
      default: null
    },
    notice: {
      type: String,
      default: null
    }
  },
  methods: {
    onArticleUpdate (value) {
      this.$emit('article-update', value)
    }
  }
}
</script>
