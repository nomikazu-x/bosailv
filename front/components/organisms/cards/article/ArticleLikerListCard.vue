<template>
  <BaseTitleCard title="いいねしたユーザー">
    <ArticleLikerListItem
      v-for="(liker, i) in likers"
      :key="liker.id"
      :liker="liker"
      :index="i"
    />
  </BaseTitleCard>
</template>

<script>
import Application from '~/plugins/application.js'

export default {
  name: 'ArticleLikerListCard',

  mixins: [Application],

  data () {
    return {
      likers: null
    }
  },

  async created () {
    await this.$axios.get(this.$config.apiBaseURL + this.$config.articleDetailUrl.replace('_id', this.$route.params.id))
      .then((response) => {
        if (response.data == null) {
          this.$toasted.error(this.$t('system.error'))
          return this.$router.push({ path: '/' })
        }
        this.likers = response.data.article.likers
      },
      (error) => {
        if (error.response == null) {
          this.$toasted.error(this.$t('network.failure'))
          return this.$router.push({ path: '/' })
        } else if (error.response.data == null && error.response.status !== 404) {
          this.$toasted.error(this.$t('network.error'))
          return this.$router.push({ path: '/' })
        } else {
          if (error.response.data != null) {
            this.$toasted.error(error.response.data.alert)
            this.$toasted.info(error.response.data.notice)
          }
          return this.$nuxt.error({ statusCode: error.response.status })
        }
      })

    this.processing = false
  }
}
</script>
