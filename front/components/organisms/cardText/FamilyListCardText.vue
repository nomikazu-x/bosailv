<template>
  <v-card-text>
    <TheProcessing v-if="processing" />
    <v-row align="center">
      <v-col cols="8">
        <p>
          {{ family.sex_i18n }}/{{ family.age_i18n }}
        </p>
      </v-col>
      <v-col cols="4">
        <div class="text-right">
          <v-btn icon>
            <v-icon size="20" @click="onFamilyDelete(family.id)">
              mdi-trash-can-outline
            </v-icon>
          </v-btn>
        </div>
      </v-col>
    </v-row>
  </v-card-text>
</template>

<script>
import Application from '~/plugins/application.js'

export default {
  name: 'FamilyListCardText',

  mixins: [Application],

  props: {
    family: {
      type: Object,
      default: null
    }
  },

  created () {
    this.processing = false
  },

  methods: {
    async onFamilyDelete (familyId) {
      this.processing = true

      await this.$axios.post(this.$config.apiBaseURL + this.$config.familyDeleteUrl.replace('_id', familyId))
        .then((response) => {
          if (response.data == null) {
            this.$toasted.error(this.$t('system.error'))
          } else {
            this.$store.commit('families/deleteFamily', familyId, { root: true })
            this.$auth.setUser(response.data.user)
            this.$toasted.error(response.data.alert)
            this.$toasted.success(response.data.notice)
          }
        },
        (error) => {
          if (error.response == null) {
            this.$toasted.error(this.$t('network.failure'))
          } else if (error.response.data == null) {
            this.$toasted.error(this.$t('network.error'))
          } else {
            this.$toasted.error(error.response.data.alert)
            this.$toasted.success(error.response.data.notice)
          }
        })

      this.processing = false
    }
  }
}
</script>
