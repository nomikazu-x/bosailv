<template>
  <v-row justify="center">
    <v-col cols="12">
      <BaseTitleCard title="避難所検索">
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
              <RedBtn :disabled="waiting" @click="onSearchShelters">検索</RedBtn>
            </div>
          </v-col>
        </v-row>
      </BaseTitleCard>

      <SheltersMap v-if="shelters !== null" :shelters="shelters" />
    </v-col>
  </v-row>
</template>

<script>
import Application from '~/plugins/application.js'
import BaseTitleCard from '~/components/molecules/cards/BaseTitleCard.vue'
import PrefecturesSelect from '~/components/organisms/select/PrefecturesSelect.vue'
import CitiesSelect from '~/components/organisms/select/CitiesSelect.vue'
import SheltersMap from '~/components/organisms/maps/SheltersMap.vue'
import RedBtn from '~/components/atoms/btns/RedBtn.vue'

export default {
  name: 'SheltersMapCard',

  components: {
    BaseTitleCard,
    PrefecturesSelect,
    CitiesSelect,
    SheltersMap,
    RedBtn
  },

  mixins: [Application],

  data () {
    return {
      shelters: null,
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
    async onSearchShelters () {
      this.processing = true

      this.shelters = null

      await this.$axios.get(this.$config.apiBaseURL + this.$config.sheltersUrl, {
        params: { id: this.selectCity }
      })
        .then((response) => {
          if (response.data == null || response.data.shelters == null) {
            this.$toasted.error(this.$t('system.error'))
            return this.$router.push({ path: '/' })
          } else {
            this.shelters = response.data.shelters
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
