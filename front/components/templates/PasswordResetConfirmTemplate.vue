<template>
  <OneColumnContainer>
    <h1 class="main-heading mb-8 text-center">新しいパスワードを入力してください</h1>

    <Loading v-if="loading" />
    <Message v-if="!loading" :alert="alert" :notice="notice" />

    <v-row v-if="!loading" justify="center">
      <v-col cols="12" sm="10">
        <PasswordResetConfirmCard
          :processing="processing"
          :errors="errors"
          @submit="onSubmit"
        />
      </v-col>
    </v-row>
  </OneColumnContainer>
</template>

<script>
export default {
  props: {
    errors: {
      type: Object,
      default: undefined
    },
    processing: {
      type: Boolean,
      default: false
    },
    loading: {
      type: Boolean,
      default: false
    },
    alert: {
      type: String,
      default: null
    },
    notice: {
      type: String,
      default: null
    }
  },
  methods: {
    onSubmit (value) {
      return this.$emit('submit', value)
    }
  }
}
</script>
