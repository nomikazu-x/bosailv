<template>
  <ValidationObserver v-slot="{ invalid }" ref="observer">
    <v-form autocomplete="on" @submit.prevent="onSubmit">
      <EmailTextField v-model="email" />

      <div class="d-flex justify-end">
        <OrangeBtn type="submit" :disabled="invalid || processing">
          送信
        </OrangeBtn>
      </div>
    </v-form>
  </ValidationObserver>
</template>

<script>
import EmailTextField from '~/components/organisms/textFields/EmailTextField'
import OrangeBtn from '~/components/atoms/btns/OrangeBtn'

export default {
  components: {
    EmailTextField,
    OrangeBtn
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
  data () {
    return {
      email: '',
      password: ''
    }
  },
  methods: {
    onSubmit () {
      this.validate()
      const userInfo = {
        email: this.email
      }
      this.$emit('signin', userInfo)
    },
    validate () {
      this.$refs.observer.validate()
    }
  }
}
</script>
