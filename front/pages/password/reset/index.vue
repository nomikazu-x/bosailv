<template>
  <OneColumnContainer>
    <TheLoading v-if="loading" />
    <TheMessage v-if="!loading" :alert="alert" :notice="notice" />

    <PasswordResetCard v-if="!loading" />
  </OneColumnContainer>
</template>

<script>
import Application from '~/plugins/application.js'

export default {
  name: 'PasswordResetIndex',

  mixins: [Application],

  created () {
    if (this.$auth.loggedIn) {
      return this.redirectAlreadyAuth()
    }
    this.loading = false
  }
}
</script>
