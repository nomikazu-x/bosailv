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
            <GreenBtn class="mb-4" color="#00a8ff" to="/articles/new">記事を作成する</GreenBtn>
          </v-col>
        </v-row>
      </v-container>
      <v-img :src="genre.image_url.xlarge" max-height="150" gradient="to top right, rgba(100,115,201,.33), rgba(25,32,72,.3)">
        <v-card-title class="genre-name mt-8 white--text justify-center align-center text-shadow">{{ genre.name }}</v-card-title>
      </v-img>
      <ArticleLists
        :articles="articles"
      />
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
    genre: {
      type: Object,
      default: null
    },
    articles: {
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
  computed: {
    currentName () {
      return (this.user && this.user.name) || this.$auth.user.name
    }
  }
}
</script>
