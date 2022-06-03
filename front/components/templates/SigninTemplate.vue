<template>
  <OneColumnContainer>
    <Loading v-if="loading" />
    <Message v-if="!loading" :alert="alert" :notice="notice" />

    <h1 class="main-heading mb-8 text-center">ログイン</h1>

    <v-row justify="center">
      <v-col cols="12" sm="10" md="8">
        <SigninCard :processing="processing" :errors="errors" @signin="onSignin" />
      </v-col>
    </v-row>
  </OneColumnContainer>
</template>

<script>
import OneColumnContainer from '~/components/molecules/containers/OneColumnContainer'
import SigninCard from '~/components/organisms/cards/SigninCard'

export default {
  components: {
    OneColumnContainer,
    SigninCard
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
    onSignin (value) {
      this.$emit('signin', value)
    }
  }
}
</script>
