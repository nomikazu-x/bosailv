<template>
  <TwoColumnContainer
    :left-cols="12"
    :left-sm="8"
    :right-cols="12"
    :right-sm="4"
  >
    <template #top>
      <TheLoading v-if="loading" />
      <TheMessage v-if="!loading" :alert="alert" :notice="notice" />
    </template>

    <template v-if="!loading" #left>
      <EmergencyContactIntroCard class="mb-5" />
      <EmergencyContactListCard v-if="$auth.loggedIn" />
    </template>

    <template v-if="!loading" #right>
      <DefaultRightColumnTemplate />
    </template>
  </TwoColumnContainer>
</template>

<script>
import Application from '~/plugins/application.js'
import TwoColumnContainer from '~/components/molecules/containers/TwoColumnContainer.vue'
import TheLoading from '~/components/organisms/application/TheLoading.vue'
import TheMessage from '~/components/organisms/application/TheMessage.vue'
import EmergencyContactIntroCard from '~/components/organisms/cards/emergency_contact/EmergencyContactIntroCard.vue'
import EmergencyContactListCard from '~/components/organisms/cards/task/EmergencyContactListCard.vue'
import DefaultRightColumnTemplate from '~/components/templates/DefaultRightColumnTemplate.vue'

export default {
  name: 'TasksEmergencyContacts',

  components: {
    TwoColumnContainer,
    TheLoading,
    TheMessage,
    EmergencyContactIntroCard,
    EmergencyContactListCard,
    DefaultRightColumnTemplate
  },

  mixins: [Application],

  created () {
    this.loading = false
  }
}
</script>
