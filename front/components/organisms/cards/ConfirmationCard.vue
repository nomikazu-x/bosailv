<template>
  <v-card class="pt-10 px-6 pb-8">
    <h2 class="mb-3 text-center">メールアドレスを確認</h2>

    <v-row justify="center">
      <v-col cols="12" sm="8">
        <Processing v-if="processing" />

        <ConfirmationForm :processing="processing" :errors="errors" @confirmation="onpConfirmation" />
      </v-col>

      <v-col cols="12" sm="12">
        <v-divider class="mb-2" />

        <ul class="pl-0">
          <li class="mb-1"><nuxt-link to="/users/sign_in">ログインへ</nuxt-link></li>
          <li class="mb-1"><nuxt-link to="/users/sign_up">新規登録へ</nuxt-link></li>
        </ul>
      </v-col>
    </v-row>
  </v-card>
</template>

<script>
import ConfirmationForm from '~/components/organisms/form/ConfirmationForm'

export default {
  components: {
    ConfirmationForm
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
    onConfirmation (value) {
      this.$emit('confirmation', value)
    }
  }
}
</script>
