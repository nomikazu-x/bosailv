<template>
  <ValidationObserver v-slot="{ invalid }" ref="observer">
    <TheProcessing v-if="processing" />
    <v-form autocomplete="off">
      <v-card-text>
        <UserNameTextField
          v-model="name"
          @click="waiting = false"
        />
        <PrefecturesSelect
          v-model="selectPrefecture"
          :prefectures="prefectures"
          class="mt-5"
          @change="onGetCities"
        />
        <CitiesSelect
          v-model="selectCity"
          :cities="cities"
          @click="waiting = false"
        />
        <ProfileTextarea
          v-model="profile"
          @click="waiting = false"
        />
        <RedBtn
          id="user_update_btn"
          :disabled="invalid || processing || waiting"
          @click="onUserUpdate"
        >
          変更
        </RedBtn>
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
      selectCity: null,
      profile: '',
      waiting: false
    }
  },

  async created () {
    this.name = this.name || this.user.name
    this.profile = this.profile || this.user.profile
    if (this.user.prefecture && this.user.city) {
      this.selectPrefecture = this.selectPrefecture || this.user.prefecture.id
      await this.onGetCities(this.selectPrefecture)
      this.selectCity = this.selectCity || this.user.city.id
    }
    this.waiting = true
  },

  methods: {
    onUserUpdate () {
      const userInfo = {
        name: this.name,
        selectPrefecture: this.selectPrefecture,
        selectCity: this.selectCity,
        profile: this.profile
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
            this.waiting = true
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
            this.waiting = true
          }
        })
    }
  }
}
</script>
