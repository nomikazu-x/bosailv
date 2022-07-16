<template>
  <v-row justify="center">
    <v-col cols="12" sm="10" md="8">
      <BaseTitleCard title="お知らせ作成" />
      <InfomationNewForm
        :processing="processing"
        @infomation-create="onInfomationCreate"
      />
    </v-col>
  </v-row>
</template>

<script>
import Application from '~/plugins/application.js'
import BaseTitleCard from '~/components/molecules/cards/BaseTitleCard.vue'
import InfomationNewForm from '~/components/organisms/form/InfomationNewForm.vue'

export default {
  name: 'InfomationNewCard',

  components: {
    BaseTitleCard,
    InfomationNewForm
  },

  mixins: [Application],

  data () {
    return {
      errors: null
    }
  },
  created () {
    this.processing = false
  },

  methods: {
    async onInfomationCreate (infomationInfo) {
      this.processing = true

      const params = new FormData()
      params.append('infomation[label]', infomationInfo.label)
      params.append('infomation[title]', infomationInfo.title)
      params.append('infomation[summary]', infomationInfo.summary)
      params.append('infomation[body]', infomationInfo.body)
      params.append('infomation[started_at]', infomationInfo.startedAt)
      params.append('infomation[ended_at]', infomationInfo.endedAt)
      params.append('infomation[force_started_at]', infomationInfo.forceStartedAt)
      params.append('infomation[force_ended_at]', infomationInfo.forceEndedAt)
      params.append('infomation[target]', 'All')

      await this.$axios.post(this.$config.apiBaseURL + this.$config.infomationCreateUrl, params)
        .then((response) => {
          if (response.data == null) {
            this.$toasted.error(this.$t('system.error'))
          } else {
            this.$toasted.error(response.data.alert)
            this.$toasted.info(response.data.notice)
            this.$router.push({ path: '/admin/infomations' })
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
