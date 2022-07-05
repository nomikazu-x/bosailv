<template>
  <v-row v-if="infomation != null" justify="center">
    <v-col cols="12">
      <BaseTitleCard title="お知らせ">
        <div class="pa-3">
          <v-card-title v-if="infomation">
            <InfomationLabel :infomation="infomation" />
            <span class="ml-1 font-weight-bold">
              {{ infomation.title }}
            </span>
            <span class="ml-1">
              <v-icon>mdi-calendar-range</v-icon>
              {{ $dateFormat(infomation.started_at, 'ja') }}
            </span>
          </v-card-title>
          <v-card-text v-if="infomation">
            <!-- eslint-disable-next-line vue/no-v-html -->
            <div v-if="infomation.body" class="mx-2 my-2" v-html="infomation.body" />
            <!-- eslint-disable-next-line vue/no-v-html -->
            <div v-else-if="infomation.summary" class="mx-2 my-2" v-html="infomation.summary" />
          </v-card-text>
          <v-divider />
          <v-card-actions>
            <NuxtLink to="/infomations" class="ml-2 text-decoration-none">一覧へ</NuxtLink>
          </v-card-actions>
        </div>
      </BaseTitleCard>
    </v-col>
  </v-row>
</template>

<script>
import Application from '~/plugins/application.js'
import BaseTitleCard from '~/components/molecules/cards/BaseTitleCard.vue'
import InfomationLabel from '~/components/atoms/label/InfomationLabel.vue'

export default {
  name: 'InfomationShowCard',

  components: {
    BaseTitleCard,
    InfomationLabel
  },

  mixins: [Application],

  data () {
    return {
      infomation: null
    }
  },

  async created () {
    await this.$axios.get(this.$config.apiBaseURL + this.$config.infomationDetailUrl.replace('_id', this.$route.params.id))
      .then((response) => {
        if (response.data == null) {
          this.$toasted.error(this.$t('system.error'))
          return this.$router.push({ path: '/' })
        }
        this.infomation = response.data.infomation
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
          }
          return this.$nuxt.error({ statusCode: error.response.status })
        }
      })
  }
}
</script>
