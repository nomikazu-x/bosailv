<template>
  <v-row justify="center">
    <v-col cols="12">
      <BaseTitleCard title="ハザードマップ検索">
        <v-row class="pa-5">
          <v-col cols="12">
            <PrefecturesSelect
              v-model="selectPrefecture"
              class="mt-5"
              @change="onGetCities"
            />
          </v-col>
          <v-col v-if="cities.length > 0" cols="12">
            <CitiesSelect
              v-model="selectCity"
              :cities="cities"
              @click="waiting = false"
            />
          </v-col>
          <v-col cols="12">
            <div class="text-center">
              <RedBtn :disabled="waiting" @click="onSearchHazardMap(selectCity)">検索</RedBtn>
            </div>
          </v-col>
          <v-col v-if="$auth.user.city" cols="12">
            <div class="text-center">
              <RedBtn @click="onSearchHazardMap($auth.user.city.id)">自分の出身市町村で検索する</RedBtn>
            </div>
          </v-col>
        </v-row>
      </BaseTitleCard>

      <HazardMapSearchCardText v-if="hazardMap !== null" :hazard-map="hazardMap" />
    </v-col>
  </v-row>
</template>

<script>
import Application from '~/plugins/application.js'
import BaseTitleCard from '~/components/molecules/cards/BaseTitleCard.vue'
import PrefecturesSelect from '~/components/organisms/select/PrefecturesSelect.vue'
import CitiesSelect from '~/components/organisms/select/CitiesSelect.vue'
import HazardMapSearchCardText from '~/components/organisms/cardText/HazardMapSearchCardText.vue'
import RedBtn from '~/components/atoms/btns/RedBtn.vue'

export default {
  name: 'HazardMapSearchCard',

  components: {
    BaseTitleCard,
    PrefecturesSelect,
    CitiesSelect,
    HazardMapSearchCardText,
    RedBtn
  },

  mixins: [Application],

  data () {
    return {
      hazardMap: null,
      cities: [],
      selectPrefecture: null,
      selectCity: null,
      waiting: false
    }
  },

  created () {
    this.processing = false
    this.waiting = true
  },

  methods: {
    async onSearchHazardMap (cityId) {
      this.processing = true

      this.hazardMap = null

      await this.$axios.get(this.$config.apiBaseURL + this.$config.hazardMapUrl, {
        params: { id: cityId }
      })
        .then((response) => {
          if (response.data == null || response.data.hazard_map == null) {
            this.$toasted.error(this.$t('system.error'))
            return this.$router.push({ path: '/' })
          } else {
            this.hazardMap = response.data.hazard_map
            this.waiting = true
          }
        },
        (error) => {
          this.$toasted.error(this.$t(error.response == null ? 'network.failure' : 'network.error'))
          return this.$router.push({ path: '/' })
        })

      this.processing = false
    },

    async onGetCities () {
      await this.$axios.get(this.$config.apiBaseURL + this.$config.setCitiesUrl.replace('_id', this.selectPrefecture))
        .then((response) => {
          if (response.data == null) {
            this.$toasted.error(this.$t('system.error'))
            return this.$router.push({ path: '/' })
          } else {
            this.cities = response.data
            this.waiting = true
          }
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
              this.waiting = true
            }
            return this.$nuxt.error({ statusCode: error.response.status })
          }
        })
    }
  }
}
</script>
