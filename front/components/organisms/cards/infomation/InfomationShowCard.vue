<template>
  <v-row v-if="infomation != null" justify="center">
    <v-col cols="12">
      <BaseTitleCard title="お知らせ">
        <TheProcessing v-if="processing" />
        <div class="pa-3">
          <v-card-title v-if="infomation">
            <InfomationLabel :infomation="infomation" />
            <span class="ml-1 font-weight-bold">
              {{ infomation.title }}
            </span>
          </v-card-title>
          <div class="text-right">
            <span class="mr-5">
              <v-icon>mdi-calendar-range</v-icon>
              {{ $dateFormat(infomation.started_at, 'ja') }}
            </span>
          </div>
          <v-card-text v-if="infomation">
            <ReadOnlyEditor v-if="infomation.body" class="mx-2 my-2" :content="infomation.body" />
            <div v-else-if="infomation.summary" class="mx-2 my-2">
              {{ infomation.summary }}
            </div>
            <div v-if="$auth.user.admin === true" class="text-right">
              <DeleteConfirmDialog title="おしらせ削除" @click="onInfomationDelete" />
            </div>
          </v-card-text>
          <v-divider />
          <div class="text-right mt-3">
            <NuxtLink to="/infomations" class="ml-2 text-decoration-none">一覧へ</NuxtLink>
          </div>
        </div>
      </BaseTitleCard>
    </v-col>
  </v-row>
</template>

<script>
import Application from '~/plugins/application.js'
import BaseTitleCard from '~/components/molecules/cards/BaseTitleCard.vue'
import InfomationLabel from '~/components/atoms/label/InfomationLabel.vue'
import ReadOnlyEditor from '~/components/organisms/editor/ReadOnlyEditor.vue'
import DeleteConfirmDialog from '~/components/organisms/dialogs/DeleteConfirmDialog.vue'

export default {
  name: 'InfomationShowCard',

  components: {
    BaseTitleCard,
    InfomationLabel,
    ReadOnlyEditor,
    DeleteConfirmDialog
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
          return this.$router.push({ path: '/home' })
        }
        this.infomation = response.data.infomation
      },
      (error) => {
        if (error.response == null) {
          this.$toasted.error(this.$t('network.failure'))
          return this.$router.push({ path: '/home' })
        } else if (error.response.data == null && error.response.status !== 404) {
          this.$toasted.error(this.$t('network.error'))
          return this.$router.push({ path: '/home' })
        } else {
          if (error.response.data != null) {
            this.$toasted.error(error.response.data.alert)
            this.$toasted.success(error.response.data.notice)
          }
          return this.$nuxt.error({ statusCode: error.response.status })
        }
      })

    this.processing = false
  },

  methods: {
    async onInfomationDelete () {
      this.processing = true

      await this.$axios.post(this.$config.apiBaseURL + this.$config.adminInfomationDeleteUrl.replace('_id', this.$route.params.id))
        .then((response) => {
          if (response.data == null) {
            this.$toasted.error(this.$t('system.error'))
          } else {
            this.$toasted.error(response.data.alert)
            this.$toasted.success(response.data.notice)
            return this.$router.push({ path: '/admin/infomations' })
          }
        },
        (error) => {
          if (error.response == null) {
            this.$toasted.error(this.$t('network.failure'))
          } else if (error.response.status === 401) {
            return this.signOut()
          } else if (error.response.data == null) {
            this.$toasted.error(this.$t('network.error'))
          } else {
            this.$toasted.error(error.response.data.alert)
            this.$toasted.success(error.response.data.notice)
          }
        })

      this.processing = false
    }
  }
}
</script>
