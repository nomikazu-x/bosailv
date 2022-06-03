<template>
  <OneColumnContainer>
    <Loading v-if="loading" />
    <Message v-if="!loading" :alert="alert" :notice="notice" />

    <h1 class="main-heading mb-8 text-center">新規登録</h1>

    <v-row justify="center">
      <v-col cols="12" sm="10" md="8">
        <SignupCard :processing="processing" :errors="errors" @signup="onSignup" />
      </v-col>
    </v-row>
  </OneColumnContainer>
</template>

<script>
import OneColumnContainer from '~/components/molecules/containers/OneColumnContainer'
import Message from '~/components/Message'
import SignupCard from '~/components/organisms/cards/SignupCard'

export default {
  components: {
    OneColumnContainer,
    Message,
    SignupCard
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
    onSignup (value) {
      this.$emit('signup', value)
    }
  }
}
</script>
