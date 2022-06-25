<template>
  <BaseTitleCard title="新しいパスワードを入力してください">
    <div class="pa-5">
      <v-row justify="center">
        <v-col cols="12" sm="8">
          <PasswordResetConfirmForm
            :processing="processing"
            :errors="errors"
            @submit="onSubmit"
          />
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
