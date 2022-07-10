<template>
  <OneColumnContainer>
    <TheLoading v-if="loading" />
    <TheMessage v-if="!loading" :alert="alert" :notice="notice" />

    <PasswordResetConfirmCard v-if="!loading" @alert="alert = $event" @notice="notice = $event" />
  </OneColumnContainer>
</template>

<script>
import Application from '~/plugins/application.js'
import OneColumnContainer from '~/components/molecules/containers/OneColumnContainer.vue'
import TheLoading from '~/components/organisms/application/TheLoading.vue'
import TheMessage from '~/components/organisms/application/TheMessage.vue'
import PasswordResetConfirmCard from '~/components/organisms/cards/PasswordResetConfirmCard.vue'

export default {
  name: 'PasswordResetConfirm',

  components: {
    OneColumnContainer,
    TheLoading,
    TheMessage,
    PasswordResetConfirmCard
  },

  mixins: [Application],

  created () {
    if (this.$auth.loggedIn) {
      return this.redirectAlreadyAuth()
    }
    if (this.$route.query.reset_password === 'false') {
      return this.$router.push({ path: '/password/reset', query: { alert: this.$route.query.alert, notice: this.$route.query.notice } })
    }
    if (!this.$route.query.reset_password_token) {
      return this.$router.push({ path: '/password/reset', query: { alert: this.$t('auth.reset_password_token_blank') } })
    }
    this.loading = false
  }
}
</script>
