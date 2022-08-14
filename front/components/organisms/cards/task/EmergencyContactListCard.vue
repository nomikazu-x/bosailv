<template>
  <v-row justify="center">
    <v-col cols="12">
      <TheMessage :alert="alert" :notice="notice" />
      <BaseTitleCard class="mt-3" title="緊急連絡先一覧">
        <div class="pa-5">
          <article v-if="emergencyContacts !== null && emergencyContacts.length === 0">
            <v-card-text>緊急連絡先はありません。</v-card-text>
            <v-divider class="my-4" />
          </article>
          <EmergencyContactListCardText v-for="emergencyContact in emergencyContacts" :key="emergencyContact.id" :emergency-contact="emergencyContact" />
          <EmergencyContactForm v-if="$auth.loggedIn" @alert="alert = $event" @notice="notice = $event" />
        </div>
      </BaseTitleCard>
    </v-col>
  </v-row>
</template>

<script>
import { mapGetters } from 'vuex'
import Application from '~/plugins/application.js'
import BaseTitleCard from '~/components/molecules/cards/BaseTitleCard.vue'
import EmergencyContactListCardText from '~/components/organisms/cardText/EmergencyContactListCardText.vue'
import EmergencyContactForm from '~/components/organisms/form/EmergencyContactForm.vue'

export default {
  name: 'EmergencyContactListCard',

  components: {
    BaseTitleCard,
    EmergencyContactListCardText,
    EmergencyContactForm
  },

  mixins: [Application],

  data () {
    return {
      errors: null
    }
  },

  computed: {
    ...mapGetters({
      emergencyContacts: 'emergencyContacts/emergencyContacts'
    })
  },

  async created () {
    await this.$axios.get(this.$config.apiBaseURL + this.$config.emergencyContactsUrl)
      .then((response) => {
        if (response.data == null) {
          this.$toasted.error(this.$t('system.error'))
          return this.$router.push({ path: '/' })
        }
        this.$store.commit('emergencyContacts/setEmergencyContacts', response.data.emergency_contacts, { root: true })
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
            this.$toasted.success(error.response.data.notice)
          }
          return this.$nuxt.error({ statusCode: error.response.status })
        }
      })

    this.processing = false
  }
}
</script>
