<template>
  <TwoColumnContainer
    :left-cols="12"
    :left-sm="4"
    :right-cols="12"
    :right-sm="8"
  >
    <template #top>
      <TheLoading v-if="loading" />
      <TheMessage v-if="!loading" :alert="alert" :notice="notice" />
    </template>

    <template v-if="!loading" #left>
      <SettingsIndexCard />
    </template>

    <template v-if="!loading" #right>
      <SettingsPasswordCard @alert="alert = $event" @notice="notice = $event" />
    </template>
  </TwoColumnContainer>
</template>

<script>
import Application from '~/plugins/application.js'
import TwoColumnContainer from '~/components/molecules/containers/TwoColumnContainer.vue'
import TheLoading from '~/components/organisms/application/TheLoading.vue'
import TheMessage from '~/components/organisms/application/TheMessage.vue'
import SettingsIndexCard from '~/components/organisms/cards/settings/SettingsIndexCard.vue'
import SettingsPasswordCard from '~/components/organisms/cards/settings/SettingsPasswordCard.vue'

export default {
  name: 'SettingsPassword',

  components: {
    TwoColumnContainer,
    TheLoading,
    TheMessage,
    SettingsIndexCard,
    SettingsPasswordCard
  },

  mixins: [Application],

  async created () {
    try {
      await this.$auth.fetchUser()
    } catch (error) {
      if (error.response == null) {
        this.$toasted.error(this.$t('network.failure'))
      } else if (error.response.status === 401) {
        return this.signOut()
      } else {
        this.$toasted.error(this.$t('network.error'))
      }
      return this.$router.push({ path: '/' })
    }

    if (!this.$auth.loggedIn) {
      return this.redirectAuth()
    }

    this.loading = false
  }
}
</script>
