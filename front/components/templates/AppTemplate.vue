<template>
  <TwoColumnContainer
    :left-cols="12"
    :left-sm="8"
    :right-cols="12"
    :right-sm="4"
  >
    <template #top>
      <TheLoading v-if="loading" />
      <TheMessage v-if="!loading" :alert="alert" :notice="notice" />
      <TopSlide v-if="!loading" :articles="articles" />
    </template>

    <template v-if="!loading" #left>
      <div>
        <TopTransitionCard />
        <ArticleLists
          :info="info"
          :articles="articles"
          :processing="processing"
          :loading="loading"
          :alert="alert"
          :notice="notice"
          @pagination="onPagination"
        />
        <GenresImageIndexCard :genres="genres" />
      </div>
    </template>

    <template #right>
      <DefaultRightColumnTemplate :loading="loading" />
    </template>
  </TwoColumnContainer>
</template>

<script>
export default {
  name: 'AppTemplate',
  props: {
    genres: {
      type: Array,
      default: () => []
    },
    info: {
      type: Object,
      default: null
    },
    articles: {
      type: Array,
      default: () => []
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
    onPagination (value) {
      return this.$emit('pagination', value)
    }
  }
}
</script>
