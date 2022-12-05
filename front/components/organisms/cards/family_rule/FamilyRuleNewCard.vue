<template>
  <v-row justify="center">
    <v-col cols="12">
      <BaseTitleCard title="おうち防災メモ用ページ" />
      <FamilyRuleNewForm
        :family-rule="familyRule"
        :processing="processing"
        @family-rule-create="onFamilyRuleCreate"
      />
    </v-col>
  </v-row>
</template>

<script>
import Application from '~/plugins/application.js'
import BaseTitleCard from '~/components/molecules/cards/BaseTitleCard.vue'
import FamilyRuleNewForm from '~/components/organisms/form/FamilyRuleNewForm.vue'

export default {
  name: 'FamilyRuleNewCard',

  components: {
    BaseTitleCard,
    FamilyRuleNewForm
  },

  mixins: [Application],

  data () {
    return {
      errors: null,
      familyRule: null
    }
  },
  created () {
    this.processing = false
  },

  methods: {
    async onFamilyRuleCreate (familyRuleInfo) {
      this.processing = true

      const params = new FormData()
      params.append('family_rule[contact_means_memo]', familyRuleInfo.contact_means_memo)
      params.append('family_rule[refuge_memo]', familyRuleInfo.refuge_memo)
      params.append('family_rule[family_role_memo]', familyRuleInfo.family_role_memo)
      params.append('family_rule[emergency_measure_memo]', familyRuleInfo.emergency_measure_memo)
      params.append('family_rule[leave_home_memo]', familyRuleInfo.leave_home_memo)

      await this.$axios.post(this.$config.apiBaseURL + this.$config.familyRuleCreateUrl, params)
        .then((response) => {
          if (response.data == null) {
            this.$toasted.error(this.$t('system.error'))
          } else {
            this.$store.commit('user/setLevel', response.data.user.level, { root: true })
            this.$auth.setUser(response.data.user)
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
