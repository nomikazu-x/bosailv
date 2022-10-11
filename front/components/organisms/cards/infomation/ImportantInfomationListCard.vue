<template>
  <BaseTitleCard v-if="infomations != null && infomations.length > 0" title="大切なお知らせ">
    <v-card v-for="infomation in infomations" :key="infomation.id" tile outlined>
      <InfomationLabel :infomation="infomation" class="mt-3 ml-3" />
      <v-card-text class="ml-1">
        <template v-if="infomation.body_present === true || infomation.summary !== null">
          <NuxtLink :to="{ name: 'infomations-id___ja', params: { id: infomation.id }}" class="text-decoration-none">{{ infomation.title }}</NuxtLink>
        </template>
        <template v-else>
          {{ infomation.title }}
        </template>
      </v-card-text>
      <div class="text-caption grey--text text-right mr-2">
        <v-icon small>mdi-calendar-range</v-icon>
        {{ $dateFormat(infomation.started_at, 'ja') }}
      </div>
    </v-card>
  </BaseTitleCard>
</template>

<script>
import BaseTitleCard from '~/components/molecules/cards/BaseTitleCard.vue'
import InfomationLabel from '~/components/atoms/label/InfomationLabel.vue'

export default {
  name: 'ImportantInfomationListCard',

  components: {
    BaseTitleCard,
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
