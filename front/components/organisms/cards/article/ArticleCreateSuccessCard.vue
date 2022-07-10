<template>
  <OneColumnContainer>
    <h1 class="text-center main-heading mb-4">投稿完了しました!</h1>

    <v-row class="mb-4" justify="center">
      <TwitterShareBtn :text="shareText" :hashtag="hashtag">
        <span class="ml-2">Twitterに投稿する</span>
      </TwitterShareBtn>
    </v-row>

    <v-row class="mb-12" justify="center">
      <RedBtn :to="{ name: 'articles-id-edit___ja', params: { id: article.id }}" class="mr-2" @click="toEdit">
        編集する
      </RedBtn>

      <RedBtn :to="{ name: 'articles-id___ja', params: { id: article.id }}">
        投稿を見る
      </RedBtn>
    </v-row>

    <div class="max-width-600 mb-4 mx-auto">
      <p class="font-marck-script text-proverb text-center">No worries if prepared.</p>

      <p class="text-right text-small">備えあれば憂いなし</p>
    </div>
  </OneColumnContainer>
</template>

<script>
import OneColumnContainer from '~/components/molecules/containers/OneColumnContainer.vue'
import TwitterShareBtn from '~/components/molecules/btns/TwitterShareBtn.vue'
import RedBtn from '~/components/atoms/btns/RedBtn.vue'

export default {
  name: 'ArticleCreateSuccessCard',

  components: {
    OneColumnContainer,
    TwitterShareBtn,
    RedBtn
  },

  props: {
    article: {
      type: Object,
      default: undefined
    }
  },
  computed: {
    shareText () {
      return 'BosaiLevel'
    },
    hashtag () {
      return '防災,BosaiLevel'
    }
  },
  methods: {
    toEdit () {
      return this.$emit('to-edit')
    }
  }
}
</script>

<style lang="scss" scoped>
.text-proverb {
  font-size: 2rem !important;
  letter-spacing: 0.0073529412em !important;
  line-height: 2.5rem;
}
</style>
