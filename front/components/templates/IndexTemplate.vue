<template>
  <TwoColumnContainer
    :left-cols="12"
    :left-sm="8"
    :right-cols="12"
    :right-sm="4"
  >
    <template #top>
      <Loading v-if="loading" />
      <Message v-if="!loading" :alert="alert" :notice="notice" />
      <TopSlide v-if="!loading" :articles="articles" />
    </template>

    <template v-if="!loading" #left>
      <div>
        <TopTransitionCard />
        <ArticleIndexTemplate
          :info="info"
          :articles="articles"
          :processing="processing"
          :loading="loading"
          :alert="alert"
          :notice="notice"
          @pagination="onPagination"
        />
        <GenresImageIndexTemplate
          :genres="genres"
        />
      </div>
    </template>

    <template v-if="!loading" #right>
      <div v-if="$auth.loggedIn" class="mb-4">
        <UserIntroCard
          :user="$auth.user"
          :required-point="$auth.user.required_point"
        />
      </div>
      <div v-else class="mb-4">
        <SignUp />
      </div>
      <div class="mb-4">
        <ImportantInfomationLists
          :infomations="infomations"
        />
      </div>
      <div class="mb-4">
        <ArticlesRankingCard
          :famous-articles="famousArticles"
        />
      </div>
      <div class="mb-4">
        <UserRankingCard
          :users="users"
        />
      </div>
    </template>
  </TwoColumnContainer>
</template>

<script>
export default {
  props: {
    canAction: {
      type: Boolean,
      default: false
    },
    user: {
      type: Object,
      default: null
    },
    users: {
      type: Array,
      default: () => []
    },
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
    famousArticles: {
      type: Array,
      default: () => []
    },
    infomations: {
      type: Array,
      default: () => []
    },
    requiredPoint: {
      type: Number,
      default: 0
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
