<template>
  <v-card class="pt-10 px-6 pb-8">
    <h2 class="mb-3 text-center">メールアドレスを入力</h2>

    <v-row justify="center">
      <v-col cols="12" sm="8">
        <Processing v-if="processing" />

        <PasswordResetForm :processing="processing" :errors="errors" @submit="onSubmit" />
      </v-col>

      <v-col cols="12" sm="12">
        <v-divider class="mb-2" />

        <ul class="pl-0">
          <li class="mb-1"><nuxt-link to="/signin">ログインへ</nuxt-link></li>
          <li class="mb-1"><nuxt-link to="/signup">新規登録へ</nuxt-link></li>
        </ul>
      </v-col>
    </v-row>
  </v-card>
</template>

<script>
import PasswordResetForm from '~/components/organisms/form/PasswordResetForm'

export default {
  components: {
    PasswordResetForm
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
    onSubmit (value) {
      return this.$emit('submit', value)
    }
  }
}
</script>
