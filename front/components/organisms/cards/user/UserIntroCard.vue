<template>
  <BaseTitleCard v-if="user != null" :title="cardTitle">
    <v-card class="text-center pt-4 py-2">
      <div>
        <v-row justify="center" class="my-4">
          <AvatarIcon :src="user.image_url.medium" :alt="`${user.name} - avatar`" />
        </v-row>

        <p class="name mb-4">
          <nuxt-link :to="`/users/${user.username}`" class="black--text text-decoration-none">{{ user.name }}</nuxt-link>
        </p>

        <div>
          <v-row class="py-5">
            <v-col cols="6">
              <v-row justify="center">
                <h1>Lv.{{ user.level }}</h1>
              </v-row>
              <v-row justify="center">
                <span>Level</span>
              </v-row>
            </v-col>

            <v-col cols="6">
              <v-row justify="center">
                <h1>{{ user.lifelong_point }}</h1>
              </v-row>
              <v-row justify="center">
                <span>合計EXP</span>
              </v-row>
            </v-col>
          </v-row>

          <PointProgressLinear
            :required-point="user.required_point"
            :point-to-next="user.point_to_next"
            class="pb-2"
          />
        </div>

        <p v-if="user.profile" class="text-center mb-4 px-8 px-sm-12">{{ user.profile }}</p>

        <div class="my-3">
          <p v-if="getAddress">
            <span class="text-uppercase">FROM</span>: {{ getAddress }}
          </p>

          <GreenBtn :to="`/users/${user.username}`" text color="primary">{{ user.name }}のページ</GreenBtn>
        </div>
      </div>
    </v-card>
  </BaseTitleCard>
</template>

<script>
import Application from '~/plugins/application.js'
import BaseTitleCard from '~/components/molecules/cards/BaseTitleCard.vue'
import AvatarIcon from '~/components/atoms/icons/AvatarIcon.vue'
import PointProgressLinear from '~/components/organisms/progressLinear/PointProgressLinear.vue'
import GreenBtn from '~/components/atoms/btns/GreenBtn.vue'

export default {
  name: 'UserIntroCard',

  components: {
    BaseTitleCard,
    AvatarIcon,
    PointProgressLinear,
    GreenBtn
  },

  mixins: [Application],

  data () {
    return {
      user: null,
      requiredPoint: 0
    }
  },

  computed: {
    getAddress () {
      if (this.user.prefecture && this.user.city) {
        return this.user.prefecture.name + this.user.city.name
      }
      return null
    },
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
    cardTitle () {
      return (this.canAction ? 'あなた' : this.user.name) + 'の情報'
    }
  },
  async created () {
    await this.$axios.get(this.$config.apiBaseURL + this.$config.userShowUrl.replace('_username', this.currentUsername))
      .then((response) => {
        if (response.data == null) {
          this.$toasted.error(this.$t('system.error'))
          return this.$router.push({ path: '/' })
        } else {
          this.user = response.data.user
          this.requiredPoint = response.data.required_point
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
        return this.$router.push({ path: '/' })
      })

    this.processing = false
  }
}
</script>

<style lang="scss" scoped>
.name {
  font-size: 1.5rem;
  font-weight: bold;
}
</style>
