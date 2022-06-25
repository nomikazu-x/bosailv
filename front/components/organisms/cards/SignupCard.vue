<template>
  <BaseTitleCard title="新規登録">
    <div class="pa-5">
      <v-row justify="center">
        <v-col cols="12" sm="8" md="6">
          <SignupForm
            :processing="processing"
            :errors="errors"
            @signup="onSignup"
          />
        </v-col>

        <v-col cols="12" sm="12" md="9" class="text-right">
          <v-divider class="mb-2" />

          <ul class="list-style-none pl-0">
            <li class="mb-1"><NuxtLink to="/password/reset">パスワードをリセット</NuxtLink></li>
            <li class="mb-1"><NuxtLink to="/signin">ログインへ</NuxtLink></li>
          </ul>
        </v-col>
      </v-row>
    </div>
  </BaseTitleCard>
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
