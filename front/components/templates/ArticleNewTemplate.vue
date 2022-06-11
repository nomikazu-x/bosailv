<template>
  <OneColumnContainer class="pos-relative" fluid>
    <Loading v-if="loading" />
    <Message v-if="!loading" :alert="alert" :notice="notice" />

    <ArticleNewForm
      v-if="!loading"
      :processing="processing"
      @article-create="onArticleCreate"
    />
  </OneColumnContainer>
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
    onArticleCreate (value) {
      this.$emit('article-create', value)
    }
  }
}
</script>
