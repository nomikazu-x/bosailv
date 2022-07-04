<template>
  <v-row v-if="infomations != null" justify="center">
    <v-col cols="12">
      <BaseTitleCard title="通知一覧">
        <TheProcessing v-if="processing" />
        <article v-if="infomations != null && infomations.length === 0">
          <span class="ml-1">お知らせはありません。</span>
        </article>
        <InfomationListItem
          v-for="infomation in infomations"
          :key="infomation.id"
          :infomation="infomation"
        />

        <ThePagination
          class="mt-5"
          :info="info"
          @pagination="onPagination"
        />
      </BaseTitleCard>
    </v-col>
  </v-row>
</template>

<script>
import Application from '~/plugins/application.js'

export default {
  name: 'InfomationListCard',
  mixins: [Application],

  data () {
    return {
      page: 1,
      info: null,
      infomations: null
    }
  },

  async created () {
    await this.onPagination(this.page)
    this.processing = false
  },

  methods: {
    async onPagination (page) {
      this.processing = true

      await this.$axios.get(this.$config.apiBaseURL + this.$config.infomationsUrl, { params: { page } })
        .then((response) => {
          if (response.data == null || response.data.infomation == null) {
            this.$toasted.error(this.$t('system.error'))
            if (this.info == null) {
              return this.$router.push({ path: '/' })
            }
            this.page = this.info.current_page
          } else {
            this.info = response.data.infomation
            this.infomations = response.data.infomations
            if (this.$auth.loggedIn && this.$auth.user.infomation_unread_count !== 0 && this.page === 1) { this.$auth.fetchUser() } // Tips: お知らせ未読数をリセット
          }
        },
        (error) => {
          this.$toasted.error(this.$t(error.response == null ? 'network.failure' : 'network.error'))
          if (this.info == null) {
            return this.$router.push({ path: '/' })
          }
          this.page = this.info.current_page
        })

      this.processing = false
    }
  }
}
</script>
