<template>
  <span>
    <GreenBtn v-if="isCompleted" large @click="onUnComplete">
      未完了
    </GreenBtn>
    <OrangeBtn v-else large @click="onComplete">
      完了!
    </OrangeBtn>
  </span>
</template>

<script>
import OrangeBtn from '~/components/atoms/btns/OrangeBtn.vue'
import GreenBtn from '~/components/atoms/btns/GreenBtn.vue'

export default {
  name: 'CompleteBtnGroup',

  components: {
    OrangeBtn,
    GreenBtn
  },

  props: {
    task: {
      type: Object,
      default: null
    }
  },

  data () {
    return {
      isCompleted: this.task.is_completed
    }
  },

  methods: {
    onComplete () {
      this.$emit('complete')
      this.isCompleted = true
    },

    onUnComplete () {
      this.$emit('un-complete')
      this.isCompleted = false
    }
  }
}
</script>
