<template>
  <TwoColumnContainer
    :left-cols="12"
    :left-sm="4"
    :right-cols="12"
    :right-sm="8"
  >
    <template #left>
      <div class="mb-4 mt-10">
        <UserIntroCard
          :user="user"
          :required-point="requiredPoint"
        />
      </div>
    </template>

    <template #right>
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

      <ArticleListsWithAction
        v-if="canAction"
        :lists="lists"
      />

      <ArticleLists
        v-else
        :lists="lists"
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
    lists: {
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
