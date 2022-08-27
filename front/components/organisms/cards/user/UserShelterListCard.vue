<template>
  <v-row justify="center">
    <v-col cols="12">
      <BaseTitleCard :title="cardTitle">
        <v-card v-if="shelters != null && shelters.length === 0" outlined tile>
          <v-card-title class="ml-1">該当する避難所はありません。</v-card-title>
        </v-card>
        <div v-for="shelter in shelters" :key="shelter.id">
          <ShelterListCardText
            :shelter="shelter"
          />
        </div>

        <ThePagination
          class="mt-5"
          :info="info"
          @pagination="onSheltersPagination"
        />
      </BaseTitleCard>
    </v-col>
  </v-row>
</template>

<script>
import Application from '~/plugins/application.js'
import BaseTitleCard from '~/components/molecules/cards/BaseTitleCard.vue'
import ShelterListCardText from '~/components/organisms/cardText/ShelterListCardText.vue'
import ThePagination from '~/components/organisms/pagination/ThePagination.vue'

export default {
  name: 'UserShelterListCard',

  components: {
    BaseTitleCard,
    ShelterListCardText,
    ThePagination
  },

  mixins: [Application],

  data () {
    return {
      page: 1,
      info: null,
      shelters: null
    }
  },

  computed: {
    authUsername () {
      return this.$auth.user.username
    },
    canAction () {
      return this.$auth.loggedIn
        ? this.currentUsername === this.authUsername
        : false
    },
    currentUsername () {
      return this.$route.params.username
    },
    currentName () {
      return (this.user && this.user.name) || this.$auth.user.name
    },
    cardTitle () {
      return (this.canAction ? 'あなた' : this.currentName) + 'の避難所一覧'
    }
  },

  async created () {
    await this.onSheltersPagination(this.page)
    this.processing = false
  },

  methods: {
    async onSheltersPagination (page) {
      this.processing = true

      await this.$axios.get(this.$config.apiBaseURL + this.$config.userSheltersUrl.replace('_username', this.currentUsername), {
        params: { page, disaster_type: this.selectDisasterType }
      })
        .then((response) => {
          if (response.data == null || response.data.shelters == null) {
            this.$toasted.error(this.$t('system.error'))
            if (this.info == null) {
              return this.$router.push({ path: '/' })
            }
            this.page = this.info.current_page
          } else {
            this.info = response.data.shelter
            this.shelters = response.data.shelters
          }
        },
        (error) => {
          this.$toasted.error(this.$t(error.response == null ? 'network.failure' : 'network.error'))
          if (this.info == null) {
            return this.$router.push({ path: '/' })
          }
          this.page = this.info.current_page
        })

      this.processing = false
    }
  }
}
</script>
