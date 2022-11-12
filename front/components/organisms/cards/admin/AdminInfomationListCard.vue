<template>
  <v-row v-if="infomations != null" justify="center">
    <v-col cols="12">
      <BaseTitleCard title="通知一覧">
        <TheProcessing v-if="processing" />
        <v-card-title v-if="infomations != null && infomations.length === 0" class="ml-1">お知らせはありません。</v-card-title>
        <InfomationListItem
          v-for="infomation in infomations"
          :key="infomation.id"
          :infomation="infomation"
        />

        <ThePagination
          class="my-3"
          :info="infomationInfo"
          @pagination="onInfomationPagination"
        />
      </BaseTitleCard>
    </v-col>
  </v-row>
</template>

<script>
import Application from '~/plugins/application.js'
import BaseTitleCard from '~/components/molecules/cards/BaseTitleCard.vue'
import InfomationListItem from '~/components/organisms/items/InfomationListItem.vue'
import ThePagination from '~/components/organisms/pagination/ThePagination.vue'

export default {
  name: 'InfomationListCard',

  components: {
    BaseTitleCard,
    InfomationListItem,
    ThePagination
  },

  mixins: [Application],

  data () {
    return {
      page: 1,
      infomationInfo: null,
      infomations: null
    }
  },

  async created () {
    await this.onInfomationPagination(this.page)
    this.processing = false
  },

  methods: {
    async onInfomationPagination (page) {
      this.processing = true

      await this.$axios.get(this.$config.apiBaseURL + this.$config.adminInfomationsUrl, { params: { page } })
        .then((response) => {
          if (response.data == null || response.data.infomation == null) {
            this.$toasted.error(this.$t('system.error'))
            if (this.infomationInfo == null) {
              return this.$router.push({ path: '/home' })
            }
            this.page = this.infomationInfo.current_page
          } else {
            this.infomationInfo = response.data.infomation
            this.infomations = response.data.infomations
          }
        },
        (error) => {
          this.$toasted.error(this.$t(error.response == null ? 'network.failure' : 'network.error'))
          if (this.infomationInfo == null) {
            return this.$router.push({ path: '/home' })
          }
          this.page = this.infomationInfo.current_page
        })

      this.processing = false
    }
  }
}
</script>
