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
              <v-row justify="center">
                <h1>Lv.{{ $auth.user.level }}</h1>
              </v-row>
              <v-row justify="center">
                <span>Level</span>
              </v-row>
            </v-col>

            <v-col cols="6">
              <v-row justify="center">
                <h1>{{ $auth.user.lifelong_point }}</h1>
              </v-row>
              <v-row justify="center">
                <span>合計EXP</span>
              </v-row>
            </v-col>
          </v-row>

          <PointProgressLinear
            :required-point="$auth.user.required_point"
            :point-to-next="$auth.user.point_to_next"
            class="pb-2"
          />
        </div>

        <p v-if="$auth.user.profile" class="text-center mb-4 px-8 px-sm-12">{{ $auth.user.profile }}</p>

        <div class="my-3">
          <p v-if="getAddress">
            <span class="text-uppercase">FROM</span>: {{ getAddress }}
          </p>

          <RedBtn :to="`/users/${$auth.user.username}`" text color="primary">マイページ</RedBtn>
        </div>
      </div>
    </v-card>
  </BaseTitleCard>
</template>

<script>
export default {
  name: 'AuthUserIntroCard',
  computed: {
    getAddress () {
      if (this.$auth.user.prefecture && this.$auth.user.city) {
        return this.$auth.user.prefecture.name + this.$auth.user.city.name
      }
      return null
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
