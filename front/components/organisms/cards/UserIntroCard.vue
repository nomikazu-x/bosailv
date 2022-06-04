<template>
  <v-card class="text-center pt-4 py-2">
    <div>
      <v-row justify="center" class="mb-4">
        <AvatarIcon :src="getUserImage" :alt="`${getName} - avatar`" />
      </v-row>

      <p v-if="getName" class="name mb-4">
        <nuxt-link :to="`/users/${getUserId}`" class="black--text text-decoration-none">{{ getName }}</nuxt-link>
      </p>

      <p v-if="getProfile" class="text-center mb-4 px-8 px-sm-12">{{ getProfile }}</p>

      <div class="my-3">
        <p v-if="getAddress">
          <span class="text-uppercase">FROM</span>: {{ getAddress }}
        </p>

        <v-btn :to="`/users/${getUserId}`" text color="primary">{{ getName }}のページを見る</v-btn>
      </div>
    </div>
  </v-card>
</template>

<script>
export default {
  props: {
    user: {
      type: Object,
      default: null
    }
  },
  computed: {
    getUserId () {
      return this.user && this.user.id
    },
    getName () {
      if (!this.user) {
        return undefined
      }
      return this.user.name
    },
    getProfile () {
      return this.user && this.user.profile
    },
    getAddress () {
      return this.user && this.user.address
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
