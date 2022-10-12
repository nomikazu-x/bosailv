<template>
  <BaseTitleCard v-if="infomations != null && infomations.length > 0" title="大切なお知らせ">
    <BaseCard v-for="infomation in infomations" :key="infomation.id" :to="{ name: 'infomations-id___ja', params: { id: infomation.id }}">
      <InfomationLabel :infomation="infomation" class="mt-3 ml-3" />
      <template v-if="infomation.body_present === true || infomation.summary !== null">
        <v-card-subtitle class="black--text font-weight-bold">{{ infomation.title }}</v-card-subtitle>
      </template>
      <v-card-subtitle v-else class="black--text font-weight-bold">
        {{ infomation.title }}
      </v-card-subtitle>
      <v-card-text class="mt-2 text-right">
        <v-icon small>mdi-calendar-range</v-icon>
        {{ $dateFormat(infomation.started_at, 'ja') }}
      </v-card-text>
      <v-divider />
    </BaseCard>
  </BaseTitleCard>
</template>

<script>
import BaseTitleCard from '~/components/molecules/cards/BaseTitleCard.vue'
import BaseCard from '~/components/molecules/cards/BaseCard.vue'
import InfomationLabel from '~/components/atoms/label/InfomationLabel.vue'

export default {
  name: 'ImportantInfomationListCard',

  components: {
    BaseTitleCard,
    BaseCard,
    InfomationLabel
  },

  data () {
    return {
      infomations: null
    }
  },
  async created () {
    await this.$axios.get(this.$config.apiBaseURL + this.$config.importantInfomationsUrl)
      .then((response) => {
        if (response.data == null) {
          this.$toasted.error(this.$t('system.error'))
          this.infomations = null
        } else {
          this.infomations = response.data.infomations
        }
      },
      (error) => {
        this.$toasted.error(this.$t(error.response == null ? 'network.failure' : 'network.error'))
      })
  }
}
</script>
