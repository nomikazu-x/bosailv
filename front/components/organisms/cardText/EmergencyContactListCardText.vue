<template>
  <v-card-text>
    <TheProcessing v-if="processing" />
    <v-row>
      <v-col cols="12">
        <!-- eslint-disable-next-line vue/no-v-html -->
        <v-card-title>{{ emergencyContact.name }}</v-card-title>
        <!-- eslint-disable-next-line vue/no-v-html -->
        <v-card-text>
          <a class="text-decoration-none" :href="`tel:${emergencyContact.phone_number}`">
            {{ emergencyContact.phone_number }}
          </a>
        </v-card-text>
        <div class="text-right">
          <v-btn icon>
            <v-icon size="20" @click="onEmergencyContactDelete(emergencyContact.id)">
              mdi-trash-can-outline
            </v-icon>
          </v-btn>
        </div>
        <v-divider class="my-4" />
      </v-col>
    </v-row>
  </v-card-text>
</template>

<script>
import Application from '~/plugins/application.js'

export default {
  name: 'EmergencyContactListCardText',

  mixins: [Application],

  props: {
    emergencyContact: {
      type: Object,
      default: null
    }
  },

  created () {
    this.processing = false
  },

  methods: {
    async onEmergencyContactDelete (emergencyContactId) {
      this.processing = true

      await this.$axios.post(this.$config.apiBaseURL + this.$config.emergencyContactDeleteUrl.replace('_id', emergencyContactId))
        .then((response) => {
          if (response.data == null) {
            this.$toasted.error(this.$t('system.error'))
          } else {
            this.$auth.setUser(response.data.user)
            this.$store.commit('emergencyContacts/deleteEmergencyContact', emergencyContactId, { root: true })
            this.$toasted.error(response.data.alert)
            this.$toasted.info(response.data.notice)
          }
        },
        (error) => {
          if (error.response == null) {
            this.$toasted.error(this.$t('network.failure'))
          } else if (error.response.data == null) {
            this.$toasted.error(this.$t('network.error'))
          } else {
            this.$toasted.error(error.response.data.alert)
            this.$toasted.info(error.response.data.notice)
          }
        })

      this.processing = false
    }
  }
}
</script>
