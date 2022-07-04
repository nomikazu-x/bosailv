<template>
  <BaseTitleCard v-if="infomations != null && infomations.length > 0" title="大切なお知らせ">
    <v-card>
      <v-card-text>
        <article v-for="infomation in infomations" :key="infomation.id" class="mb-1">
          <span class="ml-1">
            <InfomationLabel :infomation="infomation" />
            <template v-if="infomation.body_present === true || infomation.summary !== null">
              <NuxtLink :to="{ name: 'infomations-id___ja', params: { id: infomation.id }}" class="text-decoration-none">{{ infomation.title }}</NuxtLink>
            </template>
            <template v-else>
              {{ infomation.title }}
            </template>
          </span>
          <span class="ml-1">
            ({{ $dateFormat(infomation.started_at, 'ja') }})
          </span>
        </article>
      </v-card-text>
    </v-card>
  </BaseTitleCard>
</template>

<script>
export default {
  name: 'ImportantInfomationListCard',
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
