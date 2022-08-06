<template>
  <v-row v-if="shelter !== null" justify="center">
    <v-col cols="12">
      <v-card outlined tile>
        <v-col cols="12">
          <ShelterDetailMap :shelter="shelter" />
          <v-card-title class="font-weight-bold mt-3">
            {{ shelter.name }}
          </v-card-title>

          <v-divider class="my-3" />
          <v-card-text>
            住所：{{ shelter.address }}
          </v-card-text>
        </v-col>
        <div class="text-center mb-5">
          <ShelterRegistrationBtnGroup v-if="$auth.loggedIn" :shelter="shelter" />
        </div>
      </v-card>
    </v-col>
  </v-row>
</template>

<script>
import ShelterDetailMap from '~/components/organisms/maps/ShelterDetailsMap.vue'
import ShelterRegistrationBtnGroup from '~/components/organisms/btnGroup/ShelterRegistrationBtnGroup.vue'

export default {
  name: 'ShelterDetailCard',

  components: {
    ShelterDetailMap,
    ShelterRegistrationBtnGroup
  },

  data () {
    return {
      errors: null,
      shelter: null
    }
  },

  async created () {
    await this.$axios.get(this.$config.apiBaseURL + this.$config.shelterShowUrl.replace('_id', this.$route.params.id))
      .then((response) => {
        if (response.data == null) {
          this.$toasted.error(this.$t('system.error'))
          return this.$router.push({ path: '/' })
        }
        this.shelter = response.data.shelter
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
            this.$toasted.info(error.response.data.notice)
          }
          return this.$nuxt.error({ statusCode: error.response.status })
        }
      })

    this.processing = false
  }
}
</script>
