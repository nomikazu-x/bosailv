<template>
  <TwoColumnContainer
    :left-cols="12"
    :left-sm="4"
    :right-cols="12"
    :right-sm="8"
  >
    <template #top>
      <Loading v-if="loading" />
      <Message v-if="!loading" :alert="alert" :notice="notice" />
    </template>

    <template v-if="!loading" #left>
      <div class="mb-4 mt-10">
        <UserIntroCard
          :user="user"
          :required-point="requiredPoint"
        />
      </div>
    </template>

    <template v-if="!loading" #right>
      <v-container>
        <v-row>
          <v-col cols="12" sm="8">
            <h2 class="text-center main-heading">{{ canAction ? 'あなた' : currentName }}の災害時役立つ記事</h2>
          </v-col>
          <v-col v-if="canAction" cols="12" sm="4" class="text-right">
            <RedBtn class="mb-4" to="/articles/new">記事を作成する</RedBtn>
          </v-col>
        </v-row>
      </v-container>
      <v-img :src="genre.image_url.xlarge" max-height="150" gradient="to top right, rgba(100,115,201,.33), rgba(25,32,72,.3)">
        <v-card-title class="genre-name mt-8 white--text justify-center align-center text-shadow">{{ genre.name }}</v-card-title>
      </v-img>
      <v-tabs v-model="tab" background-color="#FFFCFC" color="#ef5350" class="mt-4" grow>
        <v-tab v-for="title in titles" :key="title.name">{{ title.name }}</v-tab>
      </v-tabs>
      <v-tabs-items v-model="tab">
        <v-tab-item>
          <TabArticleList
            :processing="processing"
            :articles="articles"
            :info="articleInfo"
            @pagination="onArticlePagination"
          />
        </v-tab-item>
        <v-tab-item>
          <TabArticleList
            :processing="processing"
            :articles="favoriteArticles"
            :info="favoriteArticleInfo"
            @pagination="onFavoriteArticlePagination"
          />
        </v-tab-item>
      </v-tabs-items>
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
    currentUsername: {
      type: String,
      default: null
    },
    user: {
      type: Object,
      default: null
    },
    articleInfo: {
      type: Object,
      default: null
    },
    favoriteArticleInfo: {
      type: Object,
      default: null
    },
    genre: {
      type: Object,
      default: null
    },
    articles: {
      type: Array,
      default: () => []
    },
    favoriteArticles: {
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
  data () {
    return {
      tab: null,
      titles: [
        { name: '執筆' },
        { name: 'お気に入り' }
      ]
    }
  },
  computed: {
    currentName () {
      return (this.user && this.user.name) || this.$auth.user.name
    }
  },
  methods: {
    onArticlePagination (value) {
      return this.$emit('article-pagination', value)
    },
    onFavoriteArticlePagination (value) {
      return this.$emit('favorite-article-pagination', value)
    }
  }
}
</script>
