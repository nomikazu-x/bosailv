<template>
  <BaseTitleCard title="あなたの情報">
    <v-card class="text-center pt-4 py-2">
      <div>
        <v-row justify="center" class="my-4">
          <AvatarIcon :src="getUserImage" :alt="`${getName} - avatar`" />
        </v-row>

        <p v-if="getName" class="name mb-4">
          <nuxt-link :to="`/users/${getUsername}`" class="black--text text-decoration-none">{{ getName }}</nuxt-link>
        </p>

        <div>
          <v-row class="py-5">
            <v-col cols="6">
              <v-row justify="center">
                <h1>Lv.{{ getLevel }}</h1>
              </v-row>
              <v-row justify="center">
                <span>Level</span>
              </v-row>
            </v-col>

            <v-col cols="6">
              <v-row justify="center">
                <h1>{{ getLifelongPoint }}</h1>
              </v-row>
              <v-row justify="center">
                <span>合計EXP</span>
              </v-row>
            </v-col>
          </v-row>

          <PointProgressLinear
            :required-point="requiredPoint"
            :point-to-next="getPointToNext"
            class="pb-2"
          />
        </div>

        <p v-if="getProfile" class="text-center mb-4 px-8 px-sm-12">{{ getProfile }}</p>

        <div class="my-3">
          <p v-if="getAddress">
            <span class="text-uppercase">FROM</span>: {{ getAddress }}
          </p>

          <RedBtn :to="`/users/${getUsername}`" text color="primary">{{ getName }}のページ</RedBtn>
        </div>
      </div>
    </v-card>
  </BaseTitleCard>
</template>

<script>
export default {
  props: {
    user: {
      type: Object,
      default: null
    },
    requiredPoint: {
      type: Number,
      default: 0
    }
  },
  computed: {
    getUsername () {
      return this.user && this.user.username
    },
    getName () {
      if (!this.user) {
        return undefined
      }
      return this.user.name
    },
    getLevel () {
      return this.user && this.user.level
    },
    getLifelongPoint () {
      return this.user && this.user.lifelong_point
    },
    getPointToNext () {
      return this.user && this.user.point_to_next
    },
    getProfile () {
      return this.user && this.user.profile
    },
    getAddress () {
      return this.user && this.user.prefecture.name + this.user.city.name
    },
    getUserImage () {
      return this.user && this.user.image_url.medium
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
