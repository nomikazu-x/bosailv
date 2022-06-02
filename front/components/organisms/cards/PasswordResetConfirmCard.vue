<template>
  <v-card class="pt-10 px-6 pb-8">
    <v-row justify="center">
      <v-col cols="12" sm="8">
        <Processing v-if="processing" />

        <PasswordResetConfirmForm :processing="processing" :errors="errors" @submit="onSubmit" />
      </v-col>
    </v-row>
  </v-card>
</template>

<script>
import PasswordResetConfirmForm from '~/components/organisms/form/PasswordResetConfirmForm'

export default {
  components: {
    PasswordResetConfirmForm
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
      this.$emit('submit', value)
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
