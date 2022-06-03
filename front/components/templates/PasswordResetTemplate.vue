<template>
  <OneColumnContainer>
    <Loading v-if="loading" />
    <Message v-if="!loading" :alert="alert" :notice="notice" />

    <h1 class="main-heading mb-8 text-center">パスワードをリセットする</h1>

    <v-row justify="center">
      <v-col cols="12" sm="10">
        <PasswordResetCard :processing="processing" :errors="errors" @submit="onSubmit" />
      </v-col>
    </v-row>
  </OneColumnContainer>
</template>

<script>
import OneColumnContainer from '~/components/molecules/containers/OneColumnContainer'
import PasswordResetCard from '~/components/organisms/cards/PasswordResetCard'

export default {
  components: {
    OneColumnContainer,
    PasswordResetCard
  },
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
