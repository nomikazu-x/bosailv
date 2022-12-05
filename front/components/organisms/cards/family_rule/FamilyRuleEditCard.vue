<template>
  <v-row v-if="familyRule !== null" justify="center">
    <v-col cols="12">
      <BaseTitleCard title="おうち防災メモ用ページ" />
      <FamilyRuleEditForm
        :family-rule="familyRule"
        :processing="processing"
        @family-rule-update="onFamilyRuleUpdate"
      />
    </v-col>
  </v-row>
</template>

<script>
import Application from '~/plugins/application.js'
import BaseTitleCard from '~/components/molecules/cards/BaseTitleCard.vue'
import FamilyRuleEditForm from '~/components/organisms/form/FamilyRuleEditForm.vue'

export default {
  name: 'FamilyRuleEditCard',

  components: {
    BaseTitleCard,
    FamilyRuleEditForm
  },

  mixins: [Application],

  data () {
    return {
      errors: null,
      familyRule: null
    }
  },
  async created () {
    await this.$axios.get(this.$config.apiBaseURL + this.$config.familyRuleUrl)
      .then((response) => {
        if (response.data == null) {
          this.$toasted.error(this.$t('system.error'))
          return this.$router.push({ path: '/home' })
        } else {
          this.familyRule = response.data.family_rule
        }
      },
      (error) => {
        if (error.response == null) {
          this.$toasted.error(this.$t('network.failure'))
        } else if (error.response.status === 401) {
          return this.signOut()
        } else {
          this.$toasted.error(this.$t('network.error'))
        }
        return this.$router.push({ path: '/home' })
      })

    this.processing = false
  },

  methods: {
    async onFamilyRuleUpdate (familyRuleInfo) {
      this.processing = true

      const params = new FormData()
      params.append('family_rule[contact_means_memo]', familyRuleInfo.contact_means_memo)
      params.append('family_rule[refuge_memo]', familyRuleInfo.refuge_memo)
      params.append('family_rule[family_role_memo]', familyRuleInfo.family_role_memo)
      params.append('family_rule[emergency_measure_memo]', familyRuleInfo.emergency_measure_memo)
      params.append('family_rule[leave_home_memo]', familyRuleInfo.leave_home_memo)

      await this.$axios.post(this.$config.apiBaseURL + this.$config.familyRuleUpdateUrl, params)
        .then((response) => {
          if (response.data == null) {
            this.$toasted.error(this.$t('system.error'))
          } else {
            this.$toasted.error(response.data.alert)
            this.$toasted.success(response.data.notice)
            this.$router.push({ path: '/family_rule' })
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
