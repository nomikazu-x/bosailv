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
          <v-col cols="12">
            <CitiesSelect
              v-model="selectCity"
              :cities="cities"
              @click="waiting = false"
            />
          </v-col>
          <v-col cols="12">
            <div class="text-center">
              <RedBtn @click="onSearchHazardMap">検索</RedBtn>
            </div>
          </v-col>
        </v-row>
        <!-- <v-row justify="center">
          <v-col cols="12">
            <ArticleListCardWithTab
              :articles="articles"
              :info="info"
              :processing="processing"
              @pagination="onSearchArticlePagination"
            />
          </v-col>
        </v-row> -->
      </BaseTitleCard>
    </v-col>
  </v-row>
</template>

<script>
import Application from '~/plugins/application.js'
import BaseTitleCard from '~/components/molecules/cards/BaseTitleCard.vue'
import PrefecturesSelect from '~/components/organisms/select/PrefecturesSelect.vue'
import CitiesSelect from '~/components/organisms/select/CitiesSelect.vue'
import RedBtn from '~/components/atoms/btns/RedBtn.vue'

export default {
  name: 'HazardMapSearchCard',

  components: {
    BaseTitleCard,
    PrefecturesSelect,
    CitiesSelect,
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
  },

  methods: {
    async onSearchHazardMap () {
      this.processing = true

      await this.$axios.get(this.$config.apiBaseURL + this.$config.hazardMapUrl, {
        params: { id: this.selectCity }
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
