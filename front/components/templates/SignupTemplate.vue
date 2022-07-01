<template>
  <OneColumnContainer>
    <h1 class="main-heading mb-8 text-center">BosaiLevel</h1>

    <TheLoading v-if="loading" />
    <TheMessage v-if="!loading" :alert="alert" :notice="notice" />

    <v-row v-if="!loading" justify="center">
      <v-col cols="12" sm="10" md="8">
        <SignupCard
          :processing="processing"
          :errors="errors"
          @signup="onSignup"
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
    onSignup (value) {
      this.$emit('signup', value)
    }
  }
}
</script>
