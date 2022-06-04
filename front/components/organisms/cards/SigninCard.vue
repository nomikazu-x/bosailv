<template>
  <v-card class="pa-6">
    <h2 class="mb-3 text-center">BosaiLevel</h2>

    <v-row justify="center">
      <v-col cols="12" sm="8" md="6">
        <Processing v-if="processing" />

        <SigninForm :processing="processing" :errors="errors" @signin="onSignin" />
      </v-col>

      <v-col cols="12" sm="12" md="9" class="text-right">
        <v-divider class="mb-2" />

        <ul class="list-style-none pl-0">
          <li class="mb-1"><NuxtLink to="/password/reset">パスワードをリセット</NuxtLink></li>
          <li class="mb-1"><NuxtLink to="/signup">新規登録へ</NuxtLink></li>
        </ul>
      </v-col>
    </v-row>
  </v-card>
</template>

<script>
export default {
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
    onSignin (value) {
      this.$emit('signin', value)
    }
  }
}
</script>
