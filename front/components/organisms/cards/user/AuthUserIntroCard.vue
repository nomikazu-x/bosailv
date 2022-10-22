<template>
  <BaseTitleCard v-if="$auth.loggedIn && $auth.user != null" title="あなたの情報">
    <v-card class="text-center pt-4 py-2">
      <div>
        <v-row justify="center" class="my-4">
          <AvatarIcon :src="$auth.user.image_url.medium" :alt="`${$auth.user.name} - avatar`" />
        </v-row>

        <p class="name mb-4">
          <nuxt-link :to="`/users/${$auth.user.username}`" class="black--text text-decoration-none">{{ $auth.user.name }}</nuxt-link>
        </p>

        <div>
          <v-row class="py-5">
            <v-col cols="6">
              <v-row justify="center" class="amber--text">
                <h1>{{ $auth.user.level }}</h1>
              </v-row>
              <v-row justify="center">
                <span>Level</span>
              </v-row>
            </v-col>

            <v-col cols="6">
              <v-row justify="center" class="amber--text">
                <h1>{{ $auth.user.lifelong_point }}</h1>
              </v-row>
              <v-row justify="center">
                <span>Point</span>
              </v-row>
            </v-col>
          </v-row>

          <PointProgressLinear
            :required-point="$auth.user.required_point"
            :point-to-next="$auth.user.point_to_next"
            class="pb-2"
          />
        </div>

        <p v-if="$auth.user.profile" class="text-left mb-4 px-8 px-sm-12">{{ $auth.user.profile }}</p>

        <div class="my-3">
          <p v-if="getAddress">
            <span class="text-uppercase">FROM</span>: {{ getAddress }}
          </p>

          <GreenBtn :to="`/users/${$auth.user.username}`" text>マイページ</GreenBtn>
          <GreenBtn v-if="$auth.user.city" :href="jmaUrl" text>気象情報</GreenBtn>
        </div>
      </div>
    </v-card>
  </BaseTitleCard>
</template>

<script>
import BaseTitleCard from '~/components/molecules/cards/BaseTitleCard.vue'
import AvatarIcon from '~/components/atoms/icons/AvatarIcon.vue'
import PointProgressLinear from '~/components/organisms/progressLinear/PointProgressLinear.vue'
import GreenBtn from '~/components/atoms/btns/GreenBtn.vue'

export default {
  name: 'AuthUserIntroCard',

  components: {
    BaseTitleCard,
    AvatarIcon,
    PointProgressLinear,
    GreenBtn
  },

  computed: {
    getAddress () {
      if (this.$auth.user.prefecture && this.$auth.user.city) {
        return this.$auth.user.prefecture.name + this.$auth.user.city.name
      }
      return null
    },
    jmaUrl () {
      if (this.$auth.user.city.id.toString().length === 4) {
        return 'https://www.jma.go.jp/bosai/#area_type=class20s&area_code=0' + this.$auth.user.city.id + '00'
      }
      return 'https://www.jma.go.jp/bosai/#area_type=class20s&area_code=' + this.$auth.user.city.id + '00'
    }
  }
}
</script>

<style lang="scss" scoped>
.name {
  font-size: 1.5rem;
  font-weight: bold;
}
</style>
