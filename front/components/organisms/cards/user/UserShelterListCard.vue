<template>
  <v-row justify="center">
    <v-col cols="12">
      <BaseTitleCard :title="cardTitle">
        <v-card v-if="shelters != null && shelters.length === 0" outlined tile>
          <v-card-title class="ml-1">該当する避難所はありません。</v-card-title>
          <div class="text-center">
            <v-card-text>
              <NuxtLink to="/shelters" class="text-decoration-none">避難所を探してみる</NuxtLink>
            </v-card-text>
          </div>
        </v-card>
        <SheltersMap
          v-if="shelters !== null"
          :shelters="shelters"
        />
        <div v-for="shelter in shelters" :key="shelter.id">
          <ShelterListCardText
            :shelter="shelter"
          />
        </div>

        <ThePagination
          class="my-3"
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
import SheltersMap from '~/components/organisms/maps/SheltersMap.vue'
import ShelterListCardText from '~/components/organisms/cardText/ShelterListCardText.vue'
import ThePagination from '~/components/organisms/pagination/ThePagination.vue'

export default {
  name: 'UserShelterListCard',

  components: {
    BaseTitleCard,
    SheltersMap,
    ShelterListCardText,
    ThePagination
  },

  mixins: [Application],

  data () {
    return {
      user: null,
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
    await this.$axios.get(this.$config.apiBaseURL + this.$config.userShowUrl.replace('_username', this.currentUsername))
      .then((response) => {
        if (response.data == null) {
          this.$toasted.error(this.$t('system.error'))
          return this.$router.push({ path: '/home' })
        } else {
          this.user = response.data.user
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
    await this.onSheltersPagination(this.page)
    this.processing = false
  },

  methods: {
    async onSheltersPagination (page) {
      this.processing = true

      await this.$axios.get(this.$config.apiBaseURL + this.$config.sheltersUrl, {
        params: { page, disaster_type: this.selectDisasterType, username: this.currentUsername }
      })
        .then((response) => {
          if (response.data == null || response.data.shelters == null) {
            this.$toasted.error(this.$t('system.error'))
            if (this.info == null) {
              return this.$router.push({ path: '/home' })
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
            return this.$router.push({ path: '/home' })
          }
          this.page = this.info.current_page
        })

      this.processing = false
    }
  }
}
</script>
