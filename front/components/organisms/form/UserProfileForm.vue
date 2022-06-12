<template>
  <ValidationObserver v-slot="{ invalid }" ref="observer">
    <Processing v-if="processing" />
    <v-form autocomplete="off">
      <v-card-text>
        <UserNameTextField
          v-model="name"
        />
        <PrefecturesSelect
          v-model="selectPrefecture"
          :prefectures="prefectures"
        />
        <OrangeBtn
          id="user_update_btn"
          :disabled="invalid || processing"
          @click="onUserUpdate"
        >
          変更
        </OrangeBtn>
      </v-card-text>
    </v-form>
  </ValidationObserver>
</template>

<script>
export default {
  name: 'InfoEdit',
  props: {
    processing: {
      type: Boolean,
      default: false
    },
    prefectures: {
      type: Array,
      default: () => []
    },
    user: {
      type: Object,
      default: null
    }
  },

  data () {
    return {
      name: '',
      selectPrefecture: null
    }
  },

  created () {
    this.name = this.name || this.user.name
    this.selectPrefecture = this.selectPrefecture || this.user.prefecture
    console.log(this.user.prefecture)
  },

  methods: {
    onUserUpdate () {
      const userInfo = {
        name: this.name,
        selectPrefecture: this.selectPrefecture
      }
      this.$emit('user-update', userInfo)
    }
  }
}
</script>
