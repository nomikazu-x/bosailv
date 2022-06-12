<template>
  <ValidationObserver v-slot="{ invalid }" ref="observer">
    <Processing v-if="processing" />
    <v-form autocomplete="off">
      <v-card-text>
        <UserNameTextField
          v-model="name"
        />
        <PrefecturesSelect
          v-model="selectPrefecture"
          :prefectures="prefectures"
          @change="onGetCities"
        />
        <CitiesSelect
          v-model="selectCity"
          :cities="cities"
        />
        <OrangeBtn
          id="user_update_btn"
          :disabled="invalid || processing"
          @click="onUserUpdate"
        >
          変更
        </OrangeBtn>
      </v-card-text>
    </v-form>
  </ValidationObserver>
</template>

<script>
export default {
  name: 'InfoEdit',
  props: {
    processing: {
      type: Boolean,
      default: false
    },
    prefectures: {
      type: Array,
      default: () => []
    },
    user: {
      type: Object,
      default: null
    }
  },

  data () {
    return {
      name: '',
      selectPrefecture: null,
      cities: [],
      selectCity: null
    }
  },

  created () {
    this.name = this.name || this.user.name
    this.selectPrefecture = this.selectPrefecture || this.user.prefecture
    this.selectCity = this.selectCity || this.user.city
    this.onGetCities(this.selectPrefecture)
  },

  methods: {
    onUserUpdate () {
      const userInfo = {
        name: this.name,
        selectPrefecture: this.selectPrefecture,
        selectCity: this.selectCity
      }
      this.$emit('user-update', userInfo)
    },
    async onGetCities () {
      await this.$axios.post(this.$config.apiBaseURL + '/api/v1/set_cities', {
        id: this.selectPrefecture
      })
        .then((response) => {
          if (response.data == null) {
            this.$toasted.error(this.$t('system.error'))
          } else {
            this.$toasted.error(response.data.alert)
            this.$toasted.info(response.data.notice)
            this.cities = response.data
          }
        },
        (error) => {
          if (error.response == null) {
            this.$toasted.error(this.$t('network.failure'))
          } else if (error.response.data == null) {
            this.$toasted.error(this.$t('network.error'))
          } else {
            this.alert = error.response.data.alert
            this.notice = error.response.data.notice
          }
        })
    }
  }
}
</script>
