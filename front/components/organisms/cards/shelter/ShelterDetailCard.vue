<template>
  <div v-if="shelter !== null">
    <TheMessage :alert="alert" :notice="notice" />

    <v-row justify="center">
      <v-col cols="12">
        <v-card outlined tile>
          <v-col cols="12">
            <ShelterDetailMap :shelter="shelter" />
            <v-card-title class="font-weight-bold mt-3">
              {{ shelter.name }}
            </v-card-title>
            <v-row no-gutters justify="center">
              <v-col v-for="info in shelterInfo" :key="info.id" cols="1.5">
                <div class="text-center">
                  <v-icon class="mb-1" color="#117768" large>{{ info.icon }}</v-icon>
                </div>
                <div class="text-caption text-center">{{ info.type }}</div>
                <div v-if="info.is_selected" class="text-caption text-center font-weight-bold">○</div>
                <div v-else class="text-caption text-center">×</div>
              </v-col>
            </v-row>

            <v-divider class="my-3" />
            <v-card-text>
              住所：{{ shelter.address }}
            </v-card-text>
            <v-card-text v-if="shelter.duplicate">
              指定避難所
            </v-card-text>
            <v-card-text v-if="shelter.remark">
              備考：{{ shelter.remark }}
            </v-card-text>
          </v-col>
          <div class="text-center mb-5">
            <ShelterRegistrationBtnGroup v-if="$auth.loggedIn" :shelter="shelter" @alert="alert = $event" @notice="notice = $event" />
          </div>
        </v-card>
      </v-col>
    </v-row>
  </div>
</template>

<script>
import Application from '~/plugins/application.js'
import ShelterDetailMap from '~/components/organisms/maps/ShelterDetailsMap.vue'
import ShelterRegistrationBtnGroup from '~/components/organisms/btnGroup/ShelterRegistrationBtnGroup.vue'

export default {
  name: 'ShelterDetailCard',

  components: {
    ShelterDetailMap,
    ShelterRegistrationBtnGroup
  },

  mixins: [Application],

  data () {
    return {
      shelter: null
    }
  },

  computed: {
    shelterInfo () {
      if (this.shelter !== null) {
        return [
          { id: 1, type: '洪水', is_selected: this.shelter.flood, icon: 'mdi-home-flood' },
          { id: 2, type: '土砂災害', is_selected: this.shelter.landslide, icon: 'mdi-landslide' },
          { id: 3, type: '高潮', is_selected: this.shelter.storm_surge, icon: 'mdi-tsunami' },
          { id: 4, type: '地震', is_selected: this.shelter.earthquake, icon: 'mdi-image-broken-variant' },
          { id: 5, type: '津波', is_selected: this.shelter.tsunami, icon: 'mdi-tsunami' },
          { id: 6, type: '火事', is_selected: this.shelter.fire, icon: 'mdi-fire' },
          { id: 7, type: '内水氾濫', is_selected: this.shelter.inland_flood, icon: 'mdi-home-flood' },
          { id: 8, type: '火山噴火', is_selected: this.shelter.volcano, icon: 'mdi-volcano' }
        ]
      } else {
        return null
      }
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
            this.$toasted.success(error.response.data.notice)
          }
          return this.$nuxt.error({ statusCode: error.response.status })
        }
      })

    this.processing = false
  }
}
</script>
