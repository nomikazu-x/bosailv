<template>
  <OneColumnContainer>
    <TheLoading v-if="loading" />
    <TheMessage v-if="!loading" :alert="alert" :notice="notice" />

    <PasswordResetCard v-if="!loading" />
  </OneColumnContainer>
</template>

<script>
import Application from '~/plugins/application.js'
import OneColumnContainer from '~/components/molecules/containers/OneColumnContainer.vue'
import TheLoading from '~/components/organisms/application/TheLoading.vue'
import TheMessage from '~/components/organisms/application/TheMessage.vue'
import PasswordResetCard from '~/components/organisms/cards/PasswordResetCard.vue'

export default {
  name: 'PasswordResetIndex',

  components: {
    OneColumnContainer,
    TheLoading,
    TheMessage,
    PasswordResetCard
  },

  mixins: [Application],

  created () {
    if (this.$auth.loggedIn) {
      return this.redirectAlreadyAuth()
    }
    this.loading = false
  }
}
</script>
