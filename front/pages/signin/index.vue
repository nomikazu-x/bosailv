<template>
  <OneColumnContainer>
    <TheLoading v-if="loading" />
    <TheMessage v-if="!loading" :alert="alert" :notice="notice" />

    <SigninCard v-if="!loading" @alert="alert = $event" @notice="notice = $event" />
  </OneColumnContainer>
</template>

<script>
import Application from '~/plugins/application.js'
import OneColumnContainer from '~/components/molecules/containers/OneColumnContainer.vue'
import TheLoading from '~/components/organisms/application/TheLoading.vue'
import TheMessage from '~/components/organisms/application/TheMessage.vue'
import SigninCard from '~/components/organisms/cards/SigninCard.vue'

export default {
  name: 'SigninIndex',

  components: {
    OneColumnContainer,
    TheLoading,
    TheMessage,
    SigninCard
  },

  mixins: [Application],

  created () {
    switch (this.$route.query.account_confirmation_success) {
      case 'true':
        if (this.$auth.loggedIn) {
          return this.redirectSuccess(this.$route.query.alert, this.$route.query.notice)
        }
        break
      case 'false':
        return this.$router.push({ path: '/users/confirmation/new', query: { alert: this.$route.query.alert, notice: this.$route.query.notice } })
    }
    switch (this.$route.query.unlock) {
      case 'true':
      case 'false':
        if (this.$auth.loggedIn) {
          return this.redirectSuccess(this.$route.query.alert, this.$route.query.notice)
        }
    }

    if (this.$auth.loggedIn) {
      return this.redirectAlreadyAuth()
    }

    if (this.$route.query.account_confirmation_success === 'true' || this.$route.query.unlock === 'true') {
      this.$route.query.notice += this.$t('auth.unauthenticated')
    }

    this.setQueryMessage()
    this.loading = false
  }
}
</script>
