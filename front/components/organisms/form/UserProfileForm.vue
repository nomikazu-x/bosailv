<template>
  <ValidationObserver v-slot="{ invalid }" ref="observer">
    <TheProcessing v-if="processing" />
    <v-form autocomplete="off">
      <v-card-text>
        <BaseTextField
          v-model="name"
          name="name"
          label="氏名"
          @click="waiting = false"
        />
        <PrefecturesSelect
          v-model="selectPrefecture"
          class="mt-5"
          @change="onGetCities"
        />
        <CitiesSelect
          v-model="selectCity"
          :cities="cities"
          @click="waiting = false"
        />
        <BaseTextarea
          v-model="profile"
          name="profile"
          label="プロフィール"
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
import { ValidationObserver } from 'vee-validate'
import TheProcessing from '~/components/organisms/application/TheProcessing.vue'
import BaseTextField from '~/components/molecules/textFields/BaseTextField.vue'
import PrefecturesSelect from '~/components/organisms/select/PrefecturesSelect.vue'
import CitiesSelect from '~/components/organisms/select/CitiesSelect.vue'
import BaseTextarea from '~/components/molecules/textarea/BaseTextarea.vue'
import RedBtn from '~/components/atoms/btns/RedBtn.vue'

export default {
  name: 'UserProfileForm',

  components: {
    ValidationObserver,
    TheProcessing,
    BaseTextField,
    PrefecturesSelect,
    CitiesSelect,
    BaseTextarea,
    RedBtn
  },

  props: {
    processing: {
      type: Boolean,
      default: false
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
      this.selectPrefecture = this.user.prefecture.id
      await this.onGetCities(this.selectPrefecture)
      this.selectCity = this.user.city.id
    }
    this.waiting = false
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
