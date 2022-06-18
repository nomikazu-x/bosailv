<template>
  <InfomationsIndexTemplate
    :lists="lists"
    :info="info"
    :processing="processing"
    :loading="loading"
    :alert="alert"
    :notice="notice"
    @pagination="onPagination"
  />
</template>

<script>
import Application from '~/plugins/application.js'

export default {
  name: 'Infomations',
  mixins: [Application],

  data () {
    return {
      page: 1,
      info: null,
      lists: null
    }
  },

  async created () {
    await this.onPagination(this.page)

    if (!this.$auth.loggedIn) {
      return this.redirectAuth()
    }

    this.loading = false
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
            this.lists = response.data.infomations
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
