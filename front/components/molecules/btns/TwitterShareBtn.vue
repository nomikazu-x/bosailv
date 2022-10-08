<template>
  <TwitterBtn
    :href="twitterLink"
    target="_target"
    rel="nofollow"
  >
    <slot />
  </TwitterBtn>
</template>

<script>
import TwitterBtn from '~/components/molecules/btns/TwitterBtn.vue'

const TWITTER_TWEET_URL = 'https://twitter.com/intent/tweet'

export default {
  components: {
    TwitterBtn
  },
  props: {
    hashtag: {
      type: [String, Array],
      default: undefined
    },
    url: {
      type: String,
      default: undefined
    },
    text: {
      type: String,
      default: undefined
    }
  },
  computed: {
    twitterLink () {
      const map = new Map()
      this.text && map.set('text', this.text)
      this.hashtag && map.set('hashtags', this.getHashtagStr)
      this.url && map.set('url', this.url)
      const params = new URLSearchParams(map) // クエリパラメータの生成
      return `${TWITTER_TWEET_URL}?${params.toString()}`
    },
    getHashtagStr () {
      return this.hashtag ? this.hashtag : this.hashtag.join(',') // Tips: hashtagをURL用に文字列で取得する
    }
  }
}
</script>
