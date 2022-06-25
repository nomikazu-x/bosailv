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
      <div class="mb-4">
        <UserIntroCard
          :user="user"
          :required-point="requiredPoint"
        />
      </div>
    </template>

    <template v-if="!loading" #right>
      <BaseTitleCard :title="cardTitle">
        <div class="pa-5">
          <v-row>
            <v-col v-if="canAction" cols="12" class="text-right">
              <RedBtn class="my-b mr-4" to="/articles/new">記事を作成する</RedBtn>
            </v-col>
          </v-row>

          <GenreList :genres="genres" />
        </div>
      </BaseTitleCard>
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
    genres: {
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
    },
    cardTitle () {
      return (this.canAction ? 'あなた' : this.currentName) + 'の災害時役立つ記事'
    }
  }
}
</script>
