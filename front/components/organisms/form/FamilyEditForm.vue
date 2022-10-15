<template>
  <ValidationObserver v-slot="{ invalid }" ref="observer">
    <TheProcessing v-if="processing" />
    <v-form autocomplete="off">
      <v-card-text>
        <BaseSelect
          v-model="selectSex"
          :items="sexItems"
          item-text="name"
          item-value="label"
          name="sex"
          label="性別"
        />
        <BaseSelect
          v-model="selectAge"
          :items="ageItems"
          item-text="name"
          item-value="label"
          name="age"
          label="世代"
        />
        <div class="text-center">
          <OrangeBtn
            id="family_update_btn"
            :disabled="invalid || processing"
            @click="onFamilyCreate"
          >
            登録
          </OrangeBtn>
        </div>
      </v-card-text>
    </v-form>
  </ValidationObserver>
</template>

<script>
import { ValidationObserver } from 'vee-validate'
import Application from '~/plugins/application.js'
import BaseSelect from '~/components/molecules/select/BaseSelect.vue'
import OrangeBtn from '~/components/atoms/btns/OrangeBtn.vue'

export default {
  name: 'FamilyEditForm',

  components: {
    ValidationObserver,
    BaseSelect,
    OrangeBtn
  },

  mixins: [Application],

  props: {
    family: {
      type: Object,
      default: null
    }
  },

  data () {
    return {
      sexItems: [
        { name: '男性', label: 'Male' },
        { name: '女性', label: 'Female' }
      ],
      ageItems: [
        { name: '乳幼児(0~2歳)', label: 'Infant' },
        { name: '子供(3歳~小6)', label: 'Child' },
        { name: '子供(中学生以上)', label: 'Junior' },
        { name: '成人(20歳以上)', label: 'Adult' },
        { name: '高齢者(65歳以上)', label: 'Senior' }
      ],
      selectAge: null,
      selectSex: null
    }
  },

  created () {
    this.processing = false
  },

  methods: {
    async onFamilyCreate () {
      this.processing = true

      const params = new FormData()
      params.append('family[sex]', this.selectSex)
      params.append('family[age]', this.selectAge)

      await this.$axios.post(this.$config.apiBaseURL + this.$config.familyCreateUrl, params)
        .then((response) => {
          if (response.data == null) {
            this.$toasted.error(this.$t('system.error'))
          } else {
            this.$store.commit('families/addFamilies', response.data.family, { root: true })
            this.$auth.setUser(response.data.user)
            this.age = null
            this.sex = null
            this.$refs.observer.reset()
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
            this.$emit('alert', error.response.data.alert)
            this.$emit('notice', error.response.data.notice)
          }
        })

      this.processing = false
    }
  }
}
</script>
