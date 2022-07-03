<template>
  <ValidationObserver v-slot="{ invalid }" ref="observer">
    <TheProcessing v-if="processing" />
    <v-form autocomplete="on">
      <EmailTextField
        v-model="email"
      />

      <div class="d-flex justify-end">
        <RedBtn
          type="submit"
          :disabled="invalid || processing"
          @click="onSubmit"
        >
          送信
        </RedBtn>
      </div>
    </v-form>
  </ValidationObserver>
</template>

<script>export default {
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
  data () {
    return {
      email: ''
    }
  },
  methods: {
    onSubmit () {
      this.$emit('submit', this.email)
    }
  }
}
</script>
