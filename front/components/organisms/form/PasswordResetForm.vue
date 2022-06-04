<template>
  <ValidationObserver v-slot="{ invalid }" ref="observer">
    <v-form autocomplete="on">
      <EmailTextField v-model="email" />

      <div class="d-flex justify-end">
        <OrangeBtn type="submit" :disabled="invalid || processing" @click="onSubmit">
          送信
        </OrangeBtn>
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
      this.validate()
      this.$emit('submit', this.email)
    },
    validate () {
      this.$refs.observer.validate()
    }
  }
}
</script>
