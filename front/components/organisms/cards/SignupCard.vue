<template>
  <v-card class="pa-6">
    <h2 class="mb-3 text-center">BosaiLevel</h2>

    <v-row justify="center">
      <v-col cols="12" sm="8" md="6">
        <Processing v-if="processing" />

        <SignupForm :processing="processing" :errors="errors" @signup="onSignup" />
      </v-col>

      <v-col cols="12" sm="12" md="9" class="text-right">
        <v-divider class="mb-2" />

        <ul class="pl-0">
          <li class="mb-1"><nuxt-link to="/users/password/new">パスワードをリセット</nuxt-link></li>
          <li class="mb-1"><nuxt-link to="/users/sign_in">ログインへ</nuxt-link></li>
        </ul>
      </v-col>
    </v-row>
  </v-card>
</template>

<script>
import SignupForm from '~/components/organisms/form/SignupForm'

export default {
  components: {
    SignupForm
  },
  props: {
    processing: {
      type: Boolean,
      default: false
    },
    errors: {
      type: Object,
      default: undefined
    }
  },
  methods: {
    onSignup (value) {
      this.$emit('signup', value)
    }
  }
}
</script>

<style lang="scss" scoped>
.other-heading {
  font-size: 1rem;
  font-weight: normal;
  margin-bottom: 0.5rem;
}
</style>
